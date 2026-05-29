$modernizeRepo = "https://github.com/crgarcia12/commandcenter-demo"
modernize cc serve
$projectName = "Zava2026"

modernize cc project create --name projectName --goal "modernize Zava app and deploy to Azure"

$repos = (Get-Content repos.json | ConvertFrom-Json)
foreach ($repo in $repos) {
    Write-Host "Registering app: $($repo.name) -> $($repo.url)"
    modernize cc app register --name $repo.name --app-repo $repo.url

    Write-Host "Adding app to project: $($repo.name)"
    modernize cc project app add --project $projectName --app $repo.name
}

# Run assessments
modernize cc assess `
    --project $projectName `
    --delegate cloud `
    --assess-config ./assessment-config.yaml

modernize cc serve
