# Modernization Plan: Modernize ZavaQueueBridge and Deploy to Azure

**Project**: ZavaQueueBridge

---

## Technical Framework

- **Language**: C# / .NET Framework 4.8
- **Framework**: Console application (long-running worker)
- **Build Tool**: MSBuild with NuGet (legacy packages.config / non-SDK-style csproj)
- **Messaging**: RabbitMQ (via RabbitMQ.Client 5.2.0)
- **Key Dependencies**: RabbitMQ.Client 5.2.0, System.Web.Extensions (JavaScriptSerializer)
- **Container Runtime**: Mono 6.12 (legacy Docker base image)

---

## Overview

> This migration modernizes the ZavaQueueBridge .NET Framework 4.8 console application for
> deployment to Azure Container Apps. The application currently watches a local file drop
> folder and publishes file records to RabbitMQ exchanges using a legacy Mono-based Docker
> container. The new architecture will:
>
> - Replace the legacy .NET Framework 4.8 / Mono runtime with .NET 10 on a native Linux
>   container, enabling proper Azure SDK support and modern Docker deployment.
> - Replace RabbitMQ with Azure Service Bus using Managed Identity authentication,
>   eliminating hardcoded credentials and providing enterprise-grade messaging.
> - Migrate the local file drop folder to Azure Files-mounted storage so the worker can
>   operate on cloud-backed file drops in a stateless container environment.
> - Improve cloud observability by configuring structured console logging suited for Azure
>   container log aggregation.
>
> The migration follows a phased approach: runtime upgrade first, then service migrations,
> then security hardening, and finally deployment to Azure Container Apps.

---

## Migration Impact Summary

| Application       | Original Service          | New Azure Service          | Authentication     | Comments                                  |
|-------------------|---------------------------|----------------------------|--------------------|-------------------------------------------|
| ZavaQueueBridge   | RabbitMQ (self-hosted)    | Azure Service Bus          | Managed Identity   | Exchange/topic publish pattern preserved  |
| ZavaQueueBridge   | Local file system path    | Azure Files (mounted path) | Managed Identity   | FileSystemWatcher pattern maintained      |

---

## Modernization Tasks

### Task 1 — Upgrade .NET to .NET 10

Upgrade the project from .NET Framework 4.8 (non-SDK-style csproj, packages.config) to .NET 10
(SDK-style csproj, PackageReference). This is required to run as a native Linux container on
Azure Container Apps, use modern Azure SDK packages, and replace Mono-only APIs such as
`JavaScriptSerializer`.

### Task 2 — Migrate RabbitMQ to Azure Service Bus

Replace the `RabbitMQ.Client` dependency with Azure Service Bus. The existing exchange publish
logic, routing keys, and dead-letter behaviour must be preserved using Azure Service Bus
queues/topics and native dead-letter queue support. Authentication must use Managed Identity.

### Task 3 — Migrate File Drop to Azure Storage Mounted Path

Migrate the hardcoded local file drop path (`/shared/filedrop`) to an Azure Files mounted
storage path, while preserving the existing `FileSystemWatcher`-based detection and
processed/error subdirectory logic.

### Task 4 — Configure Console Logging for Cloud

Configure structured console logging so that log output from the worker is correctly captured
by Azure Container Apps log aggregation and Azure Monitor.

### Task 5 — Security & CVE Remediation

Scan all project dependencies for known CVEs after upgrade and service migrations. Remediate
identified vulnerabilities by upgrading to the minimum patched version. Verify the project
builds and all tests pass after remediation.

### Task 6 — Deploy to Azure Container Apps

Containerize the modernized application and deploy to Azure Container Apps. Generate a new
Dockerfile using the official .NET 10 runtime image, provision the Azure Container Apps
environment, and deploy the worker container.

---

## Open Questions & Questionnaire

- [x] Q: Should the plan include environment/infrastructure provisioning? → A: No — no
  infrastructure provisioning; the deployment task will create required resources via Bicep.
- [x] Q: Should the plan include integration testing? → A: No — not explicitly requested;
  skipped.
- [x] Q: Should the plan include a security scan and CVE remediation task? → A: Yes — include
  security/CVE remediation (default).
- [x] Q: Which Azure deployment target should be used? → A: Azure Container Apps (default).
