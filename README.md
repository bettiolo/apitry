oauth-console [![Build Status](https://travis-ci.org/bettiolo/oauth-console.svg?branch=master)](https://travis-ci.org/bettiolo/oauth-console)
=============

## Pre-requisites
- VirtualBox: http://www.virtualbox.org
- Packer: http://www.packer.io
- Vagrant: http://www.vagrantup.com

### Pre-requisites installation
- `install-pre-requisites-ubuntu64.sh` Automatic install for Ubuntu 12.10 64bit

## Development Environment
- `vagrant-create-update-box.sh` Creates a base Vagrant ArchLinux box using Packer.
- `vagrant-start.sh` Creates a new disposable database environment. It deploys the application, takes you in via SSH ready to run then your tests or experiments. When you are finished, it destroys the environment.

## Deployment
- `azure-deploy.sh` Blue/green deploy to a brand new cloud instance.

## Development Workflow
*Development environment:* Development is done on the local machine. Unit tests are continuously executed via `grunt watch` task. Integration, Acceptance and Smoke test executed on demand. The source code is pushed to `master` branch.

*Integration environment:* A virtual, disposable, non-persistent instance that is automatically created and destroyed via Vagrant. The source code is checked out from the `master` branch. Tests are run via the `grunt test` command. Unit, Integration, Acceptance and Smoke tests are executed.

*Staging environment:* Cloud based, disposable, non-persistent instances that are continuously deployed to Windows Azure with the same script as Production. The source code is checked out from the `release` branch. Tests are automatically run via the `grunt test` command on deploy. Unit, Integration, Acceptance and Smoke tests are executed. Each time a new release gets deployed, a new instance is created and the old destroyed as in Blue/Green deployment.

*Staging environment:* Cloud based, disposable, non-persistent instances that are continuously deployed to Windows Azure with the same script as Staging. The source code is checked out from the latest tag. Tests are automatically run via the `grunt test` command on deploy. Only Smoke tests are executed. Each time a new release gets deployed, a new instance is created and the old destroyed as in Blue/Green deployment.
