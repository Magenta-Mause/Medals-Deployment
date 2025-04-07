# Medals-Deployment

This project contains the configuration for the deployment of _MEDALS_.
Medals is tool to help trainers administer the progress for the [_Deutsche Sportabzeichen_](https://deutsches-sportabzeichen.de/) of their athletes.

It allows trainers to create and invite their athletes to the platform, track their scores, see which _Sportabzeichen_ they would earn, administer their athletes with different trainers together, check wether the _Schwimmnachweis_ is present or not and lets the athletes see their own progress.

## Setup

### Backup

To create a backup of the database you can execute the `dbBackup.sh` script.
To use it you need to install `pg_dump`.

#### Installation of `pg_dump`

- `sudo apt update`
- `sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'`
- `curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg`
- `sudo apt update`
- `sudo apt install postgresql-17`

#### Usage

`bash dbBackup.sh {path to your deploy.env} {path to the directory where the backups should be stored}`

## Infrastructure

The [Medals-Frontend](https://github.com/magenta-Mause/Medals-Frontend/) and [Medals-Backend](https://github.com/magenta-Mause/Medals-Backend/) generate an docker image on every commit to main
or if the publish-image workflow is manually executed. The image is published to docker hub under the
ecofreshkaese namespace -> ecofreshkaese/medals-frontend and ecofreshkaese/medals-backend respectively.

The frontend image uses a nginx-base-image to serve the frontend. A base nginx config file is provided but gets overwritten for the final
deployment. While building the image multiple environment variables can be set to e.g. configure the backend base url.

The backend image uses a java-base-image and runs the spring boot application.

The images are orchestrated with docker-compose.

An Open Telekom Cloud (OTC) server is used for the deployment.

## Deployment

On the OTC server two systemd services are used to deploy the application. The medals-deployment.service gets started on each server start, pulls the newest backend and frontend images and executed the deployment docker-compose file.

When the publish workflow gets executed on the backend and frontend projects, after the images are published to the ecofreshkaese namespace, the medals-deployment.service gets restarted via ssh in the workflow to automatically deploy the services.

The second systemd service is the medals-get-deployment.service that pulls the newest changes from the main branch of this project in the deployment dir and restarts the docker-compose. Commits to the main branch of this project restart this service to deploy the newest changes.

The application internally runs on port 1024, which gets exposed to port 80 (https) and 443 (https) via an extra nginx deployment that enables https support for the application with the help of certbot.
