#!/bin/bash
if [ ! -n "$WERCKER_INSTALL_CONTAINER_TRANSFORM_KEY" ]; then
  error 'Please specify key property'
  exit 1
fi

if [ ! -n "$WERCKER_INSTALL_CONTAINER_TRANSFORM_SECRET" ]; then
  error 'Please specify secret property'
  exit 1
fi

if [ ! -n "$WERCKER_INSTALL_CONTAINER_TRANSFORM_REGION" ]; then
  error 'Please specify region property'
  exit 1
fi
if [ ! -n "$WERCKER_INSTALL_CONTAINER_TRANSFORM_CLUSTER" ]; then
  error 'Please specify cluster property'
  exit 1
fi

echo 'Synchronizing References in apt-get...'
sudo apt-get update

sudo pip install container-transform
sudo pip install awscli

echo 'Synchronizing System Time...'
sudo ntpdate ntp.ubuntu.com

echo 'Configuring based on parameters...'
aws configure set aws_access_key_id $WERCKER_INSTALL_CONTAINER_TRANSFORM_KEY
aws configure set aws_access_key_id $WERCKER_INSTALL_CONTAINER_TRANSFORM_SECRET
aws configure set default.region $WERCKER_INSTALL_CONTAINER_TRANSFORM_REGION

echo 'register task definition'
aws ecs register-task-definition --family wercker --container-definitions "$(cat docker-compose.yml | container-transform)"

echo ''
aws ecs run-task --cluster $WERCKER_INSTALL_CONTAINER_TRANSFORM_CLUSTER --task-definition wercker

echo 'Done.'


