CARGO_PATH=$(shell echo "$$HOME")/.cargo

build:
	podman build --squash-all --layers --volume ${CARGO_PATH}:/build/.cargo --tag localhost/my-fedora-toolbox --security-opt label=disable .
