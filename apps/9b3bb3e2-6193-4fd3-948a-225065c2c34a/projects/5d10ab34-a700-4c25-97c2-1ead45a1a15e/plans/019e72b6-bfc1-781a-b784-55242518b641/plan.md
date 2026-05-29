# Modernization Plan: ZavaKYCService — Modernize and Deploy to Azure

**Project**: ZavaKYCService

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Java EE Servlets (plain javax.servlet, no Spring Boot)
- **Build Tool**: Gradle 7.6
- **Database**: Microsoft SQL Server (via JDBC, mssql-jdbc 12.6.3)
- **Deployment**: WAR deployed on Tomcat 9, Dockerfile already present
- **Key Dependencies**: javax.servlet-api 4.0.1, mssql-jdbc 12.6.3.jre8, org.json 20140107

---

## Overview

> This migration modernizes ZavaKYCService for secure cloud deployment on Azure. The application currently runs as a Java EE Servlet WAR on Tomcat 9, using direct JDBC connections to SQL Server with hardcoded credentials stored in source code, and has no structured logging. The new architecture will:
>
> - **Remove hardcoded credentials**: Database passwords are moved from source code to Azure Key Vault, eliminating secrets exposure in the repository.
> - **Enable cloud-native logging**: Logging is migrated to console output, conforming to Azure container logging standards.
> - **Remediate security vulnerabilities**: All CVEs in project dependencies (notably the outdated `org.json:json:20140107`) are identified and patched.
> - **Deploy to Azure Container Apps**: The containerized application is deployed to Azure Container Apps using the existing Dockerfile and Azure CLI tooling.
>
> The migration follows a sequential approach: secure credentials first, add logging, remediate CVEs, then deploy to Azure.

---

## Migration Impact Summary

| Application       | Original Service             | New Azure Service            | Authentication      | Comments                                      |
|-------------------|------------------------------|------------------------------|---------------------|-----------------------------------------------|
| ZavaKYCService    | Hardcoded SQL Server creds   | Azure Key Vault              | Managed Identity    | Remove plaintext password from kyc.properties |
| ZavaKYCService    | File-based / no logging      | Console logging              | N/A                 | Cloud-native console output for Azure         |
| ZavaKYCService    | Tomcat WAR (local/container) | Azure Container Apps         | Managed Identity    | Deploy via azcli using existing Dockerfile    |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — focus on code migration and deployment using new Azure Container Apps resources provisioned by the deployment skill.
- [x] Q: Should the plan include integration testing? → A: No — integration testing was not explicitly requested; skipped.
- [x] Q: Should the plan include security/CVE remediation? → A: Yes — default behavior; `org.json:json:20140107` and other outdated dependencies require scanning.
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default); Dockerfile already exists in the repository.
- [x] Q: Should the plan include containerization? → A: Covered by the deployment task — existing Dockerfile will be used.
