PWD=$(shell pwd)

TAG=v20
CMD=bash

PKG=pdfdetach
DEPS=poppler-utils
ARGS=-list example_041.pdf

export PKG DEPS

all:
	@make -s v:20 v:18 v:16

test-all:
	@rm -rf tmp
	@make -s test try-ruby

try-ruby:
	@rm -f Gemfile.lock
	@bundler && ruby main.rb

install:
	@./install.sh

dev: build
	@docker run -v $(PWD):/app --rm -it $(PKG) $(CMD)

v\:%:
	@make -s dev TAG=v$* CMD='bash -c "make test-all;exit"'

test: install
	@make -s test:$(shell cat /etc/issue | awk '/Ubuntu/{print $$2}' | sed 's/\..*$$//g')

test\:%:
	@LD_LIBRARY_PATH=$(PWD)/$(PKG)/bin/$*.04/lib $(PWD)/$(PKG)/bin/$*.04/$(PKG) $(ARGS)

build:
	@cat Dockerfile | sed 's/XX/$(subst v,,$(TAG))/g' | docker build -t $(PKG) --target $(TAG) -
