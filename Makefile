e2e:
	@kind create cluster --config=e2e/kind.yaml | true
	@kustomize build manifests/ | kubectl apply -f -
	@./e2e/test.sh
.PHONY: e2e

clean-e2e:
	@kind delete cluster --name spire-kustomize-e2e
.PHONY: clean-e2e
