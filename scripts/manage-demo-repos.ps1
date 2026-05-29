<#
.SYNOPSIS
Creates, deletes, or lists one GitHub repository per matching child folder.

.DESCRIPTION
This script is intended for the Build 2026 app modernization demo folders.
It uses the GitHub CLI (`gh`) to create/delete repositories and `git` to
commit, configure remotes, and push each folder.

By default it scans src\Build2026GHCPAppModDemoWare, only includes folders
whose names start with "Zava" and contain a .git item, prefixes each
repository with "mnm-", writes full repository URLs to config.json at the
repository root, and processes create/delete actions in parallel.
It also writes modernize\config.json with the same entries under
command_center.repo.

.EXAMPLE
.\scripts\manage-demo-repos.ps1 -Action List

Regenerates config.json without creating or deleting GitHub repositories.

.\scripts\manage-demo-repos.ps1 -Action Create -Visibility private

Creates private repositories under crgarcia12, commits any local changes in
each folder, sets origin, and pushes the current branch.

.EXAMPLE
.\scripts\manage-demo-repos.ps1 -Action Delete

Deletes the generated repositories under crgarcia12. Local folders are not
deleted.
#>

[CmdletBinding()]
param(
    [ValidateSet('Create', 'Delete', 'List')]
    [string]$Action = 'Create',

    [string]$SourcePath,

    [ValidatePattern('^[A-Za-z0-9._-]+$')]
    [string]$Prefix = 'mnm-',

    [string]$RepoListPath,

    [string]$ModernizeConfigPath,

    [string]$Owner = 'crgarcia12',

    [string]$FolderNamePrefix = 'Zava',

    [bool]$RequireGitRepository = $true,

    [ValidateSet('private', 'public', 'internal')]
    [string]$Visibility = 'private',

    [string]$DefaultBranch = 'main',

    [string[]]$ExcludeDirectory = @(),

    [switch]$IncludeDotDirectories,

    [switch]$OverwriteRemote,

    [switch]$RemoveRemoteOnDelete,

    [switch]$DryRun,

    [switch]$SkipValidation,

    [int]$MaxParallel = 0,

    [string]$OnlyFolder,

    [switch]$NoParallel,

    [switch]$SkipRepoList,

    [switch]$SkipModernizeConfig,

    [string]$LogPrefix
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if ([string]::IsNullOrWhiteSpace($SourcePath)) {
    $SourcePath = Join-Path $repoRoot 'src\Build2026GHCPAppModDemoWare'
}
if ([string]::IsNullOrWhiteSpace($RepoListPath)) {
    $RepoListPath = Join-Path $repoRoot 'config.json'
}
if ([string]::IsNullOrWhiteSpace($ModernizeConfigPath)) {
    $ModernizeConfigPath = Join-Path $repoRoot 'modernize\config.json'
}

function Write-Log {
    param([Parameter(Mandatory)][string]$Message)

    if ([string]::IsNullOrWhiteSpace($LogPrefix)) {
        Write-Host $Message
    }
    else {
        Write-Host "[$LogPrefix] $Message"
    }
}

function Assert-Tool {
    param([Parameter(Mandatory)][string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required CLI '$Name' was not found on PATH."
    }
}

function Invoke-CheckedCommand {
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string[]]$Arguments,
        [Parameter(Mandatory)][string]$Description
    )

    Write-Log "-> $Description"
    if ($DryRun) {
        Write-Log "   [dry-run] $FilePath $($Arguments -join ' ')"
        return
    }

    & $FilePath @Arguments 2>&1 | ForEach-Object {
        Write-Log "   $_"
    }

    if ($LASTEXITCODE -ne 0) {
        throw "$Description failed with exit code $LASTEXITCODE."
    }
}

function Invoke-CapturedCommand {
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string[]]$Arguments,
        [switch]$IgnoreFailure
    )

    $output = & $FilePath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0 -and -not $IgnoreFailure) {
        throw "$FilePath $($Arguments -join ' ') failed with exit code $exitCode.`n$output"
    }

    [pscustomobject]@{
        ExitCode = $exitCode
        Output   = ($output -join [Environment]::NewLine)
    }
}

