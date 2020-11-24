<h1 align="center">
  <a href="https://www.ndi.org/"><img src="https://www.ndi.org/sites/all/themes/ndi/images/NDI_logo_svg.svg" alt="NDI Logo" width="200"></a>
</h1>

1. [Introduction](#introduction)
1. [Components](#components)
1. [Required Setup](#required-setup)
1. [Usage](#usage)
1. [Authors](#authors)

## Introduction

This is a bash build script for rebuilding an Apollo instance, designed for use with CodeDeploy to deploy an updated version of the Apollo application. Given this intended use-case the script is not designed for deploying a fresh copy of Apollo, which requires a number of simple one-time installation and setup steps that it would be inefficient to repeatedly run for every update. Note that the script requires a certain [installation standard](#required-setup), such as a specific file path that the application is installed at; however, the script can be easily modified for different configurations as needed. The script has two components: the .yml config file, appspec.yml, and the two bash script files, prebuild.sh and buildapollo.sh.


## Components

### appspec.yml

The appspec.yml file is a short configuration file that provides the information specifying the OS it will be deployed on, where to deploy the code, and which scripts to run in what order. Note that CodeDeploy will only work successfully if it is located in the top most directory. See below in the Usage section for more details on the deployment.

### prebuild.sh and buildapollo.sh

The prebuild.sh and buildapollo.sh files are the two scripts for deploying Apollo. The prebuild.sh file runs before deployment, stopping the application and then copying the settings.ini file up a directory so that it is not overwritten on deployment. The buildapollo.sh file copies back the settings file and deploys the application. In order to completely ensure that the docker containers are rebuilt from the new version of the code and not from the existing images, the script removes all existing docker images. All application data in the database is kept in Docker volumes which are not touched, so no data is lost and the application will redeploy with all of the same data it had previously.

## Required Setup

As mentioned above, for these scripts to work there should already be an instance of Apollo on the server. By default the appspec.yml file requires the server to be running linux as the OS, though this can be modified. The Apollo application should be installed in `/home/ubuntu/apollo`. The server should be running the [aws codedeploy agent](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-cli.html) and have a IAM role assigned to it that has S3 read privileges. The server should also have CodeDeploy application's deployment group tag applied to it. The server must also be running at the time of the deployment in order for the deployment to succeed, as otherwise the deployment will fail and no changes will occur.

## Usage

These scripts are intended for use with CodeDeploy as part of a CodePipeline instance. The first step of the pipeline should be a Source stage that pulls code both from this repository and the Apollo repository. The next stage should be a CodeBuild stage that takes the code from this repository and moves it into the directory of the code from the Apollo repository, and then deletes the empty directory leaving all of the code in one single directory. As mentioned above, the CodeDeploy stage will only succeed if the appspec.yml file is located at the top most level, so the CodeBuild stage should pull the contents of this directory and pass them along to the final stage of the pipeline, CodeDeploy, which will then deploy the code to a server. If all parts of the required setup are complete, the Apollo site should go down for approximately 3-5 minutes and then reappear with the updated code

## Authors
* Ben Lynch
