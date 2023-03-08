.PHONY: schema-normalize
schema-normalize:
	go install github.com/giantswarm/schemalint@latest
	schemalint normalize ./helm/cluster-azure/values.schema.json -o ./helm/cluster-azure/values.schema.json --force


.PHONY: schema-validate
schema-validate:
	go install github.com/giantswarm/schemalint@latest
	schemalint verify ./helm/cluster-azure/values.schema.json --rule-set=cluster-app

.PHONY: values-generate
values-generate:
	go install github.com/giantswarm/helm-values-gen@latest
	helm-values-gen ./helm/cluster-azure/values.schema.json -o ./helm/cluster-azure/values.yaml --force
