# Modernization Plan: ZavaLedger modernization to Azure

**Project**: ZavaLedger

---

## Technical Framework

- **Language**: Java 17
- **Framework**: Java Servlet API 4.0.1 (WAR deployment on Tomcat)
- **Build Tool**: Gradle
- **Database**: Microsoft SQL Server (JDBC)
- **Key Dependencies**: javax.servlet-api, mssql-jdbc

---

## Overview

> This migration modernizes ZavaLedger and deploys it to Azure. The
> application currently runs as a Java WAR service on Tomcat with
> SQL Server-backed persistence and environment/property-based
> configuration. The new architecture will:
>
> - Upgrade the application runtime/framework baseline to a current,
>   supported Java platform for long-term maintainability.
> - Modernize application integrations to cloud-native Azure services
>   for security, operations, and production readiness.
> - Deploy the modernized workload to Azure Container Apps to align
>   with managed, cloud-native hosting.
>
> The migration follows a phased approach: baseline modernization,
> targeted cloud-native service transformations, security remediation,
> and Azure deployment.

---

## Migration Impact Summary

| Application | Original Service | New Azure Service | Authentication | Comments |
|-------------|------------------|-------------------|----------------|----------|
| ZavaLedger | Local/runtime config & secrets | Azure Key Vault | Managed Identity | Cloud-native secret management |
| ZavaLedger | Current Java runtime/framework baseline | Latest supported Java platform | N/A | Framework/runtime modernization |
| ZavaLedger | Local/container host deployment | Azure Container Apps | Managed Identity | Managed Azure deployment target |

---

## Security Compliance

Security and CVE remediation will be executed after upgrade and
transformation activities and before deployment to ensure the
modernized application is free of known vulnerabilities.

---

## Open Questions & Questionnaire

- [x] Q: Include infrastructure provisioning? → A: No; focus on app modernization and deployment tasks.
- [x] Q: Include integration testing task? → A: No explicit request; not included in this plan.
- [x] Q: Include security/CVE remediation task? → A: Yes (default), included.
- [x] Q: Deployment target? → A: Azure Container Apps (default).
