.PHONY: all
all: ssh

.PHONY: ssh
ssh: ~/.ssh/config

~/.ssh/config: ssh/config
	ssh/generate

.PHONY: install
install:
	./install -v

.PHONY: update
update:
	./install -v -u
