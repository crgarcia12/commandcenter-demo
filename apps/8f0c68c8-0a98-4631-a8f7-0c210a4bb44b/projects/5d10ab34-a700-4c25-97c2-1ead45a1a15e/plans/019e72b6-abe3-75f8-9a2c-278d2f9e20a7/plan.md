# Modernization Plan: ZavaBatchScheduler — Modernize and Deploy to Azure

**Project**: ZavaBatchScheduler

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Plain Java (no Spring framework)
- **Build Tool**: Gradle 7.6 with Shadow JAR plugin
- **Database**: Microsoft SQL Server (password-based JDBC authentication)
- **Key Dependencies**: RabbitMQ AMQP client (`com.rabbitmq:amqp-client:5.21.0`), SQL Server JDBC (`mssql-jdbc:12.6.1.jre8`)
- **Container**: Dockerfile exists (eclipse-temurin:8-jre base image)

---

## Overview

This migration modernizes the ZavaBatchScheduler, a scheduled Java batch job that orchestrates banking operations (interest accrual, statement generation, daily reconciliation) by calling downstream HTTP services and logging results to SQL Server. The application currently uses password-based SQL Server authentication and includes a RabbitMQ AMQP client dependency.

The new architecture will:

- Replace password-based SQL Server authentication with Azure Managed Identity, eliminating hardcoded credentials and improving security posture for Azure SQL Database connectivity.
- Migrate the RabbitMQ AMQP messaging dependency to Azure Service Bus, enabling cloud-native, managed message brokering on Azure.
- Scan and remediate all known CVEs in project dependencies before deployment.
- Deploy the containerized application to Azure Container Apps for a fully managed, scalable runtime on Azure.

The migration follows a phased approach: service migrations first, then security hardening, then deployment.

---

## Migration Impact Summary

| Application          | Original Service         | New Azure Service              | Authentication     | Comments                                  |
|----------------------|--------------------------|--------------------------------|--------------------|-------------------------------------------|
| ZavaBatchScheduler   | SQL Server (JDBC/password) | Azure SQL Database           | Managed Identity   | Remove db.username/db.password credentials |
| ZavaBatchScheduler   | RabbitMQ (AMQP client)  | Azure Service Bus              | Managed Identity   | AMQP client in build.gradle               |
| ZavaBatchScheduler   | Local container (JDK 8) | Azure Container Apps           | N/A                | Existing Dockerfile will be updated        |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No existing infrastructure configuration found in repository. Deployment task will provision and deploy to Azure Container Apps.
- [x] Q: Should the plan include integration testing? → A: No — user did not explicitly request integration tests; skipped.
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes — default; CVE scan and remediation included before deployment.
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default) — user requested "deploy to Azure"; ACA chosen as the default target.
- [x] Q: Should the plan include containerization? → A: Covered by the deployment task; no separate containerization task needed.
