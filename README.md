<p align="center">
    <a href="https://stratssync.com">
        <picture>
            <img src="https://raw.githubusercontent.com/Magenta-Mause/Medals-Frontend/refs/heads/main/public/logo.svg" alt="Medals" width="300" />
        </picture>
    </a>
</p>

<p align="center">Train smarter. Track better. Win medals.</p>

<p align="center">
  <a href="https://opensource.org/licenses/BSD-3-Clause">
    <img src="https://img.shields.io/badge/License-BSD_3--Clause-blue.svg" alt="License of medals" />
  </a>
  <img src="https://github.com/Magenta-Mause/Medals-Deployment/actions/workflows/deploy.yml/badge.svg">
  <a href="https://stratssync.com">
    <img src="https://img.shields.io/website?url=https://stratssync.com" alt="Website Status" />
  </a>
</p>

<p align="center">
    <b>Medals-Deployment</b> - the deployment for <a href="https://stratssync.com">Medals</a>.
</p>

This project contains all files needed to deploy the official version of Medals as well as everything needed to deploy it locally yourself or on your own server.

## Table of contents

- [What is Medals](#Medals)
- [Local Deployment](#local-deployment)
- [Custom Deployment](#custom-deployment)
  - [Frontend Image](#frontend-image)
  - [deploy.env](#deployenv)
  - [Configuration](#configuration)
- [Architecture](#architecture)
- [CICD](#cicd)

## Medals

Medals is an application to administer athletes for the [Deutsche Sportabzeichen](https://deutsches-sportabzeichen.de/).
Trainers can administer their athletes, track the performances for different disciplines, add/remove swimming
certificates, see wether the athlete is eligible to receive a
[Deutsche Sportabzeichen](https://deutsches-sportabzeichen.de/). Athletes can see their own performances, wether
they have a valid swimming
certificate and if they are eligible for a [Deutsche Sportabzeichen](https://deutsches-sportabzeichen.de/), if not
what they need to do to be eligible.

## Local Deployment

To deploy a version of Medals locally you need to have docker installed and execute:

```
curl -o installation.sh https://raw.githubusercontent.com/Magenta-Mause/Medals-Deployment/refs/heads/main/installation.sh

bash installation.sh
```

The script will clone this repository, ask you for some information, create a deploy.env file for and start the docker compose.
On startup the Medals-Backend will send a mail to the registered admin asking them to create a password for their account. 
After the setup has finished you can see the medals-frontend under `http://localhost:1024` (the port can be customized in the `compose-local.yaml`)

## Custom Deployment

This section contains all information needed to configure everything needed to make your own deployment of medals.

### Frontend Image

The frontend has to know the url of your backend. Information on how to create your custom frontend image is in the [Medals-Frontend](https://github.com/Magenta-Mause/Medals-Frontend) documentation.

You need to change the image used from the `frontend` container in the `compose.yaml` file to the image created by you.

### deploy.env

You will need to create a `deploy.env` file. See the following reference for help:

    POSTGRES_USER                         The user of the Postgres Database
    POSTGRES_PASSWORD                     The password to the Postgres Database.
                                          Can only consist of lower case letters and numbers
    POSTGRES_DB                           The name of the Postgres Database
    JWS_SECRET                            The JWT Secret. Can only consist of lower case letters
                                          and numbers. You can generate the secret using the
                                          following website: https://jwtsecret.com/generate
    EMAIL_ENDPOINT                        This endpoint will be used to send email for Medals
    EMAIL_AUTHOR                          This is the author of all medals sent by Medals
    APP_ADMIN_ADMINS_0_EMAIL              Enter your email address here
    APP_ADMIN_ADMINS_0_FIRST              Enter the first name of your admin account here
    APP_ADMIN_ADMINS_0_LAST               Enter the last name of your admin account here

### Configuration

---

The repository contains different scripts you can use to add more functionality to your Medals deployment.

#### Backup

---

To create a backup of the database you need to execute the `dbBackup.sh` script inside the `postgres_db` container.
To do that execute the following command: `docker compose exec postgres_db bash ./scripts/dbBackup.sh`

#### Logs

---

The `./scripts` directory additionally contains the scripts `log_purge_before.sh` and `log_purge_current.sh`. These scripts can be used to
remove docker logs, ensuring compliance with any privacy regulations applying to you as an administrator:

##### `log_purge_before.sh`

This script purges all logs from a docker container before a specified timestamp. You can run it as follows:

```bash
./log_purge_before.sh [container_id] [timestamp]
```

The timestamp is in the format `YYYY-MM-DDTHH:MM:SS.nsZ` (e.g. `2025-04-11T10:03:56.605310101Z`). Please note that this script requires
the permissions to read and delete log files in the `/var/lib/docker/containers` directory.

The `[container_id]` needs to be the **full** container hash.

##### `log_purge_current.sh`

This script, similarly to `log_purge_before.sh`, purges log messages for compliance. It is a little shortcut to purge the current logfile
of a container which makes it suitable for use in a cronjob:

```bash
./log_purge_current.sh [container_id]
```

##### `log_purge_deployment.sh`

This script eases getting the container ids by automatically detecting
all containers running in the project `medals-deployment`, and purging
their logs.

## Architecture

[![Medals Architecture](README_images/Medals-Architecture.png)](https://stratssync.com/)

## CICD

[![Medals Architecture](README_images/CICD%20Chart.png)](https://stratssync.com/)
