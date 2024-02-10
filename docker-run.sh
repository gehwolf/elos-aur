#!/bin/bash -eu

CMD_DIR=$(realpath $(dirname $0))
BASE_DIR=${CMD_DIR%%/ci}

docker build \
	-t elos-aur \
	-f ${BASE_DIR}/Dockerfile \
	--ulimit nofile=1024:52428  \
	${BASE_DIR}


docker run -ti --rm elos-aur
