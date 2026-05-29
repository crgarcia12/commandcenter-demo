# Modernization Plan: ZavaNotifyWorker Azure Migration

**Project**: ZavaNotifyWorker (ZavaBank)

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: Console Worker application (no web framework)
- **Build Tool**: MSBuild with packages.config (legacy project format)
- **Messaging**: RabbitMQ.Client 5.2.0 (polling queue consumer)
- **Email**: System.Net.Mail via SMTP (local mailhog)
- **Container**: Docker with Mono 6.12 runtime
- **Key Dependencies**: RabbitMQ.Client 5.2.0

---

## Overview

This migration modernizes the ZavaNotifyWorker — a background worker that consumes notification messages from a RabbitMQ queue and sends email alerts to Zava Bank customers — and deploys it to Azure. The application currently uses a self-hosted RabbitMQ broker for messaging and a local SMTP server (mailhog) for email delivery, with configuration stored in app.config.

The new architecture will:

- Replace RabbitMQ with Azure Service Bus for managed, scalable messaging with built-in dead-letter support
- Replace SMTP email with Azure Communication Services Email for enterprise-grade, reliable email delivery
- Centralize configuration in Azure App Configuration, eliminating app.config dependencies
- Adopt structured console logging suitable for Azure platform log aggregation
- Modernize the project structure from legacy packages.config to SDK-style PackageReference format
- Deploy to Azure Container Apps using a modern .NET runtime container image with Managed Identity for all Azure service authentication

The migration follows a phased approach: project structure modernization first, followed by parallel Azure service integrations, security CVE validation, and finally containerized deployment to Azure Container Apps.

---

## Migration Impact Summary

| Application      | Original Service      | New Azure Service                  | Authentication   | Comments                               |
|------------------|-----------------------|------------------------------------|------------------|----------------------------------------|
| ZavaNotifyWorker | RabbitMQ              | Azure Service Bus                  | Managed Identity | Queue consumer for email notifications |
| ZavaNotifyWorker | SMTP (mailhog)        | Azure Communication Services Email | Managed Identity | Email delivery for bank alerts         |
| ZavaNotifyWorker | app.config / env vars | Azure App Configuration            | Managed Identity | Externalize non-secret settings        |
| ZavaNotifyWorker | Console.WriteLine     | Structured Console Logging         | N/A              | Cloud-native log aggregation           |
| ZavaNotifyWorker | packages.config       | SDK-style PackageReference         | N/A              | Modernize project dependency format    |
| ZavaNotifyWorker | Mono Docker runtime   | Azure Container Apps (.NET Linux)  | Managed Identity | Deploy containerized to ACA            |

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No separate infra task; deployment task provisions new Azure resources using Bicep
- [x] Q: Should the plan include integration testing? → A: No — integration testing not explicitly requested
- [x] Q: Should the plan include security scan and CVE remediation? → A: Yes — default security/CVE remediation task included
- [x] Q: Which Azure deployment target should the plan use? → A: Azure Container Apps (default)
- [x] Q: Should containerization be a separate task from deployment? → A: No — deployment task covers containerization
