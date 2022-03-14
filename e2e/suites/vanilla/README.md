# Kubernetes Suite

<!-- Based off: https://github.com/spiffe/spire/blob/main/test/integration/suites/k8s/README.md -->

## Description

This suite asserts that the plain (without any modifications) kustomize manifests
files deploy a usable spire setup which includes:

* SPIRE server attests SPIRE agents by verifying Kubernetes Projected Service
  Account Tokens (i.e. `k8s_psat`) via the Token Review API.
* Workloads are registered via the K8S Workload Registrar and are able to
  obtain identities without the need for manually maintained registration
  entries.
