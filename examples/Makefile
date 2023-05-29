all: parca.json

.PHONY: lint
lint: *.jsonnet vendor
	@jsonnet-lint -J vendor *.jsonnet

%.json: %.jsonnet vendor
	@jsonnet -J vendor $< > $@

vendor:
	@rm -rf $@
	@jb install
