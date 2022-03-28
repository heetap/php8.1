IMAGE_TAG   ?= v0.0.8

IMAGE_NAME  ?= php8.1-debian

VENDOR_NAME  = heetap

DIR = $(notdir $(shell pwd))

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
Makefile: ;              # skip prerequisite discovery

.PHONY: build
build:
	docker build -t $(VENDOR_NAME)/$(IMAGE_NAME):$(IMAGE_TAG) --no-cache --force-rm .

.PHONY: push
push:
	docker push $(VENDOR_NAME)/$(IMAGE_NAME):$(IMAGE_TAG)

%:
	@:
