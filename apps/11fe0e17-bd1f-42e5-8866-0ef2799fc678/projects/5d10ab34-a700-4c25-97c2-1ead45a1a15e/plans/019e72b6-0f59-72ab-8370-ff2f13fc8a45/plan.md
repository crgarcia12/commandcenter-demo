# Modernization Plan: Zava Risk Engine – Modernize and Deploy to Azure

**Project**: ZavaRiskEngine

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: WCF (Windows Communication Foundation) SOAP service, ASP.NET Web Forms (Health endpoint)
- **Build Tool**: MSBuild (legacy non-SDK project format)
- **Database**: SQL Server (via `System.Data.SqlClient` with username/password credentials)
- **Container**: Mono 6.12 / XSP4 (legacy Linux compatibility layer)
- **Key Dependencies**: System.ServiceModel (WCF), System.Data.SqlClient

---

## Overview

This migration modernizes the ZavaRiskEngine application from a legacy .NET Framework 4.8 WCF SOAP service to a cloud-native .NET 10 application and deploys it to Azure Container Apps. The application currently runs on Mono in Docker, uses hardcoded SQL Server credentials, and is built using a legacy MSBuild project format. The new architecture will:

- Upgrade the runtime to .NET 10 (latest LTS), converting the project to SDK-style format and migrating WCF to CoreWCF for continued SOAP service compatibility
- Replace SQL Server username/password authentication with Azure SQL Database using Managed Identity (passwordless), eliminating credential exposure
- Configure structured console logging suitable for cloud-native container environments
- Scan and remediate known CVE vulnerabilities in all dependencies before deployment
- Package the application in a modern .NET container and deploy to Azure Container Apps

The migration follows a phased approach: upgrade runtime first, then migrate Azure services, then harden security, and finally deploy.

---

## Migration Impact Summary

| Application      | Original Service          | New Azure Service         | Authentication     | Comments                        |
|------------------|---------------------------|---------------------------|--------------------|---------------------------------|
| ZavaRiskEngine   | SQL Server (on-prem/local)| Azure SQL Database        | Managed Identity   | Replace username/password creds |
| ZavaRiskEngine   | Mono/XSP4 container       | Azure Container Apps      | Managed Identity   | Modern .NET 10 container        |

---

## Tasks

### Task 1 – Upgrade .NET to .NET 10

Upgrade the project from .NET Framework 4.8 to .NET 10 (latest LTS). This includes converting the legacy MSBuild project format to SDK-style, migrating the WCF SOAP service to CoreWCF, replacing the Mono-based Dockerfile with an official .NET container image, and ensuring the project compiles and all existing functionality is preserved.

### Task 2 – Migrate SQL Server to Azure SQL Database with Managed Identity

Replace the existing SQL Server connection using username/password credentials with Azure SQL Database using Managed Identity (passwordless authentication). The `DbConfig.cs` credential-based connection string logic and the hardcoded `web.config` connection string must be replaced with a Managed Identity–based approach.

### Task 3 – Configure Console Logging for Cloud

Configure the application's logging to emit structured output to the console, ensuring compatibility with Azure Container Apps log aggregation and cloud observability tooling.

### Task 4 – Security and CVE Remediation

Scan all project dependencies for known CVEs and remediate identified vulnerabilities before deployment. Upgrade vulnerable packages to the minimum patched version, document any breaking changes from major version upgrades, and verify the project builds and tests pass.

### Task 5 – Deploy to Azure Container Apps

Containerize the modernized application and deploy it to Azure Container Apps. This task includes generating the Dockerfile, provisioning the necessary Azure infrastructure using Bicep, and deploying the application image.

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: Yes — provision new infrastructure for deployment to Azure Container Apps
- [x] Q: Should the plan include integration testing? → A: No — skip integration testing (not explicitly requested)
- [x] Q: Should the plan include security/CVE remediation? → A: Yes — include default security/CVE remediation task
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default)
