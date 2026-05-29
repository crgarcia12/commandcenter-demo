# Modernization Plan: Modernize Zava App and Deploy to Azure

**Project**: ZavaReportDashboard

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: ASP.NET Web Forms 4.8
- **Build Tool**: MSBuild
- **Database**: SQL Server (connection string with SQL authentication credentials)
- **Key Dependencies**: System.Data.SqlClient (ADO.NET), System.Web (Forms Authentication)

---

## Overview

> This migration modernizes the ZavaReportDashboard from a legacy ASP.NET Web Forms (.NET Framework 4.8) application to a modern ASP.NET Core (.NET 10) application, and deploys it to Azure Container Apps. The application currently runs in a Mono-based Docker container (a legacy workaround for Linux containers), uses plaintext SQL Server credentials in `web.config`, and relies on Forms Authentication with an external AuthGateway. The new architecture will:
>
> - Run on .NET 10 with a modern ASP.NET Core Razor Pages or MVC application, enabling native Linux container support without Mono
> - Connect to Azure SQL Database using Managed Identity (passwordless authentication), eliminating hardcoded credentials
> - Authenticate users via Microsoft Entra ID, replacing the legacy Forms Authentication and external AuthGateway dependency
> - Be deployed to Azure Container Apps with a modern container image
>
> The migration follows a phased approach: first upgrading the runtime, then migrating individual Azure services, scanning for CVEs, and finally deploying to Azure Container Apps.

---

## Migration Impact Summary

| Application            | Original Service           | New Azure Service          | Authentication   | Comments                              |
|------------------------|----------------------------|----------------------------|------------------|---------------------------------------|
| ZavaReportDashboard    | SQL Server (SQL auth)      | Azure SQL Database         | Managed Identity | Remove plaintext credentials          |
| ZavaReportDashboard    | Forms Auth / AuthGateway   | Microsoft Entra ID         | OAuth 2.0 / OIDC | Replace external AuthGateway          |
| ZavaReportDashboard    | Mono Docker container      | Azure Container Apps       | Managed Identity | Native .NET 10 Linux container        |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — focus on code migration only; new Azure resources will be provisioned during deployment
- [x] Q: Should the plan include integration testing? → A: No — integration testing not explicitly requested; skipped
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes — include security/CVE remediation (default)
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default)
