CONTAINER_ENGINE ?= $(shell which podman >/dev/null 2>&1 && echo podman || echo docker)

.PHONY: test
test:
	# test python setup
	python -c 'import cdktf_cdktf_provider_aws'

	# test entrypoint.sh exists
	[ -f "entrypoint.sh" ]

.PHONY: build
build:
	$(CONTAINER_ENGINE) build -t er-base-cdktf-aws:test .

.PHONY: dev-venv
dev-venv:
	uv venv && uv pip install -r requirements.txt
