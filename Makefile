all: ssh

ssh: ~/.ssh/config

~/.ssh/config: ssh/config
	ssh/generate
