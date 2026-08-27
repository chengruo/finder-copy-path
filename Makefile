SHELL := /bin/zsh

.PHONY: install uninstall test

install:
	./scripts/install.sh

uninstall:
	./scripts/uninstall.sh

test:
	./tests/test.sh
