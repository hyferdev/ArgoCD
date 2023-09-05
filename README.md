# ArgoCD Deployment with Terraform

This repository contains the necessary files and instructions to deploy an ArgoCD environment using Terraform. ArgoCD is a declarative, GitOps continuous delivery tool that simplifies application deployment and management within Kubernetes clusters.

## Prerequisites

Before you begin, make sure you have the following prerequisites in place:

- Terraform installed on your local machine.
- Access to your cloud provider account (e.g., AWS, GCP, Azure) with the necessary credentials for creating resources.
- Familiarity with Kubernetes and Terraform concepts.

## Getting Started

To get started with this ArgoCD deployment, follow these steps:

1. **Clone this repository to your local machine:**

   ```bash
   git clone https://github.com/hyferdev/ArgoCD.git
   cd ArgoCD
   ```

2. **Review and Customize Terraform Configuration:**

   Navigate to the ArgoCD directory and review the Terraform configuration files. Modify these files according to your requirements, including specifying the cloud provider, region, cluster size, or any other desired configurations.

3. **Initialize Terraform and Download Provider Plugins:**

   ```bash
   terraform init
   ```

4. **Review and Validate the Terraform Execution Plan:**

   ```bash
   terraform plan
   ```

   Ensure that the plan output aligns with your expectations and that there are no errors or warnings.

5. **Apply the Terraform Configuration:**

   ```bash
   terraform apply
   ```

   Confirm the deployment by typing "yes" when prompted. The provisioning process may take several minutes, depending on the size of your infrastructure.

6. **Confirm ArgoCD and Kubernetes Cluster is running:**

   SSH to your newly created VM
   Expose ArgoCD-Server node ports

    ```bash
   kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
   minikube service argocd-server -n argocd
   ```

   Query ArgoCD initial password

    ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
   ```

   Loggin to ArgoCD (use the ip and port you get from the exposing node ports)

    ```bash
   argocd login <argocd-server ip and port>
   ```

## Cleaning Up

To remove the ArgoCD deployment and associated resources, use Terraform to destroy the infrastructure:

```bash
terraform destroy
```

When prompted, type "yes" to confirm the destruction. Be cautious, as this action is irreversible and will delete all resources created by Terraform.

## Contributions

Contributions to this project are welcome! If you encounter issues or have suggestions for improvement, please reach out on linkedin(https://www.linkedin.com/in/desire-banyeretse/) or submit a pull request. I am working on getting ArgoCD service exposed to the internet, any sugestions are welcome.

## License

This project is licensed under the MIT License. Feel free to modify and distribute it as needed.
