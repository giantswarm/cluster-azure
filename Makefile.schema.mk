HELM_DIR:=helm/cluster-azure

generate-schema:
	cd $(HELM_DIR) && \
	helm schema-gen values.yaml > values.schema-generated.json && \
	jsonnet -e "(import 'values.schema-generated.json') + (import 'values.schema-static.libsonnet')" > values.schema.json && \
	schemalint normalize values.schema.json -o values.schema.json --force && \
	schemalint verify values.schema.json
