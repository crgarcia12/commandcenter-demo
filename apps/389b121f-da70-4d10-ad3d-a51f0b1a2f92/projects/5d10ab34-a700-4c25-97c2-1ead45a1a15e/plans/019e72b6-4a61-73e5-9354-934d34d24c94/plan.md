# Modernization Plan: Zava Auth Gateway — Modernize and Deploy to Azure

**Project**: ZavaAuthGateway

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: ASP.NET Web Forms (`.aspx`, `.ashx` HTTP Handlers)
- **Build Tool**: MSBuild (legacy non-SDK project format, `packages.config`)
- **Database**: SQL Server (ADO.NET, `System.Data.SqlClient`, username/password auth)
- **Key Dependencies**: System.Web, System.Data, System.Configuration (all BCL/GAC)
- **Container**: Mono 6.12 (Dockerfile uses `mono:6.12` / `xsp4`)

---

## Overview

This migration modernizes the ZavaAuthGateway from a .NET Framework 4.8 ASP.NET WebForms application running on Mono to a fully cloud-native .NET 10 ASP.NET Core application deployed on Azure Container Apps. The application currently handles user authentication, session token management, and auth-validation via a SQL Server database using username/password credentials. The new architecture will:

- Replace the legacy .NET Framework 4.8 / WebForms / Mono stack with .NET 10 / ASP.NET Core for proper Linux container support and modern Azure SDK compatibility.
- Migrate SQL Server connectivity to Azure SQL Database using Managed Identity, eliminating hardcoded credentials.
- Configure structured console logging suitable for cloud/container log aggregation on Azure.
- Scan and remediate known CVEs in project dependencies before deployment.
- Containerize the modernized application and deploy it to Azure Container Apps.

The migration follows a sequential approach: upgrade the runtime first, then migrate Azure services, harden security, and finally deploy.

---

## Migration Impact Summary

| Application       | Original Service              | New Azure Service         | Authentication     | Comments                                          |
|-------------------|-------------------------------|---------------------------|--------------------|---------------------------------------------------|
| ZavaAuthGateway   | SQL Server (username/password)| Azure SQL Database        | Managed Identity   | Remove hardcoded DB credentials from web.config   |
| ZavaAuthGateway   | .NET Framework 4.8 WebForms   | .NET 10 ASP.NET Core      | N/A                | Convert from WebForms to ASP.NET Core; SDK-style  |
| ZavaAuthGateway   | Mono 6.12 / xsp4 Docker       | Azure Container Apps      | N/A                | Replace Mono image with official .NET 10 runtime  |
| ZavaAuthGateway   | Console output (raw)          | Structured console logging| N/A                | Enable cloud-compatible log aggregation           |

---

## Tasks

### Task 1 — Upgrade .NET to latest LTS (net10.0)

Upgrade the project from .NET Framework 4.8 to .NET 10 and convert the non-SDK-style project to SDK-style format. This is required because ASP.NET WebForms does not run on Linux containers without Mono, and Mono is not a production-supported runtime for Azure. The upgrade converts WebForms pages and HTTP Handlers to their ASP.NET Core equivalents and replaces `packages.config` with `PackageReference`.

### Task 2 — Migrate SQL Server to Azure SQL Database with Managed Identity

Replace the SQL Server connection using username/password credentials with Azure SQL Database using Managed Identity (passwordless authentication). Remove hardcoded credentials from `web.config` and `DbConfig.cs`, and update the `AuthRepository` to use the Azure SQL connection with `DefaultAzureCredential`.

### Task 3 — Configure Console Logging for Cloud

Update the application to emit structured console logs suitable for Azure Container Apps log aggregation. Ensure all diagnostic output flows through the configured logging framework rather than custom or ad-hoc output.

### Task 4 — Security and CVE Remediation

Scan all project dependencies for known CVEs and remediate any identified vulnerabilities before deployment. Verify the project builds and all tests pass after remediation.

### Task 5 — Deploy to Azure Container Apps

Containerize the modernized .NET 10 application with a production-grade Dockerfile and deploy it to Azure Container Apps. This replaces the legacy Mono-based container with the official .NET 10 runtime image.

---

## Open Questions & Questionnaire

- [x] Q: Should infrastructure be provisioned as part of this plan? → A: No — focus on code migration only; deployment task handles resource provisioning via Bicep templates
- [x] Q: Should integration tests be included? → A: No — integration testing not explicitly requested; skipped
- [x] Q: Should security/CVE remediation be included? → A: Yes — include security/CVE remediation (default)
- [x] Q: What Azure deployment target should be used? → A: Azure Container Apps (default)
