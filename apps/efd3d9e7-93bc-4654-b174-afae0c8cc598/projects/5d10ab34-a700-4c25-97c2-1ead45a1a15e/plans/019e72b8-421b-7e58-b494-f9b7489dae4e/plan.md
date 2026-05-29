# Modernization Plan: ZavaACHProcessor — Modernize and Deploy to Azure

**Project**: ZavaACHProcessor

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Plain Java (no Spring framework)
- **Build Tool**: Gradle 7.6 with Shadow plugin (fat JAR)
- **Database**: MS SQL Server JDBC dependency present (not directly used in application code)
- **Key Dependencies**: `com.rabbitmq:amqp-client:5.21.0`, `com.microsoft.sqlserver:mssql-jdbc:12.6.1.jre8`

---

## Overview

> This migration modernizes the ZavaACHProcessor application — a plain Java ACH
> batch file processor — to run natively on Azure using managed cloud services.
> The application currently polls a local file system directory for NACHA-format
> ACH files, posts transactions to a ledger HTTP endpoint, and publishes events
> to RabbitMQ using the AMQP protocol with plaintext credentials.
>
> The new architecture will:
>
> - Replace RabbitMQ AMQP messaging with Azure Service Bus for reliable,
>   cloud-native event publishing (processed/failed ACH events)
> - Migrate local file system paths to mounted Azure Storage for durable,
>   cloud-accessible ACH file intake and archival
> - Replace plaintext RabbitMQ credentials with Azure Key Vault for centralized
>   and secure secret management
> - Scan and remediate known CVEs in project dependencies before deployment
> - Deploy the containerized application to Azure Container Apps
>
> The migration follows a phased approach: service migrations first, then
> security hardening, then deployment to Azure.

---

## Migration Impact Summary

| Application        | Original Service        | New Azure Service           | Authentication    | Comments                          |
|--------------------|-------------------------|-----------------------------|-------------------|-----------------------------------|
| ZavaACHProcessor   | RabbitMQ (AMQP)         | Azure Service Bus           | Managed Identity  | Events: ach.processed, ach.failed |
| ZavaACHProcessor   | Local file system paths | Mounted Azure Storage       | Managed Identity  | ACH incoming, processed, error    |
| ZavaACHProcessor   | Plaintext credentials   | Azure Key Vault             | Managed Identity  | RabbitMQ host/port/user/password  |
| ZavaACHProcessor   | N/A                     | Azure Container Apps        | Managed Identity  | New deployment target             |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — no infrastructure provisioning found in the repository; focus on code migration only
- [x] Q: Should the plan include integration testing? → A: No — integration testing not explicitly requested
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes — include security/CVE remediation (default)
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default)
- [x] Q: Should the plan include containerization? → A: Skipped — Azure Container Apps deployment task covers containerization; existing Dockerfile will be updated as needed
