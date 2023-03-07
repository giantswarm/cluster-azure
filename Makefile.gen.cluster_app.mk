# DO NOT EDIT. Generated with:
#
#    devctl@5.19.1-dev
#


REPO_NAME=$(shell basename ${PWD})
CHART_DIR=./helm/${REPO_NAME}

.PHONY: normalize-schema
normalize-schema:
	go install github.com/giantswarm/schemalint@latest
	schemalint normalize $(CHART_DIR)/values.schema.json -o $(CHART_DIR)/values.schema.json --force


.PHONY: validate-schema
validate-schema:
	go install github.com/giantswarm/schemalint@latest
	schemalint verify $(CHART_DIR)/values.schema.json --rule-set=cluster-app

.PHONY: generate-values
generate-values:
	go install github.com/giantswarm/helm-values-gen@latest
	helm-values-gen $(CHART_DIR)/values.schema.json -o $(CHART_DIR)/values.yaml --force

