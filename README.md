# Smurf Village Cloud Management

A themed learning project for managing multiple AWS accounts with Terraform, AWS Organizations and Service Control Policies.

**Status:** The default branch contains only this README. Infrastructure definitions are proposed in the separate, unmerged initialization PR.

## Proposed governance architecture

```mermaid
flowchart TD
  Terraform["Terraform configuration"] -.-> Org["AWS Organizations"]
  Terraform -.-> SCP["Service Control Policies"]
  SCP -.->|governance boundaries| Org
  Org -.-> AccountA["Smurf workload account"]
  Org -.-> AccountB["Another Smurf account"]
  AccountA -.-> Workloads["Account-specific workloads"]
  AccountB -.-> Workloads
```

Dashed connections show the intended design. This repository's default branch has not implemented or provisioned these components.

## Start here

Review [initialization PR #1](https://github.com/mtzanida/smurf-village-cloud-management/pull/1) and define the account structure and policy requirements before deployment. No Terraform run command applies to the current README-only branch.
