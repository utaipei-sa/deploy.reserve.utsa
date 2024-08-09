#!/bin/bash -ex

CMD=${1}

IMG_NAME=app-template
DOCKER_COMPOSE_NAMESPACE=$IMG_NAME

if [ "$CMD" == "SERVICE_UP" -a "$#" == "3" ]; then
    BUILD_BACKEND_VERSION=${2}
    BUILD_FRONTEND_VERSION=${3}
    docker-compose -f docker/docker-compose-db.yaml up -d
    echo "Run SERVICE_UP(BUILD_BACKEND_VERSION=$BUILD_BACKEND_VERSION, BUILD_FRONTEND_VERSION=$BUILD_FRONTEND_VERSION)"
    export BACKEND_VERSION=$BUILD_BACKEND_VERSION 
    export FRONTEND_VERSION=$BUILD_FRONTEND_VERSION
    docker-compose -f docker/docker-compose-api.yaml up -d
    docker-compose -f docker/docker-compose-ui.yaml up -d
    docker-compose -f docker/docker-compose-nginx.yaml up -d

elif [ "$CMD" == "UPDATE_IMAGE" -a "$#" == "3" ]; then
    BUILD_BACKEND_VERSION=${2}
    BUILD_FRONTEND_VERSION=${3}
    echo "Run UPDATE_IMAGE(BUILD_BACKEND_VERSION=$BUILD_BACKEND_VERSION, BUILD_FRONTEND_VERSION=$BUILD_FRONTEND_VERSION)"
    export BACKEND_VERSION=$BUILD_BACKEND_VERSION 
    export FRONTEND_VERSION=$BUILD_FRONTEND_VERSION
    docker-compose -f docker/docker-compose-api.yaml up -d
    docker-compose -f docker/docker-compose-ui.yaml up -d
    echo "restart nginx"
    docker restart nginx
    echo "delete old images"
    docker image prune -a -f

    # update image, deleate images, run docker-compose file

else
    echo "Invalid command"
    exit 1
fi
