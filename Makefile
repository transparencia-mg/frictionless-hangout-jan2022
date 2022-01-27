.PHONY: help ingest build validate

RESOURCES := $(shell yq e '.resources[].name' datapackage.yaml)

DATA_FILES := $(shell yq e '.resources[].path' datapackage.yaml)

VALIDATION_FILES := $(addsuffix .json, $(addprefix validation/, $(RESOURCES)))

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

build: datapackage.json

datapackage.json: datapackage.yaml data/* schemas/* validation/* README.md CHANGELOG.md CONTRIBUTING.md
	frictionless describe --type package --json datapackage.yaml > datapackage.json

validate: $(VALIDATION_FILES)

$(VALIDATION_FILES): validation/%.json: data/%.csv scripts/validate_resource.py
	python scripts/validate_resource.py --datapackage datapackage.yaml $* > $@

ingest: $(DATA_FILES) ## Ingest modified raw files (data/raw/) into data/

$(DATA_FILES): data/%.csv: data/raw/%.csv
	rsync --itemize-changes --checksum data/raw/* data/