function Resolve-GitHubOwner {
    if (-not [string]::IsNullOrWhiteSpace($Owner)) {
        return $Owner
    }

    $result = Invoke-CapturedCommand -FilePath 'gh' -Arguments @('api', 'user', '--jq', '.login') -IgnoreFailure
    if ($result.ExitCode -ne 0 -or [string]::IsNullOrWhiteSpace($result.Output)) {
        throw "Could not determine the GitHub owner from gh auth. Pass -Owner explicitly."
    }

    return $result.Output.Trim()
}

function Test-GitHubRepository {
    param([Parameter(Mandatory)][string]$FullName)

    if ($DryRun) {
        return $false
    }

    $result = Invoke-CapturedCommand -FilePath 'gh' -Arguments @('repo', 'view', $FullName, '--json', 'name', '--jq', '.name') -IgnoreFailure
    return $result.ExitCode -eq 0
}

function Get-RepositoryEntries {
    $resolvedSourcePath = (Resolve-Path -LiteralPath $SourcePath).Path
    $directories = @(Get-ChildItem -LiteralPath $resolvedSourcePath -Directory -Force |
        Where-Object { $IncludeDotDirectories -or -not $_.Name.StartsWith('.') } |
        Where-Object { [string]::IsNullOrWhiteSpace($FolderNamePrefix) -or $_.Name.StartsWith($FolderNamePrefix, [StringComparison]::OrdinalIgnoreCase) } |
        Where-Object { [string]::IsNullOrWhiteSpace($OnlyFolder) -or $_.Name -eq $OnlyFolder } |
        Where-Object { -not $RequireGitRepository -or (Test-Path -LiteralPath (Join-Path $_.FullName '.git')) } |
        Where-Object { $ExcludeDirectory -notcontains $_.Name } |
        Sort-Object Name)

    if ($directories.Count -eq 0) {
        throw "No matching child directories found in $resolvedSourcePath."
    }

    $entries = @(foreach ($directory in $directories) {
        $repositoryName = "$Prefix$($directory.Name)"
        if ($repositoryName -notmatch '^[A-Za-z0-9._-]+$') {
            throw "Generated repository name '$repositoryName' is invalid. GitHub names can use letters, numbers, '.', '_', and '-'."
        }

        [pscustomobject]@{
            Folder         = $directory.Name
            Directory      = $directory.FullName
            RepositoryName = $repositoryName
        }
    })

    return $entries
}

function New-RepositoryConfig {
    param(
        [Parameter(Mandatory)]$Entries,
        [string]$ResolvedOwner
    )

    @(foreach ($entry in $Entries) {
        [ordered]@{
            name = $entry.Folder
            url  = if ([string]::IsNullOrWhiteSpace($ResolvedOwner)) {
                $entry.RepositoryName
            }
            else {
                "https://github.com/$ResolvedOwner/$($entry.RepositoryName)"
            }
        }
    })
}

function Write-JsonFile {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)]$Value,
        [Parameter(Mandatory)][string]$Description
    )

    $fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    $directory = Split-Path -Parent $fullPath
    if (-not (Test-Path -LiteralPath $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    $json = ConvertTo-Json -InputObject $Value -Depth 5
    Set-Content -LiteralPath $fullPath -Value $json -Encoding utf8
    Write-Log "Wrote $Description to $fullPath"
}

function Write-RepositoryList {
    param(
        [Parameter(Mandatory)]$Entries,
        [string]$ResolvedOwner
    )

    $config = @(New-RepositoryConfig -Entries $Entries -ResolvedOwner $ResolvedOwner)
    Write-JsonFile -Path $RepoListPath -Value $config -Description "$($config.Count) repositories"
}

function Write-ModernizeConfig {
    param(
        [Parameter(Mandatory)]$Entries,
        [string]$ResolvedOwner
    )

    $config = [ordered]@{}
    $commandCenter = [ordered]@{}
    $fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ModernizeConfigPath)
    if (Test-Path -LiteralPath $fullPath) {
        $rawConfig = Get-Content -Raw -LiteralPath $fullPath
        if (-not [string]::IsNullOrWhiteSpace($rawConfig)) {
            $existingConfig = $rawConfig | ConvertFrom-Json
            foreach ($property in $existingConfig.PSObject.Properties) {
                if ($property.Name -eq 'command_center') {
                    foreach ($commandCenterProperty in $property.Value.PSObject.Properties) {
                        if ($commandCenterProperty.Name -ne 'repo') {
                            $commandCenter[$commandCenterProperty.Name] = $commandCenterProperty.Value
                        }
                    }
                }
                elseif ($property.Name -ne 'repo') {
                    $config[$property.Name] = $property.Value
                }
            }
        }
    }

    $commandCenter['repo'] = @(New-RepositoryConfig -Entries $Entries -ResolvedOwner $ResolvedOwner)
    $config['command_center'] = $commandCenter
    Write-JsonFile -Path $ModernizeConfigPath -Value $config -Description "modernize repo config"
}

