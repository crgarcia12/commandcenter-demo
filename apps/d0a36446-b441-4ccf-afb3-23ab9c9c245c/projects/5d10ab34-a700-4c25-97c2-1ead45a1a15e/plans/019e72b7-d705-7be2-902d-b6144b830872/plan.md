# Modernization Plan: ZavaLoanPortal — Modernize and Deploy to Azure

**Project**: ZavaLoanPortal

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: ASP.NET Web Forms
- **Build Tool**: MSBuild / mcs (Mono compiler in container)
- **Database**: SQL Server (ADO.NET — direct `SqlConnection` / `SqlCommand`)
- **Container**: Mono 6.12 (Docker, Linux)
- **Key Dependencies**: System.Web, System.Data.SqlClient, System.Configuration

---

## Overview

This migration modernizes the ZavaLoanPortal ASP.NET Web Forms application to run securely on Azure. The application currently uses hardcoded SQL Server credentials, Forms Authentication backed by an external Auth Gateway, and plain `appSettings` in `web.config` for runtime configuration. The new architecture will:

- Replace SQL Server password-based authentication with Azure SQL Database using Managed Identity, eliminating plaintext credentials.
- Replace the custom Forms Authentication / Auth Gateway pattern with Microsoft Entra ID for enterprise-grade identity management.
- Externalize runtime configuration (`LoanOriginationApiUrl` and other settings) to Azure App Configuration, removing environment-specific values from source code.
- Ensure structured console logging so that Azure Monitor / Log Analytics can aggregate application logs.
- Scan and remediate known CVEs in project dependencies before deployment.
- Deploy the application to Azure App Service (Windows), the native target for ASP.NET Web Forms on .NET Framework 4.8.

The migration follows a phased approach: service integrations first, security hardening second, then deployment.

---

## Migration Impact Summary

| Application      | Original Service            | New Azure Service              | Authentication     | Comments                              |
|------------------|-----------------------------|--------------------------------|--------------------|---------------------------------------|
| ZavaLoanPortal   | SQL Server (password-based) | Azure SQL Database             | Managed Identity   | Remove hardcoded credentials          |
| ZavaLoanPortal   | Forms Auth / Auth Gateway   | Microsoft Entra ID             | OAuth 2.0 / OIDC   | Replace Forms + machineKey            |
| ZavaLoanPortal   | web.config appSettings      | Azure App Configuration        | Managed Identity   | Externalize LoanOriginationApiUrl     |
| ZavaLoanPortal   | None (no structured logging)| Console logging (Azure Monitor)| N/A                | Enable cloud-ready log output         |
| ZavaLoanPortal   | Azure App Service           | Azure App Service (Windows)    | Managed Identity   | .NET 4.8 Web Forms native deployment  |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — focus on code migration only; no new infrastructure provisioning in this plan.
- [x] Q: Should the plan include integration testing? → A: No — no environment is provisioned; skip integration testing.
- [x] Q: Should the plan include security/CVE remediation? → A: Yes — include security/CVE scan and remediation (default).
- [x] Q: Which Azure deployment target should be used? → A: Azure App Service (Windows) — the natural fit for ASP.NET Web Forms on .NET Framework 4.8.
- [x] Q: Should the plan include containerization? → A: No — Azure App Service (Windows) does not require a separate containerization task; the deployment skill handles packaging.
