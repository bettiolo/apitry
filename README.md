oauth-console
=============

## Pre-requisites
- VirtualBox: https://www.virtualbox.org
- Packer: http://www.packer.io
- Vagrant: http://www.vagrantup.com

## Development Environment
- `vagrant-create-update-box.sh` Creates a base Vagrant box using the Packer tool.
- `vagrant-start.sh` Creates a new disposable database environment. It deploys the application, takes you in via SSH ready to run then your tests or experiments. When you are finished, it destroys the environment.

## Deployment
- `azure-deploy.sh` Blue/green deploy to a brand new cloud instance.

## Goals
- Local development environment (build + unit, integration, acceptance and smoke tests)
- Local virtual non-persistent system test instance (build + unit, integration, acceptance and smoke tests)
- Cloud deployed non-persistent user acceptance test instances (build + unit, integration, acceptance and smoke tests)
- Cloud deployed non-persistent production instances (build + smoke tests)

## Stretch Goal
- Completely tested infrastructure
