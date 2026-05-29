# Modernization Plan: Zava Loan Origination API – Azure Modernization

**Project**: ZavaLoanOriginationAPI

---

## Technical Framework

- **Language**: Java 11
- **Framework**: Java EE / Jakarta Servlet (javax.servlet 4.0), Tomcat 9 WAR deployment
- **Build Tool**: Gradle 7.6
- **Database**: Microsoft SQL Server with password-based JDBC authentication
- **Key Dependencies**: `javax.servlet-api:4.0.1`, `mssql-jdbc:12.6.3.jre11`, `org.json:20140107`

---

## Overview

This migration modernizes the ZavaLoanOriginationAPI — a Java EE loan origination service —
for secure deployment to Azure. The application currently runs as a WAR on Tomcat 9, connects
to SQL Server using password-based authentication, and has hardcoded database credentials
(`DB_USER=sa`, `DB_PASSWORD=YourStrong!Passw0rd`) in its Dockerfile. The new architecture will:

- Replace password-based SQL Server credentials with Azure Managed Identity for
  passwordless, secure connectivity to Azure SQL Database
- Remediate known CVEs in project dependencies, particularly the `org.json:20140107`
  library (2014 release with unpatched vulnerabilities)
- Deploy the containerized application to Azure Container Apps using the existing
  Dockerfile, with Managed Identity configured for Azure SQL access

The migration proceeds in phases: first secure the data layer with Managed Identity, then
remediate vulnerabilities, and finally deploy to Azure Container Apps.

---

## Migration Impact Summary

| Application            | Original Service              | New Azure Service         | Authentication     | Comments                              |
|------------------------|-------------------------------|---------------------------|--------------------|---------------------------------------|
| ZavaLoanOriginationAPI | SQL Server (password-based)   | Azure SQL Database        | Managed Identity   | Remove DB_USER/DB_PASSWORD from env   |
| ZavaLoanOriginationAPI | Tomcat WAR (on-premises)      | Azure Container Apps      | N/A                | Uses existing Dockerfile              |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include infrastructure provisioning? → A: No — focus on code migration and deployment only; no separate infrastructure provisioning task.
- [x] Q: Should the plan include integration testing? → A: No — integration testing not explicitly requested; skipped.
- [x] Q: Should the plan include security/CVE remediation? → A: Yes — include CVE scan and remediation (default).
- [x] Q: Which Azure deployment target should be used? → A: Azure Container Apps (default).
