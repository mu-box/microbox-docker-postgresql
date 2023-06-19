# -*- mode: make; tab-width: 4; -*-
# vim: ts=4 sw=4 ft=make noet
all: build publish

LATEST:=10
stability?=stable
version?=$(LATEST)
dockerfile?=Dockerfile-$(version)
project=postgresql

login:
	@vagrant ssh -c "docker login"

build:
	@echo "Building '${project}' image..."
	@vagrant ssh -c "docker build -f /vagrant/Dockerfile-${version} -t mubox/${project} /vagrant"

publish:
	@echo "Tagging '${project}:${version}-${stability}' image..."
	@vagrant ssh -c "docker tag -f mubox/${project} mubox/${project}:${version}-${stability}"
	@echo "Publishing '${project}:${version}-${stability}'..."
	@vagrant ssh -c "docker push mubox/${project}:${version}-${stability}"
ifeq ($(version),$(LATEST))
	@echo "Publishing '${project}:${stability}'..."
	@vagrant ssh -c "docker tag -f mubox/${project} mubox/${project}:${stability}"
	@vagrant ssh -c "docker push mubox/${project}:${stability}"
endif
ifeq ($(stability),stable)
	@echo "Publishing '${project}:${version}'..."
	@vagrant ssh -c "docker tag -f mubox/${project} mubox/${project}:${version}"
	@vagrant ssh -c "docker push mubox/${project}:${version}"
endif
ifeq ($(version),$(LATEST))
ifeq ($(stability),stable)
	@echo "Publishing '${project}:latest'..."
	@vagrant ssh -c "docker tag -f mubox/${project} mubox/${project}:latest"
	@vagrant ssh -c "docker push mubox/${project}:latest"
endif
endif

PHONY: clean clean-project clean-runit

clean: clean-runit
	@echo "Removing all images..."
	@vagrant ssh -c "for image in \$$(docker images -q mubox/${project} | sort | uniq); do docker rmi -f \$$image; done"

clean-project:
	@echo "Removing ${project} images..."
	@vagrant ssh -c "for image in \$$(docker images -q mubox/${project} | sort | uniq); do docker rmi -f \$$image; done"

clean-runit: clean-project
	@echo "Removing runit images..."
	@vagrant ssh -c "for image in \$$(docker images -q mubox/base | sort | uniq); do docker rmi -f \$$image; done"

# make clean; for version in 9.3 9.4; do make clean-project; make build version=${version}; for stability in alpha beta stable; do make publish version=${version} stability=${stability}; done; done; make clean;
# make clean; for version in 9.3 9.4; do make clean-project; make build version=${version}; for stability in alpha; do make publish version=${version} stability=${stability}; done; done; make clean;
