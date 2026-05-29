# mnm-ZavaFraudDetector

## Summary

| Metric | Value |
|--------|-------|
| Total Issues | 29 |
| Mandatory Blockers | 12 |
| Potential Issues | 11 |

## Component Information

| Property | Value |
|----------|-------|
| Language | Java |
| Frameworks | Apache Struts 2.5.30 |
| Build tools | Gradle 7.6 |
| JDK version | 11 |

## Cloud Readiness Issues

| Issue Name | Criticality | Story Points | Occurrences |
|------------|-------------|--------------|-------------|
| Apache Struts 2 has reached End-of-Life | Mandatory | 40 | [2](#Apache_Struts_2_has_reached_End-of-Life) |
| Database credentials committed in source-controlled properties file | Mandatory | 5 | [1](#Database_credentials_committed_in_source-controlled_properties_file) |
| No JDBC connection pool — connections opened via DriverManager | Mandatory | 5 | [1](#No_JDBC_connection_pool_connections_opened_via_DriverManager) |
| JDBC connection string disables TLS encryption | Mandatory | 2 | [1](#JDBC_connection_string_disables_TLS_encryption) |
| Auth gateway URL hardcoded in properties file | Potential | 3 | [1](#Auth_gateway_URL_hardcoded_in_properties_file) |
| No structured logging framework configured | Potential | 5 | [1](#No_structured_logging_framework_configured) |
| Health check does not validate database connectivity | Potential | 3 | [1](#Health_check_does_not_validate_database_connectivity) |
| Configuration bundled inside WAR artifact | Potential | 3 | [1](#Configuration_bundled_inside_WAR_artifact) |
| No role-based access control — all authenticated users have full access | Potential | 8 | [1](#No_role-based_access_control_all_authenticated_users_have_full_access) |
| No JDBC transaction management — auto-commit per statement | Optional | 5 | [1](#No_JDBC_transaction_management_auto-commit_per_statement) |
| Session tokens stored as plaintext in SQL Server | Optional | 5 | [1](#Session_tokens_stored_as_plaintext_in_SQL_Server) |

### Issue Details

<details id="Apache_Struts_2_has_reached_End-of-Life">
<summary><b>Apache Struts 2 has reached End-of-Life</b> — affected files</summary>

- `build.gradle (line 13)`
- `src/main/resources/struts.xml (line 1)`

</details>

<details id="Database_credentials_committed_in_source-controlled_properties_file">
<summary><b>Database credentials committed in source-controlled properties file</b> — affected files</summary>

- `src/main/resources/frauddetector.properties (line 4)`

</details>

<details id="No_JDBC_connection_pool_connections_opened_via_DriverManager">
<summary><b>No JDBC connection pool — connections opened via DriverManager</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/FraudConnectionFactory.java (line 19)`

</details>

<details id="JDBC_connection_string_disables_TLS_encryption">
<summary><b>JDBC connection string disables TLS encryption</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/FraudConfig.java (line 28)`

</details>

<details id="Auth_gateway_URL_hardcoded_in_properties_file">
<summary><b>Auth gateway URL hardcoded in properties file</b> — affected files</summary>

- `src/main/resources/frauddetector.properties (line 7)`

</details>

<details id="No_structured_logging_framework_configured">
<summary><b>No structured logging framework configured</b> — affected files</summary>

- `build.gradle (line 1)`

</details>

<details id="Health_check_does_not_validate_database_connectivity">
<summary><b>Health check does not validate database connectivity</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/HealthAction.java (line 7)`

</details>

<details id="Configuration_bundled_inside_WAR_artifact">
<summary><b>Configuration bundled inside WAR artifact</b> — affected files</summary>

- `src/main/resources/frauddetector.properties (line 1)`

</details>

<details id="No_role-based_access_control_all_authenticated_users_have_full_access">
<summary><b>No role-based access control — all authenticated users have full access</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/AuthTokenInterceptor.java (line 21)`

</details>

<details id="No_JDBC_transaction_management_auto-commit_per_statement">
<summary><b>No JDBC transaction management — auto-commit per statement</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/RuleEditAction.java (line 70)`

</details>

<details id="Session_tokens_stored_as_plaintext_in_SQL_Server">
<summary><b>Session tokens stored as plaintext in SQL Server</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/SsoSessionService.java (line 26)`

</details>

## Upgrade Issues

| Issue Name | Criticality | Story Points | Occurrences |
|------------|-------------|--------------|-------------|
| javax.servlet API usage — incompatible with Jakarta EE 10 and Tomcat 10+ | Mandatory | 8 | [3](#javax_servlet_API_usage_incompatible_with_Jakarta_EE_10_and_Tomcat_10) |
| Apache Struts 2 has reached End-of-Life | Mandatory | 40 | [2](#Apache_Struts_2_has_reached_End-of-Life) |
| Java 11 — upgrade to Java 21 LTS | Potential | 5 | [1](#Java_11_upgrade_to_Java_21_LTS) |

### Issue Details

<details id="javax_servlet_API_usage_incompatible_with_Jakarta_EE_10_and_Tomcat_10">
<summary><b>javax.servlet API usage — incompatible with Jakarta EE 10 and Tomcat 10+</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/AuthTokenInterceptor.java (line 7)`
- `src/main/java/com/zavabank/frauddetector/SsoSessionService.java (line 11)`
- `src/main/java/com/zavabank/frauddetector/LoginAction.java (line 5)`

</details>

<details id="Apache_Struts_2_has_reached_End-of-Life">
<summary><b>Apache Struts 2 has reached End-of-Life</b> — affected files</summary>

- `build.gradle (line 13)`
- `src/main/resources/struts.xml (line 1)`

</details>

<details id="Java_11_upgrade_to_Java_21_LTS">
<summary><b>Java 11 — upgrade to Java 21 LTS</b> — affected files</summary>

- `build.gradle (line 8)`

</details>

## Security Issues

> **Note:** These issues were generated by AI and may contain inaccuracies or incomplete information. Please review carefully.

| Issue Name | Criticality | Story Points | Files |
|------------|-------------|--------------|-------|
| CVE-2024-53677: Apache Struts file upload logic is flawed | Mandatory | 1 | [1](#CVE-2024-53677_Apache_Struts_file_upload_logic_is_flawed) |
| CVE-2023-50164: Apache Struts vulnerable to path traversal | Mandatory | 1 | [1](#CVE-2023-50164_Apache_Struts_vulnerable_to_path_traversal) |
| CVE-2025-68493: Apache Struts 2 is Missing XML Validation | Mandatory | 1 | [1](#CVE-2025-68493_Apache_Struts_2_is_Missing_XML_Validation) |
| CVE-2025-66675: Apache Struts has a Denial of Service vulnerability | Mandatory | 1 | [1](#CVE-2025-66675_Apache_Struts_has_a_Denial_of_Service_vulnerability) |
| CVE-2025-64775: Apache Struts is Vulnerable to DoS via File Leak | Mandatory | 1 | [1](#CVE-2025-64775_Apache_Struts_is_Vulnerable_to_DoS_via_File_Leak) |
| CVE-2023-41835: Apache Struts Improper Control of Dynamically-Managed Code Resources vulnerability | Mandatory | 1 | [1](#CVE-2023-41835_Apache_Struts_Improper_Control_of_Dynamically-Managed_Code_Resources_vulnerability) |
| CVE-2023-34396: Apache Struts vulnerable to memory exhaustion | Mandatory | 1 | [1](#CVE-2023-34396_Apache_Struts_vulnerable_to_memory_exhaustion) |
| CWE-820: Missing Synchronization | Potential | 8 | [2](#CWE-820_Missing_Synchronization) |
| CWE-567: Unsynchronized Access to Shared Data in a Multithreaded Context | Potential | 5 | [2](#CWE-567_Unsynchronized_Access_to_Shared_Data_in_a_Multithreaded_Context) |
| CWE-772: Missing Release of Resource after Effective Lifetime | Potential | 3 | [1](#CWE-772_Missing_Release_of_Resource_after_Effective_Lifetime) |
| CWE-775: Missing Release of File Descriptor or Handle after Effective Lifetime | Potential | 3 | [1](#CWE-775_Missing_Release_of_File_Descriptor_or_Handle_after_Effective_Lifetime) |
| CWE-778: Insufficient Logging | Potential | 3 | [3](#CWE-778_Insufficient_Logging) |
| CWE-259: Use of Hard-coded Password | Optional | 5 | [1](#CWE-259_Use_of_Hard-coded_Password) |
| CWE-732: Incorrect Permission Assignment for Critical Resource | Optional | 5 | [2](#CWE-732_Incorrect_Permission_Assignment_for_Critical_Resource) |
| CWE-798: Use of Hard-coded Credentials | Optional | 5 | [1](#CWE-798_Use_of_Hard-coded_Credentials) |
| CWE-477: Use of Obsolete Function | Optional | 1 | [1](#CWE-477_Use_of_Obsolete_Function) |

### Security Issue Details

<details id="CVE-2024-53677_Apache_Struts_file_upload_logic_is_flawed">
<summary><b>CVE-2024-53677: Apache Struts file upload logic is flawed</b> — affected files</summary>

- `build.gradle:13`

</details>

<details id="CVE-2023-50164_Apache_Struts_vulnerable_to_path_traversal">
<summary><b>CVE-2023-50164: Apache Struts vulnerable to path traversal</b> — affected files</summary>

- `build.gradle:13`

</details>

<details id="CVE-2025-68493_Apache_Struts_2_is_Missing_XML_Validation">
<summary><b>CVE-2025-68493: Apache Struts 2 is Missing XML Validation</b> — affected files</summary>

- `build.gradle:13`

</details>

<details id="CVE-2025-66675_Apache_Struts_has_a_Denial_of_Service_vulnerability">
<summary><b>CVE-2025-66675: Apache Struts has a Denial of Service vulnerability</b> — affected files</summary>

- `build.gradle:13`

</details>

<details id="CVE-2025-64775_Apache_Struts_is_Vulnerable_to_DoS_via_File_Leak">
<summary><b>CVE-2025-64775: Apache Struts is Vulnerable to DoS via File Leak</b> — affected files</summary>

- `build.gradle:13`

</details>

<details id="CVE-2023-41835_Apache_Struts_Improper_Control_of_Dynamically-Managed_Code_Resources_vulnerability">
<summary><b>CVE-2023-41835: Apache Struts Improper Control of Dynamically-Managed Code Resources vulnerability</b> — affected files</summary>

- `build.gradle:13`

</details>

<details id="CVE-2023-34396_Apache_Struts_vulnerable_to_memory_exhaustion">
<summary><b>CVE-2023-34396: Apache Struts vulnerable to memory exhaustion</b> — affected files</summary>

- `build.gradle:13`

</details>

<details id="CWE-820_Missing_Synchronization">
<summary><b>CWE-820: Missing Synchronization</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/FlaggedQueueAction.java`
- `src/main/java/com/zavabank/frauddetector/TransactionDetailAction.java`

</details>

<details id="CWE-567_Unsynchronized_Access_to_Shared_Data_in_a_Multithreaded_Context">
<summary><b>CWE-567: Unsynchronized Access to Shared Data in a Multithreaded Context</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/FlaggedQueueAction.java`
- `src/main/java/com/zavabank/frauddetector/TransactionDetailAction.java`

</details>

<details id="CWE-772_Missing_Release_of_Resource_after_Effective_Lifetime">
<summary><b>CWE-772: Missing Release of Resource after Effective Lifetime</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/SsoSessionService.java`

</details>

<details id="CWE-775_Missing_Release_of_File_Descriptor_or_Handle_after_Effective_Lifetime">
<summary><b>CWE-775: Missing Release of File Descriptor or Handle after Effective Lifetime</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/SsoSessionService.java`

</details>

<details id="CWE-778_Insufficient_Logging">
<summary><b>CWE-778: Insufficient Logging</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/SsoSessionService.java`
- `src/main/java/com/zavabank/frauddetector/AuthTokenInterceptor.java`
- `src/main/java/com/zavabank/frauddetector/FraudConfig.java`

</details>

<details id="CWE-259_Use_of_Hard-coded_Password">
<summary><b>CWE-259: Use of Hard-coded Password</b> — affected files</summary>

- `src/main/resources/frauddetector.properties`

</details>

<details id="CWE-732_Incorrect_Permission_Assignment_for_Critical_Resource">
<summary><b>CWE-732: Incorrect Permission Assignment for Critical Resource</b> — affected files</summary>

- `src/main/resources/frauddetector.properties`
- `Dockerfile`

</details>

<details id="CWE-798_Use_of_Hard-coded_Credentials">
<summary><b>CWE-798: Use of Hard-coded Credentials</b> — affected files</summary>

- `src/main/resources/frauddetector.properties`

</details>

<details id="CWE-477_Use_of_Obsolete_Function">
<summary><b>CWE-477: Use of Obsolete Function</b> — affected files</summary>

- `src/main/java/com/zavabank/frauddetector/FraudConnectionFactory.java`

</details>

---

## Codebase Insights

> **Note:** These documents are generated by AI and may contain inaccuracies or incomplete information. Please review carefully.

1. **[Architecture Diagram](facts/architecture-diagram.md)** — Understand the big picture: system layers and component relationships
2. **[Dependency Map](facts/dependency-map.md)** — Know what the project depends on and where the risks are
3. **[API & Service Contracts](facts/api-service-contracts.md)** — See how services communicate and what contracts they expose
4. **[Data Architecture](facts/data-architecture.md)** — Explore data models, storage, and data flow patterns
5. **[Configuration Inventory](facts/configuration-inventory.md)** — Review how the application is configured across environments
6. **[Business Workflows](facts/business-workflows.md)** — Trace end-to-end business processes and domain logic

[Share feedback](https://aka.ms/ghcp-appmod/feedback)
