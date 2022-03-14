# Spire kustomize manifests

## TODO

- [ ] Update all the repo URLs (https://github.com/GerardoGR/spire-kustomize/manifests) to use the real repo

Spire kustomize manifests to deploy: spire-server, spire-agent and k8s-workload-registrar

## Quickstart

Assuming a running Kubernetes cluster and a kubectl configured to access it run:

```shell
kustomize build https://github.com/GerardoGR/spire-kustomize/manifests | kubectl apply -f -
```

This will do 2 things:

1. Get the Kustomize manifests to run the spire components using this repository `main` branch
2. Apply the spire components' manifests into the configured Kubernetes cluster


## Customization

It is also possible to further customize the spire server and/or agent by referencing this repository in a new `kustomization.yaml` and applying patches. For example:

```shell
$ cat <<EOF > kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - https://github.com/GerardoGR/spire-kustomize/manifests

  # Or to use a specific commit or tag revision
  # - https://github.com/GerardoGR/spire-kustomize/manifests?ref=v0.0.1

patches:
  - patch: |-
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: spire-agent
        namespace
      data:
        agent.conf: |
          agent {
            data_dir = "/run/spire"
            log_level = "INFO" # Log level changed from DEBUG to INFO
            server_address = "spire-server"
            server_port = "8081"
            socket_path = "/run/spire/sockets/agent.sock"
            trust_bundle_path = "/run/spire/bundle/bundle.crt"
            trust_domain = "a-new-domain" # Domain changed from my-domain to a-new-domain
          }

          plugins {
            NodeAttestor "k8s_psat" {
              plugin_data {
                cluster = "local-k8s"
              }
            }

            KeyManager "memory" {
              plugin_data {
              }
            }

            WorkloadAttestor "k8s" {
              plugin_data {
                skip_kubelet_verification = true
              }
            }
          }
EOF

$ kustomize build . | kubectl apply -f -
```

For more information on how to extend and work with kustomize manifests consult the [official kustomize documentation](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/).

## Contributing

For more information on how to get started to contribute to the project check the [CONTRIBUTING](CONTRIBUTING.md) documentation.
[GitHub Issues](https://github.com/GerardoGR/spire-kustomize/issues) are used to request features or file bugs.
