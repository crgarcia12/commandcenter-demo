# Modernization Plan: Modernize Zava Statement Service and Deploy to Azure

**Project**: ZavaStatementService

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: WCF (Windows Communication Foundation) — SOAP service via `.svc` file
- **Build Tool**: MSBuild (legacy non-SDK-style `.csproj`)
- **Database**: SQL Server (accessed via `System.Data.SqlClient` with username/password credentials)
- **Key Dependencies**: System.ServiceModel (WCF), System.Data.SqlClient
- **Container**: Docker using Mono 6.12 runtime (cross-platform .NET Framework runner — deprecated)

---

## Overview

This migration modernizes the ZavaStatementService from a legacy .NET Framework 4.8 WCF application running on Mono to a cloud-native .NET 10 application deployable to Azure Container Apps. The application currently uses WCF SOAP endpoints, connects to SQL Server using hardcoded username/password credentials, and runs inside a deprecated Mono-based Docker container. The new architecture will:

- Upgrade the application runtime from .NET Framework 4.8 (Mono-based container) to .NET 10, enabling native Linux containerization and support for modern Azure SDKs.
- Replace SQL Server username/password authentication with Azure Managed Identity, eliminating credential exposure in configuration files.
- Configure structured console logging suitable for cloud-native log aggregation in Azure Container Apps.
- Remediate known CVE vulnerabilities in project dependencies.
- Deploy the containerized application to Azure Container Apps with a production-ready setup.

The migration follows a phased approach: upgrade the runtime first, then modernize Azure service integrations, harden security, and finally deploy to Azure.

---

## Migration Impact Summary

| Application           | Original Service              | New Azure Service       | Authentication   | Comments                                      |
|-----------------------|-------------------------------|-------------------------|------------------|-----------------------------------------------|
| ZavaStatementService  | SQL Server (local/on-prem)    | Azure SQL Database      | Managed Identity | Replace username/password with Managed Identity |
| ZavaStatementService  | Console/no logging            | Azure Monitor (via ACA) | N/A              | Configure console logging for cloud log aggregation |

---

## Tasks

### Task 1 — Upgrade .NET to Latest LTS (net10.0)

Upgrade the application from .NET Framework 4.8 to .NET 10. This includes converting the legacy non-SDK-style project to SDK-style format, migrating the WCF service to a modern equivalent (CoreWCF or REST API), and replacing the deprecated Mono-based Dockerfile with a proper .NET 10 Linux container image. This is a prerequisite for all subsequent migration tasks and for deployment to Azure Container Apps with Linux containers.

### Task 2 — Migrate SQL Server Connection to Azure SQL with Managed Identity

Replace the current SQL Server connection using hardcoded username/password credentials (`System.Data.SqlClient`) with Azure SQL Database using Managed Identity authentication. Remove credential-based connection strings from `web.config` and environment variable injection.

### Task 3 — Configure Console Logging for Cloud Environment

Update the application's logging configuration to emit structured logs to stdout/stderr so that Azure Container Apps log aggregation and Azure Monitor can capture application logs properly.

### Task 4 — Security and CVE Remediation

Scan all project dependencies for known CVEs and remediate identified vulnerabilities before deployment.

### Task 5 — Deploy to Azure Container Apps

Containerize the upgraded application with a production-ready Dockerfile and deploy to Azure Container Apps. This includes generating required infrastructure (bicep), building and pushing the container image, and configuring the Container App with the appropriate environment variables and Managed Identity bindings.

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: Yes — provision new infrastructure as part of deployment to Azure Container Apps (default).
- [x] Q: Should the plan include integration testing? → A: No — skip integration testing; user did not request it.
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes — include security/CVE remediation (default).
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default).
- [x] Q: Should the plan include containerization? → A: Covered by the deployment task (Azure Container Apps includes containerization).
