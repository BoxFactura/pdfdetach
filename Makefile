PWD=$(shell pwd)

TAG=v20

MAJOR=0
PATCH=0

CMD=bash
TASK=install

PKG=pdfdetach
DEPS=poppler-utils
ARGS=-list example_041.pdf

export PKG DEPS

.PHONY: ? all test test-bin check try-ruby dev target release install build

all:
	@make -s v:20 v:18 v:16

test:
	@make -s all TASK=check

check:
	@rm -rf tmp
	@make -s test-bin try-ruby

try-ruby:
	@rm -f Gemfile.lock
	bundler && ruby main.rb

dev: build
	@docker run -v $(PWD):/app --rm -it $(PKG) $(CMD)

v\:%:
	@make -s version dev TAG=v$* CMD='bash -c "make $(TASK);exit"'

define RUBY_VERSION_FILE
# frozen_string_literal: true

class PDFDetach
  VERSION = '$(MAJOR).$(subst v,,$(TAG)).$(PATCH)'
  LIB_TARGET = '$(subst v,,$(TAG)).04'
end
endef

export RUBY_VERSION_FILE

define IGNORED_LIBS
bin/*
!bin/$(subst v,,$(TAG)).04
libc.so.6
libdl.so.2
libexpat.so.1
libgcc_s.so.1
liblzma.so.5
libm.so.6
libpthread.so.0
libstdc++.so.6
libuuid.so.1
libz.so.1
libzstd.so.1
endef

export IGNORED_LIBS

fetch:
	@(git fetch origin $(TAG) 2> /dev/null || (\
		git checkout --orphan $(TAG);\
		git rm -rf . > /dev/null;\
		git commit --allow-empty -m "initial commit";\
		git checkout master))

prune:
	@(git push --delete origin $(TAG) v$(MAJOR).$(subst v,,$(TAG)).$(PATCH) > /dev/null 2>&1) || true
	@(git worktree remove $(PKG) --force > /dev/null 2>&1) || true
	@(git checkout -- $(PKG) > /dev/null 2>&1) || true
	@(git branch -D $(TAG) > /dev/null 2>&1) || true

target: $(PWD)/$(PKG)/bin/$(subst v,,$(TAG)).04
	@(((git branch | grep $(TAG)) > /dev/null 2>&1) || make -s fetch) || true

release: target version
	@(mv $(PKG) .backup > /dev/null 2>&1) || true
	@(git worktree remove $(PKG) --force > /dev/null 2>&1) || true
	@(git worktree add $(PKG) $(TAG) && (cp -r .backup/* $(PKG) > /dev/null 2>&1)) || true

	@cd $(PKG) && echo "$$IGNORED_LIBS" > .gitignore && git add .
	@cd $(PKG) && git commit -m "Release v$(MAJOR).$(subst v,,$(TAG)).$(PATCH) ($(shell date))" || true
	@rm -rf .backup

	@git tag -a v$(MAJOR).$(subst v,,$(TAG)).$(PATCH) $(TAG) -m "Release v$(MAJOR).$(subst v,,$(TAG)).$(PATCH)" || true

push-relase:
	@git push origin $(TAG) || true
	@git push origin : v$(MAJOR).$(subst v,,$(TAG)).$(PATCH) || true

install:
	@./install.sh

version:
	@echo "$$RUBY_VERSION_FILE" > $(PWD)/$(PKG)/lib/$(PKG)/version.rb

test-bin:
	@make -s test:$(shell cat /etc/issue | awk '/Ubuntu/{print $$2}' | sed 's/\..*$$//g')

test\:%:
	@LD_LIBRARY_PATH=$(PWD)/$(PKG)/bin/$*.04/lib $(PWD)/$(PKG)/bin/$*.04/$(PKG) $(ARGS)

build:
	@cat Dockerfile | sed 's/XX/$(subst v,,$(TAG))/g' | docker build -t $(PKG) --target $(TAG) -