function Ensure-LocalCommit {
    param([Parameter(Mandatory)]$Entry)

    $gitDirectory = Join-Path $Entry.Directory '.git'
    if (-not (Test-Path -LiteralPath $gitDirectory)) {
        throw "Folder '$($Entry.Folder)' is not a standalone git repository because it does not contain .git."
    }

    $status = Invoke-CapturedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'status', '--porcelain')
    if (-not [string]::IsNullOrWhiteSpace($status.Output)) {
        Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'add', '-A') -Description "Stage files in $($Entry.Folder)"
        Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'commit', '-m', 'Initial commit') -Description "Commit files in $($Entry.Folder)"
    }

    $head = Invoke-CapturedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'rev-parse', '--verify', 'HEAD') -IgnoreFailure
    if ($head.ExitCode -ne 0) {
        throw "Folder '$($Entry.Folder)' has no commit to push. Add files to the folder or commit manually."
    }
}

function Set-OriginRemote {
    param(
        [Parameter(Mandatory)]$Entry,
        [Parameter(Mandatory)][string]$RemoteUrl
    )

    $existingRemote = Invoke-CapturedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'remote', 'get-url', 'origin') -IgnoreFailure
    if ($existingRemote.ExitCode -eq 0) {
        $currentUrl = $existingRemote.Output.Trim()
        if ($currentUrl -eq $RemoteUrl) {
            return
        }

        if (-not $OverwriteRemote) {
            throw "Folder '$($Entry.Folder)' already has origin '$currentUrl'. Rerun with -OverwriteRemote to point it to '$RemoteUrl'."
        }

        Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'remote', 'set-url', 'origin', $RemoteUrl) -Description "Update origin for $($Entry.Folder)"
    }
    else {
        Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'remote', 'add', 'origin', $RemoteUrl) -Description "Add origin for $($Entry.Folder)"
    }
}

function Set-WorkingBranch {
    param([Parameter(Mandatory)]$Entry)

    $branch = (Invoke-CapturedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'branch', '--show-current')).Output.Trim()
    if (-not [string]::IsNullOrWhiteSpace($branch)) {
        return $branch
    }

    Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'switch', '-C', $DefaultBranch) -Description "Create and switch to $DefaultBranch for $($Entry.Folder)"
    return $DefaultBranch
}

function Test-RepositoryUpload {
    param(
        [Parameter(Mandatory)]$Entry,
        [Parameter(Mandatory)][string]$ResolvedOwner,
        [Parameter(Mandatory)][string]$Branch
    )

    $fullName = "$ResolvedOwner/$($Entry.RepositoryName)"
    $remoteUrl = "https://github.com/$fullName.git"

    Write-Log "-> Validate upload for $fullName"
    if (-not (Test-GitHubRepository -FullName $fullName)) {
        throw "Validation failed: GitHub repository '$fullName' does not exist."
    }

    $localHead = (Invoke-CapturedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'rev-parse', 'HEAD')).Output.Trim()
    $remoteHeadLine = (Invoke-CapturedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'ls-remote', $remoteUrl, "refs/heads/$Branch")).Output.Trim()
    if ([string]::IsNullOrWhiteSpace($remoteHeadLine)) {
        throw "Validation failed: '$fullName' does not have branch '$Branch'."
    }

    $remoteHead = ($remoteHeadLine -split '\s+')[0]
    if ($remoteHead -ne $localHead) {
        throw "Validation failed: '$fullName' branch '$Branch' is at $remoteHead but local HEAD is $localHead."
    }

    Write-Log "   validated $fullName@$Branch matches local HEAD $($localHead.Substring(0, 12))"
}

