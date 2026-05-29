# Modernization Plan: Zava Loan Portal to Azure

**Project**: mnm-ZavaLoanPortal

---

## Technical Framework

- **Language**: C# on .NET Framework 4.8
- **Framework**: ASP.NET Web Forms
- **Build Tool**: MSBuild (`dotnet build` for project evaluation)
- **Database**: SQL Server (`ZavaBankDb`)
- **Key Dependencies**: System.Web, System.Data.SqlClient, System.Configuration

---

## Overview

> This migration modernizes the Zava Loan Portal and deploys it to Azure.
> The application currently runs on .NET Framework 4.8 with legacy Web Forms
> patterns and environment-coupled configuration. The new architecture will:
>
> - Upgrade the application runtime to the latest .NET LTS framework
> - Move core application integrations to Azure cloud-native services
> - Deploy the modernized application to Azure Container Apps
>
> The migration follows a phased approach: runtime upgrade, cloud-native
> transformation, security hardening, and Azure deployment.

---

## Migration Impact Summary

| Application | Original Service | New Azure Service | Authentication | Comments |
|-------------|------------------|-------------------|----------------|----------|
| ZavaLoanPortal | .NET Framework 4.8 runtime | .NET 10 LTS runtime | N/A | Modernize app to latest framework |
| ZavaLoanPortal | SQL auth and local config | Azure SQL + App Configuration | Managed Identity | Move to cloud-native service usage |
| ZavaLoanPortal | Local/container-hosted runtime | Azure Container Apps | Managed Identity | Deploy modernized app to Azure |

---

## Planned Modernization Scope

1. Upgrade application runtime to the latest supported .NET LTS framework.
2. Modernize app configuration, identity, and data access to Azure-native
   managed services.
3. Remediate dependency CVEs before deployment.
4. Deploy the modernized application to Azure Container Apps.
