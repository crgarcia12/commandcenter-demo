# Modernization Plan: Zava KYC Service Azure Modernization

**Project**: ZavaKYCService

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Java EE Servlet API 4.0.1 on Apache Tomcat 9
- **Build Tool**: Gradle
- **Database**: Microsoft SQL Server (JDBC)
- **Key Dependencies**: javax.servlet-api, mssql-jdbc, org.json

---

## Overview

> This migration modernizes ZavaKYCService to the latest Java framework baseline and deploys it to Azure. The application currently runs as a Java EE servlet WAR with SQL Server connectivity and legacy Java 8 runtime assumptions. The new architecture will:
>
> - Upgrade the application runtime and framework baseline for long-term support
> - Move core data and security integration to Azure-native managed services
> - Deploy the service on Azure with cloud-native operational practices
>
> The migration follows a phased approach: upgrade first, transform integrations second, then secure and deploy.

---

## Migration Impact Summary

| Application | Original Service | New Azure Service | Authentication | Comments |
|-------------|------------------|-------------------|----------------|----------|
| ZavaKYCService | On-prem SQL Server auth | Azure SQL Database | Managed Identity | Cloud-native data access modernization |
| ZavaKYCService | Local/plain config secrets | Azure Key Vault | Managed Identity | Centralized secret management |
| ZavaKYCService | Local Tomcat deployment | Azure Container Apps | Managed Identity | Cloud-native deployment target |

---

## Security Compliance

**Description**: Scan all project dependencies for known CVEs and remediate any identified vulnerabilities to ensure the application is secure before deployment.

**Requirements**:
- Upgrade vulnerable dependencies to minimum patched versions.
- Document breaking-change risk if any remediation requires major upgrades.
- Verify the project builds and tests pass after remediation.
- Apply security checks after upgrade and transformation tasks are complete.
