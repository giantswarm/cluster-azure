# DO NOT EDIT. Generated with:
#
#    devctl@5.21.0
#


VALUES=$(shell find ./helm -maxdepth 2 -name values.yaml)
VALUES_SCHEMA=$(shell find ./helm -maxdepth 2 -name values.schema.json)

.PHONY: normalize-schema
normalize-schema:
	go install github.com/giantswarm/schemalint@v1
	schemalint normalize $(VALUES_SCHEMA) -o $(VALUES_SCHEMA) --force

.PHONY: validate-schema
validate-schema:
	go install github.com/giantswarm/schemalint@v1
	schemalint verify $(VALUES_SCHEMA) --rule-set=cluster-app

.PHONY: generate-values
generate-values:
	go install github.com/giantswarm/helm-values-gen@v1
	helm-values-gen $(VALUES_SCHEMA) -o $(VALUES) --force

