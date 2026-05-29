# Modernization Plan: ZavaCurrencyService Azure Modernization

**Project**: ZavaCurrencyService

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: WCF (Windows Communication Foundation), ASP.NET 4.8
- **Build Tool**: MSBuild (legacy non-SDK project format)
- **Database**: SQL Server (username/password authentication via `System.Data.SqlClient`)
- **Key Dependencies**: System.ServiceModel (WCF SOAP), System.Data.SqlClient, System.Web

---

## Overview

This migration modernizes ZavaCurrencyService from a .NET Framework 4.8 WCF SOAP service to a containerized .NET 10 ASP.NET Core REST API deployed on Azure Container Apps. The application currently exposes three operations (`GetRate`, `GetSupportedCurrencies`, `ConvertAmount`) over a WCF SOAP endpoint and connects to SQL Server using username/password credentials stored in environment variables and `web.config`. The new architecture will:

- Upgrade the project to .NET 10 LTS and convert to the modern SDK-style project format, enabling Linux container support for Azure Container Apps
- Replace the WCF SOAP service with a modern ASP.NET Core REST API, preserving all existing business logic and operations
- Migrate SQL Server connections from username/password authentication to Azure SQL Database with Managed Identity for passwordless, secure access
- Configure structured console logging suitable for cloud-native container log aggregation and Azure Monitor observability
- Remediate known CVE vulnerabilities in dependencies before deployment
- Containerize and deploy to Azure Container Apps using a modern .NET 10 Dockerfile and Bicep infrastructure

The migration follows a phased approach: runtime upgrade first, then service and data layer modernization, followed by security hardening and cloud deployment.

---

## Migration Impact Summary

| Application          | Original Service                    | New Azure Service          | Authentication   | Comments                                      |
|----------------------|-------------------------------------|----------------------------|------------------|-----------------------------------------------|
| ZavaCurrencyService  | SQL Server (on-prem, credentials)   | Azure SQL Database         | Managed Identity | Remove username/password; use Managed Identity|
| ZavaCurrencyService  | WCF SOAP / .NET Framework 4.8       | ASP.NET Core REST / .NET 10| N/A              | Convert WCF endpoints to REST API             |
| ZavaCurrencyService  | Mono-based Docker container         | Azure Container Apps       | Managed Identity | Replace Mono Dockerfile with .NET 10 image    |

---

## Tasks

### Task 1 — Upgrade .NET to .NET 10 LTS

Upgrade ZavaCurrencyService from .NET Framework 4.8 to .NET 10. Convert the legacy non-SDK `.csproj` to modern SDK-style format. This is required for Linux container support, Azure Container Apps deployment, and compatibility with the modern Azure SDK.

### Task 2 — Migrate WCF SOAP Service to ASP.NET Core REST API

Convert the `ICurrencyService` WCF service contract and implementation to an ASP.NET Core REST API. Preserve the three existing operations as REST endpoints: `GetRate`, `GetSupportedCurrencies`, and `ConvertAmount`. Convert the `HealthHandler` to an ASP.NET Core health endpoint.

### Task 3 — Migrate SQL Server to Azure SQL Database with Managed Identity

Migrate the SQL Server connection in `DbConfig.cs` and `CurrencyService.cs` from username/password authentication to Azure SQL Database using Managed Identity (`DefaultAzureCredential`). Replace `System.Data.SqlClient` with `Microsoft.Data.SqlClient`.

### Task 4 — Configure Console Logging for Cloud Environments

Add and configure structured console logging for cloud-native container environments. Ensure log output is suitable for Azure Monitor and container log aggregation.

### Task 5 — Security and CVE Remediation

Scan all project dependencies for known CVEs and remediate identified vulnerabilities to ensure the application is secure before deployment.

### Task 6 — Deploy to Azure Container Apps

Containerize the modernized ASP.NET Core REST API using a .NET 10 Docker image and deploy to Azure Container Apps. Update the existing Mono-based Dockerfile. Configure Managed Identity for the container app to authenticate with Azure SQL Database.

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — focus on code migration and deployment only; no separate infrastructure provisioning task
- [x] Q: Should the plan include integration testing? → A: No — skipped (not explicitly requested)
- [x] Q: Should the plan include security scan and CVE remediation? → A: Yes — include security/CVE remediation (default)
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default)
