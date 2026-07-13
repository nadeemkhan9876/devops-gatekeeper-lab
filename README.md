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

## 🚀 Architecture & Workflow
1. **Code Commit:** Developer pushes code to GitHub.
2. **Build Stage:** GitHub Actions runner provisions an environment and builds the Docker image locally.
3. **Security Gate (Trivy):** The image is scanned for **CRITICAL** vulnerabilities. If any are found, the pipeline fails with a non-zero exit code and terminates.
4. **Secure Push:** If the scan passes, the image is securely pushed to Azure Container Registry (ACR).

## 🛠️ Tech Stack & Tools
* **CI/CD Platform:** GitHub Actions
* **Security Scanner:** Aqua Security Trivy
* **Containerization:** Docker
* **Cloud Infrastructure:** Azure Container Registry (ACR)

## 🧪 Validation & Testing Scenarios
To validate the effectiveness of the gatekeeper, two distinct scenarios were tested:

### Scenario A: Secure Code Path (`main` branch)
* **Base Image:** `python:3.11-slim`
* **Result:** 0 CRITICAL vulnerabilities detected. The pipeline successfully completed and pushed the image to ACR.

### Scenario B: Insecure Code Path (`vulnerable` branch)
* **Base Image:** `python:3.6`
* **Result:** Multiple CRITICAL vulnerabilities caught. The pipeline broke deliberately, safely blocking the image from deployment.

## 📁 Evidence & Artifacts
The results of the isolation mechanism can be verified in the pipeline history and registry storage logs. Only the secure image tag from the `main` branch is permitted entry into the cloud repository.
