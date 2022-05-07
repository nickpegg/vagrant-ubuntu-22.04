all: package.box

VERSION := $(shell date +%Y.%m.%d).$(shell cat build)
BOX_NAME := nickpegg/ubuntu-22.04

package.box:
	vagrant box update --box archlinux/archlinux
	vagrant up --provision

	# Overwrite the SSH private key with our own. This key will get included in
	# the .box package.
	cp ssh_key .vagrant/machines/default/virtualbox/private_key

	vagrant package

	# Update build version
	expr $(shell cat build) + 1 | tee build

publish: package.box
	vagrant cloud publish ${BOX_NAME} ${VERSION} virtualbox package.box
	vagrant cloud version release ${BOX_NAME} ${VERSION}

# Install locally
install: package.box
	vagrant box add package.box --provider virtualbox --name ${BOX_NAME} -f

# Integration test
integration: package.box
	vagrant box add package.box --provider virtualbox --name testing/${BOX_NAME} -f
	mkdir -p integration_test
	cd integration_test && \
		vagrant init testing/${BOX_NAME} && \
		vagrant up && \
		vagrant ssh -c 'echo "it works!"'
	rm -r integration_test
	vagrant box remove testing/${BOX_NAME} --box-version 0


clean:
	vagrant destroy -f
	rm -r integration_test || true
	rm package.box || true
