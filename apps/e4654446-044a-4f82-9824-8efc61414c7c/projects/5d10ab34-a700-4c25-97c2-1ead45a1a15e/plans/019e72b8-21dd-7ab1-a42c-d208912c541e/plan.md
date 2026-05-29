# Modernization Plan: ZavaDocVault — Modernize and Deploy to Azure

**Project**: ZavaDocVault

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Java EE Servlet API 3.1 (javax.servlet), deployed on Tomcat 9
- **Build Tool**: Gradle 7.6
- **Database**: Microsoft SQL Server (password-based authentication via JDBC)
- **Key Dependencies**: mssql-jdbc 12.6.3, org.json 20140107 (outdated), javax.servlet-api 3.1.0
- **Containerization**: Dockerfile present (gradle:7.6-jdk8 build, tomcat:9-jdk8 runtime)

---

## Overview

This migration modernizes the ZavaDocVault document management application for secure, cloud-native operation on Azure. The application currently uses password-based SQL Server authentication with hardcoded credentials in the Dockerfile and configuration files.

The new architecture will:

- Replace hardcoded database credentials with Azure Key Vault for centralized, secure secrets management
- Replace password-based SQL Server authentication with Azure Managed Identity, eliminating the need for stored database passwords
- Scan and remediate known CVE vulnerabilities in project dependencies (notably the outdated `org.json:20140107` library)
- Containerize and deploy the application to Azure Container Apps for scalable, managed hosting with native managed identity support

The migration proceeds in phases: secrets modernization, authentication modernization, security hardening, then deployment.

---

## Migration Impact Summary

| Application   | Original Service          | New Azure Service             | Authentication     | Comments                         |
|---------------|---------------------------|-------------------------------|--------------------|----------------------------------|
| ZavaDocVault  | SQL Server (password auth) | Azure SQL Database            | Managed Identity   | Remove DB_USER/DB_PASSWORD creds |
| ZavaDocVault  | Hardcoded credentials      | Azure Key Vault               | Managed Identity   | Dockerfile + doc-vault.properties|
| ZavaDocVault  | Tomcat WAR on-premises     | Azure Container Apps          | Managed Identity   | Existing Dockerfile updated      |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — no pre-existing IaC found; deployment task will provision new Azure Container Apps resources using Bicep
- [x] Q: Should the plan include integration testing? → A: No — user did not explicitly request integration testing; skipped
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes — included by default; the project contains `org.json:20140107` (2014), which is known to have critical CVEs
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default) — user requested deployment to Azure; ACA is the default target
- [x] Q: Should the plan include a separate containerization task? → A: No — the deployment task to Azure Container Apps covers containerization; the existing Dockerfile will be updated as part of deployment
