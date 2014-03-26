oauth-console [![Build Status](https://travis-ci.org/bettiolo/oauth-console.svg?branch=master)](https://travis-ci.org/bettiolo/oauth-console)
=============

## How to contribute?

Contributing is easy! Just set-up your machine with the pre-requisites and then follow the steps to set-up the development environment.

### Pre-requisites

- [Git](http://git-scm.com)
- [NodeJs](http://nodejs.org)
- [Npm](https://www.npmjs.org)

#### Pre-requisites installation

(coming soon)

### Setting up the Development enviornment

First of all you need to fork the main repository, then:

```bash
git clone https://github.com/{YOUR_USERNAME}/oauth-console.git
cd src
npm install
npm test
```

All the tests should be green and you can start hacking. 

When you are happy with your changes, please run the tests on the disposable Integration environment.

## How to deploy and test the Integration environment?

### Pre-requisites

- [VirtualBox](http://www.virtualbox.org)
- [Packer](http://www.packer.io)
- [Vagrant](http://www.vagrantup.com)

#### Pre-requisites installation

- [install-pre-requisites-ubuntu64.sh](install-pre-requisites-ubuntu64.sh) Automatic install for Ubuntu 12.10 64bit

If there is no automatic script for your configuration, please ensure you have all the pre-requisites installed.

### Running the tests in the Integration environment

- [vagrant-create-update-box.sh](vagrant-create-update-box.sh) Creates a base Vagrant ArchLinux box using Packer. Run this only once or if you need to update the vagrant golden box.
- [vagrant-start.sh](vagrant-start.sh) Creates a new disposable, non-persistent environment. It deploys the application, takes you in via SSH ready to run then your tests or experiments. When you are finished, it destroys the environment.

# How to deploy and test the Staging environment?

(Not ready yet!)

# How to deploy and test the Production environment?

## Deployment

- [azure-deploy.sh](azure-deploy.sh) Automatically deploys to a brand new non-persistent, disposable cloud instance following the Blue/Green deployment paradigm.

# Development Workflow 

(Not quite ready yet!)

**Development environment:** Development is done on the local machine. Unit tests are continuously executed via `grunt watch` task. Integration, Acceptance and Smoke test executed on demand. The source code is pushed to the `master` branch.

**Integration environment:** A virtual, disposable, non-persistent instance that is automatically created and destroyed via Vagrant. The source code is checked out from the `master` branch. Tests are run via the `grunt test` command. Unit, Integration, Acceptance and Smoke tests are executed.

**Staging environment:** Cloud based, disposable, non-persistent instances that are continuously deployed to Windows Azure with the same script as Production. The source code is checked out from the `release` branch. Tests are automatically run via the `grunt test` command on deploy. Unit, Integration, Acceptance and Smoke tests are executed. Each time a new release gets deployed, a new instance is created and the old destroyed as in Blue/Green deployment.

**Staging environment:** Cloud based, disposable, non-persistent instances that are continuously deployed to Windows Azure with the same script as Staging. The source code is checked out from the latest tag. Tests are automatically run via the `grunt test` command on deploy. Only Smoke tests are executed. Each time a new release gets deployed, a new instance is created and the old destroyed as in Blue/Green deployment.
