# Modernization Plan: Zava Fraud Detector – Azure Modernization

**Project**: ZavaFraudDetector

---

## Technical Framework

- **Language**: Java 11
- **Framework**: Apache Struts 2.5.30
- **Build Tool**: Gradle 7.6
- **Database**: Microsoft SQL Server (password-based JDBC authentication)
- **Web Container**: Tomcat 9.0 (WAR packaging)
- **Key Dependencies**: mssql-jdbc 12.8.1, Struts2 Core 2.5.30, javax.servlet-api 4.0.1

---

## Overview

> This migration modernizes the ZavaFraudDetector application for cloud deployment on Azure. The application currently uses password-based SQL Server JDBC authentication with credentials stored in a properties file or environment variables, and is packaged as a WAR running on Tomcat 9.0. The new architecture will:
>
> - Eliminate plaintext database credentials by moving secrets to Azure Key Vault, improving security posture and enabling centralized secret management
> - Ensure all application logging goes to console output, aligning with cloud-native observability practices for Azure Container Apps
> - Remediate known CVEs in project dependencies (including Struts 2.5.30) to ensure the application is free of known security vulnerabilities before deployment
> - Deploy the containerized application to Azure Container Apps, leveraging the existing Dockerfile for consistent, scalable hosting
>
> The migration follows a sequential approach: secure credentials first, then harden dependencies, and finally deploy to Azure.

---

## Migration Impact Summary

| Application          | Original Service              | New Azure Service          | Authentication    | Comments                                 |
|----------------------|-------------------------------|----------------------------|-------------------|------------------------------------------|
| ZavaFraudDetector    | SQL Server (password JDBC)    | Azure SQL Database         | Managed Identity  | Credentials migrated to Azure Key Vault  |
| ZavaFraudDetector    | Local/file logging            | Console (stdout)           | N/A               | Cloud-native logging for Azure Container Apps |
| ZavaFraudDetector    | WAR on Tomcat (local/on-prem) | Azure Container Apps       | Managed Identity  | Existing Dockerfile used for deployment  |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — focus on code migration and deployment only; no new infrastructure provisioning
- [x] Q: Should the plan include integration testing? → A: No — integration testing not requested
- [x] Q: Should the plan include security/CVE remediation? → A: Yes — include security/CVE remediation (default)
- [x] Q: Which Azure deployment target should be used? → A: Azure Container Apps (default)
