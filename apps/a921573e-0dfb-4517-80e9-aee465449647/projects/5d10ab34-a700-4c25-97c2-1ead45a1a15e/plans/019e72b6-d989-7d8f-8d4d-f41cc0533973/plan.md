# Modernization Plan: ZavaPayGateway — Modernize and Deploy to Azure

**Project**: ZavaPayGateway

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Apache Struts 1.3 (legacy MVC, WAR packaging)
- **Build Tool**: Gradle 7.6
- **Database**: Microsoft SQL Server (mssql-jdbc 12.8.1), password-based authentication
- **Key Dependencies**: javax.servlet-api 3.1.0, struts-core 1.3.10, struts-taglib 1.3.10, mssql-jdbc 12.8.1
- **Container**: Tomcat 9 on JDK 8; Dockerfile already present

---

## Overview

> This migration modernizes the ZavaPayGateway Java web application and deploys it to Azure Container Apps. The application currently uses Apache Struts 1.3 running on Tomcat 9, connects to a SQL Server database with hardcoded password credentials, and stores sensitive configuration (database username/password) in a plain-text properties file. The new architecture will:
>
> - Eliminate hardcoded credentials by migrating plaintext secrets to Azure Key Vault for centralized, secure secret management
> - Replace password-based SQL Server authentication with Azure Managed Identity for passwordless, credential-free database access
> - Remediate known CVEs in project dependencies to ensure a secure baseline before deployment
> - Deploy the containerized application to Azure Container Apps using the existing Dockerfile and Azure CLI tooling

---

## Migration Impact Summary

| Application       | Original Service              | New Azure Service                  | Authentication   | Comments                              |
|-------------------|-------------------------------|------------------------------------|------------------|---------------------------------------|
| ZavaPayGateway    | Hardcoded credentials (props) | Azure Key Vault                    | Managed Identity | Removes db.password from properties   |
| ZavaPayGateway    | SQL Server (password auth)    | Azure SQL Database                 | Managed Identity | Passwordless via Azure MI             |
| ZavaPayGateway    | Local Tomcat WAR              | Azure Container Apps               | Managed Identity | Existing Dockerfile reused            |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — no infrastructure provisioning; focus on code migration and deployment only (no IaC found in repository)
- [x] Q: Should the plan include integration testing? → A: No — integration testing not explicitly requested; skipped
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes — include security/CVE remediation (default)
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default); existing Dockerfile will be reused
