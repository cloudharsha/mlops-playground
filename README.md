# mlops-playground
mlops-playground is a hands-on practice repository for learning and experimenting with MLOps workflows, including model training, packaging, CI/CD automation, artifact management, containerization, and deployment to Kubernetes-based platforms like EKS or AKS.

## Local kind cluster

Use [`scripts/setup-kind-mlflow.sh`](./scripts/setup-kind-mlflow.sh) to create a local kind cluster.

Prerequisites:
- Docker
- kind

Run:

```bash
./scripts/setup-kind-mlflow.sh
```

The script creates or reuses a kind cluster named `mlops-playground`.

Useful environment overrides:
- `CLUSTER_NAME`
- `KIND_NODE_IMAGE`
