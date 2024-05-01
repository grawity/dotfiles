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

.PHONY: pwsh
pwsh: PowerShell.ps1
PowerShell.ps1: ~/Dropbox/.System/Config/PowerShell/Profile.ps1
	cp -u $< $@
