# Modernization Plan: Zava Interest Calculator Azure Modernization

**Project**: ZavaInterestCalculator

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Java EE Servlet 3.1 (javax.servlet)
- **Build Tool**: Gradle (WAR packaging)
- **Database**: Microsoft SQL Server (JDBC)
- **Key Dependencies**: javax.servlet-api, mssql-jdbc, org.json

---

## Overview

> This migration modernizes the Zava Interest Calculator application and deploys it to Azure. The application currently runs as a Java 8 WAR with servlet-based APIs and SQL Server connectivity. The new architecture will:
>
> - Upgrade the application runtime/framework baseline to a modern supported Java stack.
> - Shift core platform dependencies to Azure cloud-native managed services.
> - Deploy the modernized workload to Azure with a production deployment flow.
>
> The migration follows a phased approach: runtime upgrade first, cloud-service transformation second, security remediation third, and deployment last.

---

## Migration Impact Summary

| Application | Original Service | New Azure Service | Authentication | Comments |
|-------------|------------------|-------------------|----------------|----------|
| ZavaInterestCalculator | SQL Server + plaintext app config | Azure SQL + Azure Key Vault + Azure Container Apps | Managed Identity | Modernize to latest framework and Azure cloud-native services, then deploy |

---

## Open Questions & Questionnaire

- [ ] Preferred Azure region for deployment target is not specified.
- [ ] Existing vs new Azure resources for deployment are not specified.

---

## Security Compliance

**Description**: Scan all project dependencies for known CVEs and remediate any identified vulnerabilities to ensure the application is secure before deployment.

**Requirements**:
- Upgrade vulnerable dependencies to minimum patched versions.
- If a CVE fix requires a major version upgrade, document upgrade risk and compatibility impact.
- Verify project build and tests after remediation.
