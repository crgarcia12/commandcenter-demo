# Modernization Plan: Modernize Zava App for Azure

**Project**: ZavaReportDashboard

---

## Technical Framework

- **Language**: C# (.NET Framework 4.8)
- **Framework**: ASP.NET Web Forms
- **Build Tool**: MSBuild (non-SDK .csproj)
- **Database**: SQL Server (via System.Data.SqlClient)
- **Key Dependencies**: System.Web, System.Data, System.Configuration

---

## Overview

> This migration modernizes the Zava application and deploys it to Azure.
> The application currently runs as a legacy ASP.NET Web Forms app on .NET
> Framework 4.8. The new architecture will:
>
> - Upgrade to the latest .NET framework baseline for long-term support.
> - Align application runtime behavior to Azure cloud-native service patterns.
> - Deploy the modernized application to Azure Container Apps.
>
> The migration follows a phased approach: runtime upgrade, cloud-native
> service alignment, security remediation, and Azure deployment.

---

## Migration Impact Summary

| Application | Original Service | New Azure Service | Authentication | Comments |
|-------------|------------------|-------------------|----------------|----------|
| ZavaReportDashboard | Legacy hosted app | Azure Container Apps | Managed Identity | Modernize app and deploy to Azure |

---

## Open Questions & Questionnaire

- [x] Q: Include environment/infrastructure provisioning? → A: No, use existing Azure resources (inferred default)
- [x] Q: Include integration testing? → A: No explicit request; not added to plan
- [x] Q: Include security/CVE remediation? → A: Yes (default included)
- [x] Q: Which Azure deployment target? → A: Azure Container Apps (default)
- [x] Q: Include standalone containerization task? → A: No, covered by deployment task
