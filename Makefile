RESOURCES := $(shell yq e '.resources[].name' datapackage.yaml)
DATA_FILES := $(shell yq e '.resources[].path' datapackage.yaml)
VALIDATION_FILES := $(addsuffix .json, $(addprefix validation/, $(RESOURCES)))

datapackage.json: datapackage.yaml data/* schemas/* validation/* README.md CHANGELOG.md CONTRIBUTING.md
	frictionless describe --type package --json datapackage.yaml > datapackage.json

$(VALIDATION_FILES): validation/%.json: data/%.csv scripts/validate_resource.py
	python scripts/validate_resource.py --datapackage datapackage.yaml $* > $@

$(DATA_FILES): data/%.csv: data/raw/%.csv
	rsync --itemize-changes --checksum data/raw/* data/
