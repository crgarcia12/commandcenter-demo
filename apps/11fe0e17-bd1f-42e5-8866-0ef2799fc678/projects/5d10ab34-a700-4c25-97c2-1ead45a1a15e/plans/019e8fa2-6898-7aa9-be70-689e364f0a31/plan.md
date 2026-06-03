# Modernization Plan: Zava Risk Engine – Azure Modernization & Deployment

**Project**: ZavaRiskEngine

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: WCF (Windows Communication Foundation) SOAP Service hosted on Mono/XSP4; ASP.NET HTTP handler for health checks
- **Build Tool**: MSBuild / Mono mcs compiler (Docker build)
- **Database**: SQL Server – accessed via raw ADO.NET (`System.Data.SqlClient`) with username/password credentials
- **Key Dependencies**: `System.ServiceModel` (WCF), `System.Data.SqlClient`, `System.Web`, `System.Configuration`

---

## Overview

This migration modernizes the ZavaRiskEngine WCF risk-scoring service and deploys it to Azure. The application currently runs as a Mono/XSP4-hosted WCF SOAP service in a Linux container connecting to a local SQL Server database using hardcoded username/password credentials.

The new architecture will:

- Replace SQL Server username/password authentication with Azure SQL Database using Managed Identity for secure, passwordless database access
- Scan and remediate all known CVEs in project dependencies to ensure the application is secure before deployment
- Package and deploy the containerized service to Azure Container Apps for scalable, managed cloud hosting

The migration follows a phased approach: code modernization first (SQL migration, security hardening), followed by deployment to Azure Container Apps.

---

## Migration Impact Summary

| Application      | Original Service          | New Azure Service        | Authentication    | Comments                                   |
|------------------|---------------------------|--------------------------|-------------------|--------------------------------------------|
| ZavaRiskEngine   | SQL Server (local/Docker) | Azure SQL Database       | Managed Identity  | Replace ADO.NET credentials with MI auth   |
| ZavaRiskEngine   | Mono/XSP4 Docker container| Azure Container Apps     | —                 | Deploy existing containerized service      |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — no infrastructure provisioning found in repo; focus on code migration and deployment using new Azure resources
- [x] Q: Should the plan include integration testing? → A: No — no environment provisioned and user did not request integration tests; skipping integration test task
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes (default) — include security/CVE remediation task
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default) — deploy the containerized WCF service to ACA
