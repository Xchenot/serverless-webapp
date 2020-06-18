# serverless web app

This project provides a template for deploy a serverless web app

## Prerequisites

The only tools you need to build this project are :

- Docker Compose
- Makefile support (see GNU Make for windows OS)

## Install

To install the project, just clone it:

``` bash
$ git@github.com:Xchenot/serverless-webapp-template.git
```

## Dependencies


## Testing

``` bash
$ docker-compose run --rm --service-ports node sh
$ npm start
```

## Deploying

``` bash
$ docker-compose run --rm --service-ports node sh
$ npm run build
```

## Destroying


## Unlocking


## Bash History

If you want to reset your container bash history, you can use:

``` bash
$ make bash-reset
```

## GitLab

The project is automatically tested, built and deployed with GitLab. If you want to
learn more about it, you can read its [documentation](/.gitlab).