function Create-Repository {
    param(
        [Parameter(Mandatory)]$Entry,
        [Parameter(Mandatory)][string]$ResolvedOwner
    )

    $fullName = "$ResolvedOwner/$($Entry.RepositoryName)"
    $remoteUrl = "https://github.com/$fullName.git"

    if ($DryRun) {
        Invoke-CheckedCommand -FilePath 'gh' -Arguments @('repo', 'create', $fullName, "--$Visibility") -Description "Create GitHub repo $fullName"
        Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'add', '-A') -Description "Stage files in $($Entry.Folder)"
        Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'commit', '-m', 'Initial commit') -Description "Commit files in $($Entry.Folder)"
        Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'remote', 'add', 'origin', $remoteUrl) -Description "Add origin for $($Entry.Folder)"
        Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'switch', '-C', $DefaultBranch) -Description "Create and switch to $DefaultBranch for $($Entry.Folder)"
        Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'push', '-u', 'origin', $DefaultBranch) -Description "Push $($Entry.Folder) to $fullName"
        return
    }

    if (Test-GitHubRepository -FullName $fullName) {
        Write-Host "Repository $fullName already exists; skipping gh repo create."
    }
    else {
        Invoke-CheckedCommand -FilePath 'gh' -Arguments @('repo', 'create', $fullName, "--$Visibility") -Description "Create GitHub repo $fullName"
    }

    Ensure-LocalCommit -Entry $Entry
    Set-OriginRemote -Entry $Entry -RemoteUrl $remoteUrl

    $branch = Set-WorkingBranch -Entry $Entry
    Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'push', '-u', 'origin', $branch) -Description "Push $($Entry.Folder) to $fullName"

    if (-not $SkipValidation) {
        Test-RepositoryUpload -Entry $Entry -ResolvedOwner $ResolvedOwner -Branch $branch
    }
}

function Delete-Repository {
    param(
        [Parameter(Mandatory)]$Entry,
        [Parameter(Mandatory)][string]$ResolvedOwner
    )

    $fullName = "$ResolvedOwner/$($Entry.RepositoryName)"
    if ($DryRun) {
        Invoke-CheckedCommand -FilePath 'gh' -Arguments @('repo', 'delete', $fullName, '--yes') -Description "Delete GitHub repo $fullName"
        if ($RemoveRemoteOnDelete) {
            Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'remote', 'remove', 'origin') -Description "Remove origin from $($Entry.Folder)"
        }
        return
    }

    if (Test-GitHubRepository -FullName $fullName) {
        Invoke-CheckedCommand -FilePath 'gh' -Arguments @('repo', 'delete', $fullName, '--yes') -Description "Delete GitHub repo $fullName"
    }
    else {
        Write-Host "Repository $fullName does not exist; skipping delete."
    }

    if ($RemoveRemoteOnDelete) {
        $remoteUrl = "https://github.com/$fullName.git"
        $existingRemote = Invoke-CapturedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'remote', 'get-url', 'origin') -IgnoreFailure
        if ($existingRemote.ExitCode -eq 0 -and $existingRemote.Output.Trim() -eq $remoteUrl) {
            Invoke-CheckedCommand -FilePath 'git' -Arguments @('-C', $Entry.Directory, 'remote', 'remove', 'origin') -Description "Remove origin from $($Entry.Folder)"
        }
    }
}

function Receive-RepositoryJobs {
    param(
        [Parameter(Mandatory)][object[]]$Jobs,
        [AllowEmptyCollection()][System.Collections.Generic.List[string]]$Failures,
        [switch]$DrainCompleted
    )

    foreach ($job in @($Jobs)) {
        Receive-Job -Job $job

        if ($DrainCompleted -and $job.State -in @('Completed', 'Failed', 'Stopped')) {
            if ($job.State -eq 'Completed') {
                Write-Log "Completed $($job.Name)"
            }
            else {
                $reason = $job.ChildJobs[0].JobStateInfo.Reason
                if ($reason) {
                    Write-Log "Failed $($job.Name): $reason"
                    $Failures.Add("$($job.Name): $reason")
                }
                else {
                    Write-Log "Failed $($job.Name): job state $($job.State)"
                    $Failures.Add("$($job.Name): job state $($job.State)")
                }
            }

            Remove-Job -Job $job -Force
        }
    }
}

