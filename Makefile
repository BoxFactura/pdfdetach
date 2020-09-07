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
	bundler && ruby main.rb

dev: build
	@docker run -v $(PWD):/app --rm -it $(PKG) $(CMD)

v\:%:
	@make -s dev TAG=v$* CMD='bash -c "make test-all;exit"'

release:
	@./release.sh

define RUBY_VERSION_FILE
class PDFDetach
$(shell cat $(PWD)/$(PKG)/lib/$(PKG)/version.rb | grep VERSION)
  LIB_TARGET = '$(subst v,,$(TAG)).04'
end
endef

export RUBY_VERSION_FILE

install:
	@echo "$$RUBY_VERSION_FILE" > $(PWD)/$(PKG)/lib/$(PKG)/version.rb
	@(((ls $(PWD)/$(PKG)/bin | grep .) > /dev/null 2>&1) || ./install.sh) || true

test: install
	@make -s test:$(shell cat /etc/issue | awk '/Ubuntu/{print $$2}' | sed 's/\..*$$//g')

test\:%:
	@LD_LIBRARY_PATH=$(PWD)/$(PKG)/bin/$*.04/lib $(PWD)/$(PKG)/bin/$*.04/$(PKG) $(ARGS)

build:
	@cat Dockerfile | sed 's/XX/$(subst v,,$(TAG))/g' | docker build -t $(PKG) --target $(TAG) -
