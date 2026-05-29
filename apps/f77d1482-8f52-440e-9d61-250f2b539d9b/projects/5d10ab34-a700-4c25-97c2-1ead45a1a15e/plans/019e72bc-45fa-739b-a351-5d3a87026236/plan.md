# Modernization Plan: Zava Currency Service Azure Modernization

**Project**: ZavaCurrencyService

---

## Technical Framework

- **Language**: C# (.NET Framework 4.8)
- **Framework**: ASP.NET/WCF service
- **Build Tool**: MSBuild (.csproj)
- **Database**: SQL Server
- **Key Dependencies**: System.ServiceModel, System.Data.SqlClient, System.Web

---

## Overview

This migration modernizes ZavaCurrencyService to the latest .NET framework and deploys it to Azure using cloud-native services. The application currently runs as a legacy .NET Framework WCF service with local configuration and direct database connectivity. The new architecture will:

- Move the application to the latest supported .NET LTS runtime for long-term support and modernization readiness.
- Adopt Azure cloud-native services for data, configuration, identity, and observability.
- Deploy the modernized service to Azure with a repeatable deployment workflow.

The migration follows a phased approach: runtime modernization, Azure service transformation, security remediation, and deployment.

---

## Migration Impact Summary

| Application         | Original Service            | New Azure Service                    | Authentication   | Comments |
|---------------------|-----------------------------|--------------------------------------|------------------|----------|
| ZavaCurrencyService | .NET Framework/WCF on-host  | Azure Container Apps                 | Managed Identity | Modernize runtime and deploy to Azure |
| ZavaCurrencyService | SQL Server connectivity     | Azure SQL Database                   | Managed Identity | Move DB access to cloud-native Azure service |
| ZavaCurrencyService | Local app/web configuration | Azure App Configuration + Key Vault  | Managed Identity | Externalize config and secrets |

---

## Modernization Tasks (High-level)

1. Upgrade the application to the latest .NET LTS framework.
2. Transform application dependencies and configuration to Azure cloud-native services.
3. Scan and remediate dependency CVEs before deployment.
4. Deploy the modernized application to Azure Container Apps.
