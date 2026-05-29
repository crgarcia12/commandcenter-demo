# Modernization Plan: ZavaDocVault Azure Modernization

**Project**: ZavaDocVault

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Java Servlet API 4.0 (Tomcat WAR application)
- **Build Tool**: Gradle (war plugin)
- **Database**: Microsoft SQL Server (JDBC)
- **Key Dependencies**: mssql-jdbc, javax.servlet-api

---

## Overview

> This migration modernizes the ZavaDocVault application for Azure.
> The application currently runs on a legacy Java 8 servlet stack with
> password-based configuration and SQL Server-backed document storage.
> The new architecture will:
>
> - Upgrade to a current Java framework/runtime baseline for long-term support
> - Adopt Azure-native managed services for secrets and data access security
> - Deploy the application to Azure using a cloud-native deployment target
>
> The migration follows a phased approach of upgrade, service transformation,
> security remediation, and deployment.

---

## Migration Impact Summary

| Application | Original Service | New Azure Service | Authentication | Comments |
|-------------|------------------|-------------------|----------------|----------|
| ZavaDocVault | Local config secrets | Azure Key Vault | Managed Identity | Remove plaintext secrets |
| ZavaDocVault | SQL Server auth | Azure SQL + MI | Managed Identity | Passwordless DB access |
| ZavaDocVault | Legacy hosting | Azure Container Apps | Managed Identity | Cloud-native deployment |

---

## Planned Task Scope

The generated task plan includes:
- Framework/runtime upgrade to the latest supported Java application baseline
- Migration of plaintext credentials to Azure Key Vault
- Migration to managed identity-based Azure SQL connectivity
- Security compliance and CVE remediation
- Deployment to Azure Container Apps

---

## Open Questions & Questionnaire

- [ ] Which Azure region should be used for deployment resources?
- [ ] Should deployment target existing Azure resources or create new ones?
