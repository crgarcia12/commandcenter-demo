# Policies

Enforceable standards and hard boundaries for modernization. Every policy here is validatable against generated artifacts.

## Guardrails (Hard Boundaries)

### Prohibited Technologies

| Technology | Reason | Approved Alternative |
|-----------|--------|---------------------|
| Service Bus | Not approved for use in this organization | Azure Cache for Redis |

### Required Elements

Every modernized application must include:

#### Cloud Resources

- Caching must use Redis Cache (Azure Cache for Redis). No other caching technology is permitted.
