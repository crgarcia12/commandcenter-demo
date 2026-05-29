# Modernization Plan: Zava Alert Service – Modernize and Deploy to Azure

**Project**: ZavaAlertService

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: ASP.NET WCF (Windows Communication Foundation) — ASMX/SVC hosted service
- **Build Tool**: MSBuild (legacy non-SDK-style .csproj)
- **Database**: SQL Server (via raw `System.Data.SqlClient` with username/password connection string)
- **Messaging**: RabbitMQ (via HTTP Management API with username/password)
- **Container Runtime**: Mono 6.12 / XSP4 (Linux container)
- **Key Dependencies**: `System.ServiceModel` (WCF), `System.Data.SqlClient`, `System.Web`

---

## Overview

> This migration modernizes the ZavaAlertService from a legacy .NET Framework 4.8 WCF service running on Mono to a cloud-native .NET 10 application deployed on Azure Container Apps. The application currently uses SQL Server with username/password credentials and RabbitMQ for alert event publishing. The new architecture will:
>
> - Replace the legacy WCF/Mono runtime with .NET 10 and a modern ASP.NET Core Web API, enabling first-class Azure SDK support and containerized Linux deployment.
> - Migrate the SQL Server data access layer to Azure SQL Database using Managed Identity authentication, eliminating hard-coded credentials.
> - Replace the RabbitMQ publisher with Azure Service Bus, providing cloud-native reliable messaging with Managed Identity authentication.
> - Configure cloud-optimized console logging to ensure proper log aggregation in Azure Container Apps.
> - Scan and remediate all known CVEs in project dependencies before deployment.
> - Deploy the containerized service to Azure Container Apps.
>
> The migration follows a phased approach: upgrade the runtime and project format first, then migrate each Azure service dependency, followed by security hardening and deployment.

---

## Migration Impact Summary

| Application        | Original Service   | New Azure Service         | Authentication    | Comments                         |
|--------------------|--------------------|---------------------------|-------------------|----------------------------------|
| ZavaAlertService   | SQL Server (local) | Azure SQL Database        | Managed Identity  | Remove username/password creds   |
| ZavaAlertService   | RabbitMQ           | Azure Service Bus         | Managed Identity  | Replace HTTP Management API      |
| ZavaAlertService   | Console (Mono/XSP4)| Azure Container Apps logs | N/A               | Configure cloud console logging  |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include infrastructure provisioning? → A: No — focus on code migration and deployment only; no new IaC provisioning task.
- [x] Q: Should the plan include integration testing? → A: No explicit request — skipping integration test task.
- [x] Q: Should the plan include security/CVE remediation? → A: Yes (default) — include CVE scan and remediation task.
- [x] Q: Which Azure deployment target? → A: Azure Container Apps (default).
