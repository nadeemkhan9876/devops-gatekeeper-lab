# Automated Container Security Pipeline (DevSecOps Gatekeeper)

An automated, cloud-native CI/CD security pipeline designed to enforce vulnerability gating before container images are deployed to cloud environments. This project demonstrates the practical implementation of **"Shifting Security Left"** by intercepting insecure configurations at the automated testing phase, preventing image registry pollution.

---

## 🚀 Architecture & Workflow

The pipeline utilizes an automated checklist that executes sequentially on a fresh cloud-hosted runner for every code commit:

```text
 [Code Push] ──> [Build Local Docker Image] ──> [Trivy Security Scan]
                                                        │
                                        ┌───────────────┴───────────────┐
                                   (Passes Scan)                  (Fails Scan)
                                        │                               │
                                        ▼                               ▼
                           [Push to Azure Registry]          [Pipeline Terminated]
                                                             (Registry Protected!)

Code Checkout: GitHub Actions provisions an isolated Ubuntu runner and checks out the source code repository.

ACR Authentication: Securely authenticates with the cloud environment using encrypted repository secrets (ACR_LOGIN_SERVER, ACR_USERNAME, ACR_PASSWORD).

Local Compilation: Builds the container image locally on the runner's ephemeral drive using the Dockerfile configuration.

Automated Security Gate (Trivy): Evaluates the filesystem and dependencies of the built container image against current CVE databases.

Conditional Deployment: Uses a logical gating condition (if: success()). If the image contains zero severe security bugs, it ships to storage. If a threat is detected, the workflow returns a non-zero exit code (exit-code: 1), breaking the build instantly.

🛠️ Technical Stack & Frameworks
CI/CD Orchestration: GitHub Actions

Static Application Security Testing (SAST) / Container Scanning: Aqua Security Trivy (v0.36.0)

Containerization Engine: Docker Core

Cloud Infrastructure Environment: Azure Container Registry (ACR)

🧪 Validation & Test Scenarios
To verify the enforcement capabilities of the security gatekeeper, the workflow was rigorously tested across two distinct operational scenarios:

🟢 Scenario A: Compliant Production Path (main branch)
Base Configuration: FROM python:3.11-slim

Vulnerability Assessment: Retrospectively clean image layer baseline.

Scan Result: 0 CRITICAL vulnerabilities found.

Pipeline Status: PASSED (Green). Image successfully authenticated and pushed to Azure Container Registry.

🔴 Scenario B: Non-Compliant/Legacy Path (vulnerable branch)
Base Configuration: FROM python:3.6

Vulnerability Assessment: Inherited multiple unpatched high-severity CVE dependencies due to an outdated runtime environment.

Scan Result: Multiple CRITICAL vulnerabilities identified.

Pipeline Status: FAILED (Red). The gatekeeper successfully aborted the process, isolating the threat and blocking transmission to Azure.
