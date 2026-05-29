# Modernization Plan: Zava Interest Calculator – Azure Modernization

**Project**: ZavaInterestCalculator

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Java EE Servlet (javax.servlet 3.1, Tomcat 9)
- **Build Tool**: Gradle
- **Database**: Microsoft SQL Server (password-based authentication)
- **Key Dependencies**: mssql-jdbc 12.6.3.jre8, org.json 20140107

---

## Overview

> This migration modernizes the ZavaInterestCalculator Java servlet application for deployment on Azure. The application currently runs as a WAR file on Tomcat with password-based SQL Server connectivity and hardcoded database credentials. The new architecture will:
>
> - Replace password-based SQL Server credentials with Azure Managed Identity for Azure SQL Database, eliminating credential management risks and removing hardcoded secrets from the Dockerfile and environment configuration
> - Remediate known CVE vulnerabilities in outdated dependencies (notably `org.json:20140107` from 2014)
> - Deploy the containerized application to Azure Container Apps for scalable, fully managed cloud hosting
>
> The migration follows a phased approach: database authentication modernization, security hardening, then cloud deployment.

---

## Migration Impact Summary

| Application            | Original Service       | New Azure Service      | Authentication   | Comments                        |
|------------------------|------------------------|------------------------|------------------|---------------------------------|
| ZavaInterestCalculator | SQL Server (password)  | Azure SQL Database     | Managed Identity | Remove hardcoded DB credentials |
| ZavaInterestCalculator | Tomcat WAR (on-prem)   | Azure Container Apps   | Managed Identity | Containerized deployment        |

---

## Modernization Tasks

### Task 1 – Migrate SQL Server to Azure SQL with Managed Identity

Migrate the database connectivity layer from password-based SQL Server authentication to Azure SQL Database using Azure Managed Identity. This removes the hardcoded `DB_USER` and `DB_PASSWORD` credentials from the Dockerfile and environment configuration.

### Task 2 – Security & CVE Remediation

Scan all project dependencies for known CVEs and remediate identified vulnerabilities. The `org.json:20140107` dependency is notably outdated (2014) and should be upgraded. All other dependencies will also be scanned and patched to their minimum safe versions.

### Task 3 – Deploy to Azure Container Apps

Build the container image from the existing Dockerfile (updated for managed identity), provision Azure Container Apps infrastructure, and deploy the application.

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — no infrastructure provisioning; focus on code migration only (no IaC found in repository)
- [x] Q: Should the plan include integration testing? → A: No — skip integration testing (not explicitly requested)
- [x] Q: Should the plan include security/CVE remediation? → A: Yes — include security/CVE remediation (default)
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default)
