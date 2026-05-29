# Modernization Plan: ZavaComplianceReporter – Modernize and Deploy to Azure

**Project**: ZavaComplianceReporter

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Java Servlet (javax.servlet 3.1), JSP/JSTL – no Spring
- **Build Tool**: Gradle 7.6 (WAR packaging)
- **Database**: Microsoft SQL Server (mssql-jdbc 12.8.1) – password-based JDBC authentication
- **Key Dependencies**: javax.servlet-api 3.1.0, jstl 1.2, mssql-jdbc 12.8.1.jre8

---

## Overview

> This migration modernizes the ZavaComplianceReporter Java Servlet web application and deploys it to Azure. The application currently uses password-based SQL Server authentication with plaintext credentials stored in a properties file, and runs as a WAR on Tomcat. The new architecture will:
>
> - Replace hardcoded plaintext credentials (database password, connection strings) with secure secrets stored in Azure Key Vault
> - Migrate the SQL Server database connection from password-based authentication to Azure Managed Identity for Azure SQL Database
> - Scan and remediate known CVE vulnerabilities in project dependencies before deployment
> - Deploy the containerized application to Azure Container Apps, leveraging the existing Dockerfile
>
> The migration follows a phased approach: secure credentials first, then migrate the database connection to managed identity, then remediate security vulnerabilities, and finally deploy to Azure.

---

## Migration Impact Summary

| Application             | Original Service          | New Azure Service             | Authentication     | Comments                         |
|-------------------------|---------------------------|-------------------------------|--------------------|----------------------------------|
| ZavaComplianceReporter  | SQL Server (password JDBC)| Azure SQL Database            | Managed Identity   | Remove plaintext DB credentials  |
| ZavaComplianceReporter  | compliance.properties     | Azure Key Vault               | Managed Identity   | Secure all plaintext secrets     |
| ZavaComplianceReporter  | Tomcat WAR (on-premises)  | Azure Container Apps          | Managed Identity   | Existing Dockerfile reused       |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — focus on code migration and deployment; infrastructure will be created as part of the deployment task
- [x] Q: Should the plan include integration testing? → A: No — skip integration testing; not explicitly requested
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes — include security/CVE remediation (default)
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default); existing Dockerfile will be reused
