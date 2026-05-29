# Modernization Plan: Zava Audit Worker – Azure Modernization

**Project**: ZavaAuditWorker

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: Console Worker (no web framework)
- **Build Tool**: MSBuild / NuGet (packages.config, legacy csproj)
- **Database**: SQL Server (username/password authentication)
- **Message Broker**: RabbitMQ 5.2.0 (polling-based queue consumer)
- **Key Dependencies**: RabbitMQ.Client 5.2.0, System.Data.SqlClient, System.Web.Extensions

---

## Overview

> This migration modernizes the ZavaAuditWorker from a .NET Framework 4.8 console application to a cloud-native .NET 10 worker service ready for Azure deployment. The application currently polls a RabbitMQ queue for audit events and persists them to an on-premises SQL Server using username/password credentials and a legacy project format. The new architecture will:
>
> - Replace RabbitMQ with Azure Service Bus using Managed Identity for secure, scalable message processing
> - Replace SQL Server with Azure SQL Database using Managed Identity, eliminating hardcoded credentials
> - Adopt cloud-native console logging patterns for proper log aggregation in container environments
> - Upgrade the project from .NET Framework 4.8 to .NET 10, converting the legacy csproj to SDK-style format
> - Deploy the modernized application as a containerized workload on Azure Container Apps
>
> The migration follows an incremental approach: upgrade the runtime first, then migrate each Azure service dependency, harden security, and deploy.

---

## Migration Impact Summary

| Application       | Original Service     | New Azure Service          | Authentication   | Comments                        |
|-------------------|----------------------|----------------------------|------------------|---------------------------------|
| ZavaAuditWorker   | RabbitMQ             | Azure Service Bus          | Managed Identity | Queue consumer / dead-letter    |
| ZavaAuditWorker   | SQL Server (on-prem) | Azure SQL Database         | Managed Identity | Audit event persistence         |
| ZavaAuditWorker   | Console.WriteLine    | Console Logging (cloud)    | N/A              | Cloud-native log aggregation    |
| ZavaAuditWorker   | .NET Framework 4.8   | .NET 10 (net10.0)          | N/A              | SDK-style csproj conversion     |
| ZavaAuditWorker   | Mono/Docker (legacy) | Azure Container Apps       | Managed Identity | Containerized deployment        |

---

## Modernization Tasks

### Task 1 – Upgrade .NET to .NET 10

Upgrade the project from .NET Framework 4.8 to .NET 10 (`net10.0`), converting from the legacy MSBuild csproj format to SDK-style, and migrating from `packages.config` to `PackageReference`.

### Task 2 – Migrate RabbitMQ to Azure Service Bus

Replace the RabbitMQ client with Azure Service Bus, preserving queue consumption semantics (polling/receive, dead-letter handling) and using Managed Identity for authentication.

### Task 3 – Migrate SQL Server to Azure SQL Database

Replace the SQL Server connection (username/password via connection string) with Azure SQL Database using Managed Identity authentication, preserving all audit event persistence logic.

### Task 4 – Modernize Console Logging

Update the application's `Console.WriteLine` logging to use structured, cloud-native console logging patterns suitable for container and Azure log aggregation.

### Task 5 – Security / CVE Remediation

Scan all project dependencies for known CVEs and remediate any identified vulnerabilities before deployment.

### Task 6 – Deploy to Azure Container Apps

Containerize and deploy the modernized worker application to Azure Container Apps using the Azure CLI deployment flow.

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — focus on code migration only; no new infrastructure provisioning (no existing IaC found in repository)
- [x] Q: Should the plan include integration testing? → A: No — integration testing not explicitly requested; skipped
- [x] Q: Should the plan include security/CVE remediation? → A: Yes — include security/CVE scan (default)
- [x] Q: Which Azure deployment target? → A: Azure Container Apps (default)
