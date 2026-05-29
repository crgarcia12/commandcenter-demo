# Modernization Plan: Modernize ZavaFraudDetector and Deploy to Azure

**Project**: mnm-ZavaFraudDetector

---

## Technical Framework

- **Language**: Java 11
- **Framework**: Struts 2.5.x on Tomcat 9
- **Build Tool**: Gradle (WAR packaging)
- **Database**: Microsoft SQL Server
- **Key Dependencies**: Struts2 Core, Microsoft SQL Server JDBC Driver

---

## Overview

> This migration modernizes the ZavaFraudDetector application to the latest
> framework and deploys it to Azure using cloud-native services. The
> application currently runs as a legacy Java web application on Tomcat with
> direct SQL Server connectivity and external SSO integration. The new
> architecture will:
>
> - Upgrade runtime and framework foundations to a current supported baseline
> - Replace legacy operational patterns with Azure-native service integrations
> - Deploy the modernized application to Azure with secure, repeatable delivery
>
> The migration follows a phased approach: upgrade, service modernization,
> security remediation, and deployment.

---

## Migration Impact Summary

| Application | Original Service | New Azure Service | Authentication | Comments |
|-------------|------------------|-------------------|----------------|----------|
| ZavaFraudDetector | Legacy app host | Azure Container Apps | Managed Identity | Azure deployment target |
| ZavaFraudDetector | Local secret/config use | Azure Key Vault | Managed Identity | Cloud-native secret mgmt |
| ZavaFraudDetector | SQL auth model | Azure SQL + MI auth | Managed Identity | Passwordless DB access |

---

## Open Questions & Questionnaire

- [ ] Which Azure region should be used for deployment resources?
- [ ] Should Azure SQL be provisioned new or mapped to an existing instance?
