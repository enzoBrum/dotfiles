CACHE_DIR=/var/cache/my-oci-archive
IMAGE_FILENAME=image.tar.gz
IMAGE_PATH=${CACHE_DIR}/${IMAGE_FILENAME}

create-cache-dir:
	mkdir -p ${CACHE_DIR}
create-builder:
	docker buildx ls --format "{{ .Name }}" | grep "silverblue-builder" &> /dev/null || docker buildx create --name=silverblue-builder --driver docker-container --driver-opt image=moby/buildkit,network=host --use
build: create-builder create-cache-dir
	[ -f "${IMAGE_PATH}" ] && mv ${IMAGE_PATH} ${CACHE_DIR}/$(shell date +%s).old.${IMAGE_FILENAME} || exit 0
	docker build --builder=silverblue-builder  --output type=oci,name=test,dest=${CACHE_DIR}/${IMAGE_FILENAME} .
	sudo ./remove_old_files_from_cache.sh ${CACHE_DIR}
	docker buildx use default
rebuild: build
	rpm-ostree update
rebase: 
	rpm-ostree reset
	rpm-ostree rebase ostree-unverified-image:oci-archive:${CACHE_DIR}/$(shell ls -1 ${CACHE_DIR} | tail -n 1)

