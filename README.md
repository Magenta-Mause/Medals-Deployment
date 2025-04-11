# Medals-Deployment

This project contains the configuration for the deployment of _MEDALS_.
Medals is tool to help trainers administer the progress for the [_Deutsche Sportabzeichen_](https://deutsches-sportabzeichen.de/) of their athletes.

It allows trainers to create and invite their athletes to the platform, track their scores, see which _Sportabzeichen_ they would earn, administer their athletes with different trainers together, check wether the _Schwimmnachweis_ is present or not and lets the athletes see their own progress.

## Setup

### Backup

To create a backup of the database you need to execute the `dbBackup.sh` script inside the `postgres_db` container.
To do that execute the following command: `docker compose exec postgres_db bash ./scripts/dbBackup.sh`

### Logs

The `./scripts` directory additionally contains the scripts `log_purge_before.sh` and `log_purge_current.sh`. These scripts can be used to
remove docker logs, ensuring compliance with any privacy regulations applying to you as an administrator:

#### `log_purge_before.sh`

This script purges all logs from a docker container before a specified timestamp. You can run it as follows:
```bash
./log_purge_before.sh [container_id] [timestamp]
```

The timestamp is in the format `YYYY-MM-DDTHH:MM:SS.nsZ` (e.g. `2025-04-11T10:03:56.605310101Z`). Please note that this script requires
the permissions to read and delete log files in the `/var/lib/docker/containers` directory.

The `[container_id]` needs to be the **full** container hash.

#### `log_purge_current.sh`

This script, similarly to `log_purge_before.sh`, purges log messages for compliance. It is a little shortcut to purge the current logfile
of a container which makes it suitable for use in a cronjob:
```bash
./log_purge_current.sh [container_id]
```

#### `log_purge_deployment.sh`

This script eases getting the container ids by automatically detecting
all containers running in the project `medals-deployment`, and purging
their logs.

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
