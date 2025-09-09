# DevOps Notes

A curated collection of concise notes, mini-guides, and reference docs for various DevOps concepts. Each folder groups related topics (e.g., Docker, Kubernetes, Terraform) into smaller Markdown files so knowledge stays organized and easy to navigate.

---

## 📂 Project Structure

```
devops-notes/
├── docker/        # Docker basics, images, containers, networking, best practices
├── kubernetes/    # Kubernetes concepts, manifests, controllers, ingress, etc.
├── terraform/     # Infrastructure as Code with Terraform
│   ├── providers/ # Provider-specific notes (e.g., AWS, Kubernetes, Helm)
│   ├── modules/   # How to structure and reuse modules
│   └── state/     # Remote backends, state locking, workspaces
├── cicd/          # CI/CD systems (GitHub Actions, GitLab CI, Jenkins)
└── README.md      # (this file)
```

---

## ✅ How to Use

* Browse folders for the tool/area you're working with.
* Each concept is documented as a **separate Markdown file** (e.g., `aws-eks-kubernetes-helm.md`).
* Use subfolder `README.md` files as indexes.
* Notes are intentionally **short and practical** — think cheat sheets or concept primers.

---

## 📌 Examples of Notes

* **Terraform → Providers →** [AWS EKS with Kubernetes & Helm](terraform/providers/aws-eks-kubernetes-helm.md)
* **Docker →** image layers, networking, multi-stage builds
* **Kubernetes →** deploying workloads, configuring ingress, RBAC basics
* **CI/CD →** GitHub Actions workflows, GitLab CI pipelines

---

## 🎯 Goal

This repo serves as a **personal knowledge base** for DevOps, cloud, and infra-as-code topics. Rather than one giant guide, each note is a bite-sized reference that can be quickly searched and extended over time.
