```mermaid
flowchart TD
    A[Developer] -->|Push Code| B[GitHub Repository]
    B -->|Trigger CI/CD| C[GitHub Actions Workflow]

    C -->|Provision Infra| D[Terraform on AWS]
    D -->|Creates| E[ECR - Container Registry]
    D -->|Creates| F[EKS - Kubernetes Cluster]

    C -->|Build & Push Docker Image| E
    C -->|Deploy via Helm| F

    F -->|Runs Flask App in Pods| G[Flask App Container]
    G --> H[Kubernetes Service - LoadBalancer]
    H --> I[End User Browser]

    %% Styling for better visibility in both modes
    style A fill:#4B9CD3,stroke:#1B4F72,stroke-width:1px,color:#fff
    style B fill:#6C5CE7,stroke:#2E1A47,stroke-width:1px,color:#fff
    style C fill:#00B894,stroke:#004D40,stroke-width:1px,color:#fff
    style D fill:#F39C12,stroke:#784212,stroke-width:1px,color:#fff
    style E fill:#E84393,stroke:#6C1B45,stroke-width:1px,color:#fff
    style F fill:#0984E3,stroke:#0D47A1,stroke-width:1px,color:#fff
    style G fill:#00CEC9,stroke:#004D4D,stroke-width:1px,color:#fff
    style H fill:#2D3436,stroke:#000,stroke-width:1px,color:#fff
    style I fill:#636E72,stroke:#2d3436,stroke-width:1px,color:#fff
