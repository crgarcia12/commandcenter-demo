# Modernization Plan: Zava Wire Transfer Service — Azure Modernization

**Project**: ZavaWireTransferService

---

## Technical Framework

- **Language**: Java 11
- **Framework**: Java EE Servlets (Tomcat 9, no Spring)
- **Build Tool**: Gradle 7.6
- **Database**: SQL Server (mssql-jdbc 12.6.3) → Azure SQL Database
- **Messaging**: RabbitMQ AMQP (amqp-client 5.20.0) → Azure Service Bus
- **Key Dependencies**: javax.servlet-api 4.0.1, org.json 20140107, mssql-jdbc, amqp-client

---

## Overview

This migration modernizes the ZavaWireTransferService — a Java EE servlet-based banking wire transfer application — to run securely on Azure. The application currently uses RabbitMQ for event messaging, SQL Server for persistence, and stores credentials as plaintext in properties files and the Dockerfile.

The new architecture will:

- Replace RabbitMQ AMQP messaging with Azure Service Bus for cloud-native, managed event publishing
- Eliminate all hardcoded credentials by migrating secrets to Azure Key Vault with managed identity access
- Remediate known CVE vulnerabilities in outdated dependencies (notably `org.json:json:20140107` from 2014)
- Deploy the containerized application to Azure Container Apps using the existing Dockerfile

The migration follows a phased approach: messaging and credentials migration first, then security hardening, and finally containerized deployment to Azure.

---

## Migration Impact Summary

```
| Application             | Original Service   | New Azure Service        | Authentication    | Comments                                    |
|-------------------------|--------------------|--------------------------|-------------------|---------------------------------------------|
| ZavaWireTransferService | RabbitMQ AMQP      | Azure Service Bus        | Managed Identity  | Java EE AMQP client → Service Bus SDK      |
| ZavaWireTransferService | SQL Server (local) | Azure SQL Database       | Managed Identity  | Same JDBC driver; credentials via Key Vault |
| ZavaWireTransferService | Plaintext secrets  | Azure Key Vault          | Managed Identity  | DB/RabbitMQ creds in props & Dockerfile     |
| ZavaWireTransferService | Tomcat WAR (local) | Azure Container Apps     | Managed Identity  | Existing Dockerfile; new ACA deployment     |
```

---

## Modernization Tasks

### Task 1 — Migrate RabbitMQ AMQP to Azure Service Bus

Replace the RabbitMQ AMQP client with Azure Service Bus SDK. Update exchange/routing key patterns to use Service Bus topics and subscriptions. Configure managed identity authentication.

**Skill**: `migration-java-ee-amqp-rabbitmq-servicebus`

---

### Task 2 — Migrate Plaintext Credentials to Azure Key Vault

Remove all hardcoded credentials (SQL Server SA password, RabbitMQ guest/guest) from `wire-transfer.properties` and `Dockerfile`. Store secrets in Azure Key Vault and retrieve them at runtime using managed identity.

**Skill**: `migration-plaintext-credential-to-azure-keyvault`

---

### Task 3 — Security & CVE Remediation

Scan all project dependencies for known CVEs and remediate identified vulnerabilities. Particular attention to `org.json:json:20140107` (2014 release with known CVE history). Upgrade vulnerable dependencies to minimum patched versions.

**Skill**: `validate-cves-and-fix`

---

### Task 4 — Deploy to Azure Container Apps

Containerize and deploy the application to Azure Container Apps using the existing Dockerfile. Configure environment variables for Azure SQL Database, Azure Service Bus, and Azure Key Vault endpoints. Enable managed identity for all Azure service connections.

**Skill**: `azcli-containerapp-deploy`

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No explicit infra provisioning requested; deployment task will create new Azure Container Apps resources using Bicep
- [x] Q: Should the plan include integration testing? → A: Not explicitly requested; skipped
- [x] Q: Should the plan include security/CVE remediation? → A: Yes (default) — notable CVE risk in `org.json:json:20140107` and other outdated dependencies
- [x] Q: Which Azure deployment target? → A: Azure Container Apps (default) — existing Dockerfile present
