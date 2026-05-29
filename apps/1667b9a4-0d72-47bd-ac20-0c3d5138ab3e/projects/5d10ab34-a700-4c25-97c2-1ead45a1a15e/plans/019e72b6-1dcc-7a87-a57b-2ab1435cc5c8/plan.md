# Modernization Plan: Zava Account Manager - Modernize and Deploy to Azure

**Project**: ZavaAccountManager

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: ASP.NET Web Forms 4.8
- **Build Tool**: MSBuild (legacy non-SDK-style project)
- **Database**: SQL Server (raw ADO.NET with `System.Data.SqlClient`, username/password auth)
- **Key Dependencies**: System.Web, System.Data.SqlClient, Mono 6.12 (containerized runtime), external ZavaAuthGateway for authentication, external Ledger HTTP service

---

## Overview

> This migration modernizes the ZavaAccountManager ASP.NET Web Forms application from .NET Framework 4.8 running on Mono to modern .NET 10, and deploys it to Azure Container Apps.
>
> The application currently uses:
> - Mono 6.12 as its container runtime (EOL, not supported in Azure)
> - SQL Server with username/password credentials stored in `web.config`
> - A custom Forms-based authentication via an external ZavaAuthGateway
> - Hardcoded machine keys in `web.config` (security risk)
>
> The new architecture will:
> - **Upgrade to .NET 10 (ASP.NET Core)** to enable modern Azure SDK support and eliminate the Mono dependency
> - **Migrate SQL Server access to Azure SQL Database with Managed Identity**, eliminating hardcoded credentials
> - **Migrate authentication to Microsoft Entra ID**, replacing the legacy ZavaAuthGateway and Forms Authentication with a modern, secure identity provider
> - **Configure structured console logging** for proper cloud-native log aggregation in Azure Container Apps
> - **Remediate known CVEs** in dependencies before deployment
> - **Deploy to Azure Container Apps** with a production-ready containerized setup
>
> The migration follows a phased approach: first upgrading the runtime, then migrating individual Azure services, then securing the application, and finally deploying to Azure.

---

## Migration Impact Summary

| Application          | Original Service              | New Azure Service              | Authentication   | Comments                          |
|----------------------|-------------------------------|--------------------------------|------------------|-----------------------------------|
| ZavaAccountManager   | SQL Server (user/password)    | Azure SQL Database             | Managed Identity | Replace SqlClient connection string |
| ZavaAccountManager   | ZavaAuthGateway / Forms Auth  | Microsoft Entra ID             | OAuth2 / OIDC    | Replace Forms auth + machineKey   |
| ZavaAccountManager   | Console / none                | Azure Monitor / Container Logs | N/A              | Add cloud-native console logging  |
| ZavaAccountManager   | Mono 6.12 container           | Azure Container Apps           | Managed Identity | Upgrade to .NET 10, new Dockerfile |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — no existing infra config found; new resources will be provisioned by the deployment task
- [x] Q: Should the plan include integration testing? → A: No — not explicitly requested; skipped
- [x] Q: Should the plan include security/CVE remediation? → A: Yes (default)
- [x] Q: Which Azure deployment target should be used? → A: Azure Container Apps (default)