function Invoke-RepositoryActionsInParallel {
    param(
        [Parameter(Mandatory)]$Entries,
        [Parameter(Mandatory)][string]$ResolvedOwner
    )

    $scriptPath = $PSCommandPath
    if ([string]::IsNullOrWhiteSpace($scriptPath)) {
        $scriptPath = $MyInvocation.MyCommand.Path
    }
    if ([string]::IsNullOrWhiteSpace($scriptPath)) {
        throw 'Could not determine the script path for parallel execution.'
    }

    $throttleLimit = $MaxParallel
    if ($throttleLimit -lt 1) {
        $throttleLimit = $Entries.Count
    }

    Write-Log "Running $Action for $($Entries.Count) repositories in parallel with throttle $throttleLimit."

    $jobs = @()
    $failures = [System.Collections.Generic.List[string]]::new()

    foreach ($entry in $Entries) {
        while (@($jobs | Where-Object { $_.State -eq 'Running' }).Count -ge $throttleLimit) {
            Receive-RepositoryJobs -Jobs $jobs -Failures $failures -DrainCompleted
            $jobs = @($jobs | Where-Object { $_.State -eq 'Running' -or $_.State -eq 'NotStarted' })
            Start-Sleep -Milliseconds 500
        }

        $parameters = @{
            Action               = $Action
            SourcePath           = $SourcePath
            Prefix               = $Prefix
            RepoListPath         = $RepoListPath
            ModernizeConfigPath  = $ModernizeConfigPath
            Owner                = $ResolvedOwner
            FolderNamePrefix     = $FolderNamePrefix
            RequireGitRepository = $RequireGitRepository
            Visibility           = $Visibility
            DefaultBranch        = $DefaultBranch
            ExcludeDirectory     = $ExcludeDirectory
            OnlyFolder           = $entry.Folder
            NoParallel           = $true
            SkipRepoList         = $true
            SkipModernizeConfig  = $true
            LogPrefix            = $entry.Folder
        }

        if ($IncludeDotDirectories) {
            $parameters.IncludeDotDirectories = $true
        }
        if ($OverwriteRemote) {
            $parameters.OverwriteRemote = $true
        }
        if ($RemoveRemoteOnDelete) {
            $parameters.RemoveRemoteOnDelete = $true
        }
        if ($DryRun) {
            $parameters.DryRun = $true
        }
        if ($SkipValidation) {
            $parameters.SkipValidation = $true
        }

        Write-Log "Starting $Action for $($entry.Folder)"
        $jobs += Start-Job -Name $entry.Folder -ScriptBlock {
            param(
                [Parameter(Mandatory)][string]$ScriptPath,
                [Parameter(Mandatory)][hashtable]$Parameters
            )

            & $ScriptPath @Parameters
        } -ArgumentList $scriptPath, $parameters
    }

    while ($jobs.Count -gt 0) {
        Receive-RepositoryJobs -Jobs $jobs -Failures $failures -DrainCompleted
        $jobs = @($jobs | Where-Object { $_.State -eq 'Running' -or $_.State -eq 'NotStarted' })
        if ($jobs.Count -gt 0) {
            Start-Sleep -Milliseconds 500
        }
    }

    if ($failures.Count -gt 0) {
        throw "$($failures.Count) repository job(s) failed: $($failures -join '; ')"
    }
}

if ($Action -in @('Create', 'Delete')) {
    Assert-Tool -Name 'gh'
}
if ($Action -eq 'Create') {
    Assert-Tool -Name 'git'
}

$entries = Get-RepositoryEntries
$resolvedOwner = $null
if ($Action -in @('Create', 'Delete')) {
    $resolvedOwner = Resolve-GitHubOwner
}
elseif (-not [string]::IsNullOrWhiteSpace($Owner)) {
    $resolvedOwner = $Owner
}

if (-not $SkipRepoList) {
    Write-RepositoryList -Entries $entries -ResolvedOwner $resolvedOwner
}
if (-not $SkipModernizeConfig) {
    Write-ModernizeConfig -Entries $entries -ResolvedOwner $resolvedOwner
}

switch ($Action) {
    'List' {
        $entries | Select-Object Folder, RepositoryName | Format-Table -AutoSize
    }
    'Create' {
        if ($NoParallel -or $entries.Count -le 1) {
            foreach ($entry in $entries) {
                Create-Repository -Entry $entry -ResolvedOwner $resolvedOwner
            }
        }
        else {
            Invoke-RepositoryActionsInParallel -Entries $entries -ResolvedOwner $resolvedOwner
        }
    }
    'Delete' {
        if ($NoParallel -or $entries.Count -le 1) {
            foreach ($entry in $entries) {
                Delete-Repository -Entry $entry -ResolvedOwner $resolvedOwner
            }
        }
        else {
            Invoke-RepositoryActionsInParallel -Entries $entries -ResolvedOwner $resolvedOwner
        }
    }
}
