all: parca.json

parca.json: parca.libsonnet vendor
	@jsonnet -J vendor $< > $@

vendor:
	@rm -rf $@
	@jb install
