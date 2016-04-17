#!/bin/bash

echo "DOCKER_OPTS=\"${DOCKER_BUILDER_OPTS}\"" >> /etc/default/docker

# Start the docker daemon
/etc/init.d/docker start

sleep 6s

# Pull latest base images (purely for cache, naming does not matter, just hashes)
docker pull ${DOCKER_REG_PREFIX}/gitlab:latest

# cd and cont.
cd /builder/docker-gitlab-core
if [ "${DOCKER_BASE_IMG}" != "" ] ; then
  sed -i "s;.*FROM .*;FROM ${DOCKER_BASE_IMG};" ./Dockerfile
fi
docker build --no-cache=true -t dd/gitlab-base:latest .

cd ../
sed -i "s;.*FROM .*;FROM dd/gitlab-base:latest;" ./Dockerfile
#sed -i "s; trusty ; utopic ;" ./Dockerfile

echo -e "ENV BUILD_DETAILS ${GIT_COMMIT}_${BUILD_NUMBER}" >> ./Dockerfile
echo -e "BUILD_DETAILS:\n  GIT_COMMIT: ${GIT_COMMIT}\n  BUILD_NUMBER: ${BUILD_NUMBER}\n" > ./BUILD_DETAILS
echo -e "ADD ./BUILD_DETAILS /etc/BUILD_DETAILS" >> ./Dockerfile

#cat ./assets/setup/install.sh
cat ./Dockerfile

# Build the new app server
docker build --no-cache=true -t dd/gitlab:latest . 

LATEST_IMG=`docker images | grep "dd/gitlab" | grep "latest" | awk '{print $3}'`

if [ "${LATEST_IMG}" != "" ] ; then
  docker tag dd/gitlab:latest ${DOCKER_REG_PREFIX}/gitlab:${GIT_COMMIT}_${BUILD_NUMBER}
  docker tag -f dd/gitlab:latest ${DOCKER_REG_PREFIX}/gitlab:latest
  docker push ${DOCKER_REG_PREFIX}/gitlab:${GIT_COMMIT}_${BUILD_NUMBER}
  docker push ${DOCKER_REG_PREFIX}/gitlab:latest
fi
