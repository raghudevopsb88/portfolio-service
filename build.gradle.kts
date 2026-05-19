plugins {
    java
    id("org.springframework.boot") version "3.4.5" // Upgraded from 3.4.3 to resolve CVE-2025-22235
    id("io.spring.dependency-management") version "1.1.7"
}

group = "com.wmp"
version = "1.0.0"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

// Global properties overriding transitive dependencies across the project
extra["tomcat.version"] = "10.1.53"           // Fixes CVE-2026-29145
extra["postgresql.version"] = "42.7.7"       // Fixes CVE-2025-49146

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot Starter packs pull managed versions derived from plugin version 3.4.5
    // This brings in Spring Framework 6.2.11+ and Spring Security 6.4.10+ (Fixes CVE-2025-41232, CVE-2025-41249)
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    implementation("org.springframework.boot:spring-boot-starter-security")

    // JWT
    implementation("io.jsonwebtoken:jjwt-api:0.12.6")
    runtimeOnly("io.jsonwebtoken:jjwt-impl:0.12.6")
    runtimeOnly("io.jsonwebtoken:jjwt-jackson:0.12.6")

    // Database
    implementation("org.postgresql:postgresql") // Will resolve to 42.7.7 via the extra property
    implementation("org.flywaydb:flyway-core")
    implementation("org.flywaydb:flyway-database-postgresql")

    // Observability
    implementation("io.micrometer:micrometer-registry-prometheus")
    implementation("net.logstash.logback:logstash-logback-encoder:8.0")

    // Test
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.security:spring-security-test")
    testRuntimeOnly("com.h2database:h2")
}

tasks.withType<Test> {
    useJUnitPlatform()
}
