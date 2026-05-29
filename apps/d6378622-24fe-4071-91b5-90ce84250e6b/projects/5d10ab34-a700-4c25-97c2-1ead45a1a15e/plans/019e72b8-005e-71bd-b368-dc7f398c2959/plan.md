# Modernization Plan: ZavaLedger Azure Modernization

**Project**: ZavaLedger

---

## Technical Framework

- **Language**: Java 17
- **Framework**: Java EE Servlets (javax.servlet 4.0.1) — Tomcat 9.0 WAR deployment
- **Build Tool**: Gradle 7.6
- **Database**: Azure SQL / SQL Server (mssql-jdbc 12.8.1)
- **Key Dependencies**: javax.servlet-api, mssql-jdbc

---

## Overview

> This migration modernizes the ZavaLedger banking ledger application to run securely on Azure. The application currently uses hardcoded plaintext database credentials stored in `ledger.properties` and connects to SQL Server using password-based authentication. The new architecture will:
>
> - Eliminate plaintext credentials by migrating database secrets to Azure Key Vault for centralized, secure secret management
> - Scan and remediate known CVE vulnerabilities in project dependencies to ensure a secure deployment
> - Deploy the containerized application to Azure Container Apps using the existing Dockerfile, enabling cloud-native scaling and management
>
> The migration follows a phased approach: first securing credentials, then hardening dependencies, and finally deploying to Azure.

---

## Migration Impact Summary

```
| Application  | Original Service          | New Azure Service        | Authentication     | Comments                          |
|--------------|---------------------------|--------------------------|--------------------|-----------------------------------|
| ZavaLedger   | Plaintext credentials in  | Azure Key Vault          | Managed Identity   | Move DB password from             |
|              | ledger.properties         |                          |                    | ledger.properties to Key Vault    |
| ZavaLedger   | SQL Server password auth  | Azure SQL Database       | Key Vault secret   | Remove hardcoded sa/password      |
| ZavaLedger   | Local Tomcat WAR          | Azure Container Apps     | Managed Identity   | Deploy via existing Dockerfile    |
```

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — no existing IaC found; focus on code migration and deployment using new resources provisioned by the deployment skill
- [x] Q: Should the plan include integration testing? → A: No — not explicitly requested; skipped
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes — default included
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps — default; application already has a Dockerfile
