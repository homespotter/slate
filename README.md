<p align="center"><em>This project was created with Slate. Check it out at <a href="https://slatedocs.github.io/slate">slatedocs.github.io/slate</a>.</em></p>

Getting started
=========================

This readme assumes that you have `docker` installed, as well as the `make` tool.


Making changes
=========================
Run the following command to have a live version of the documentation running at https://localhost:4567

    make up

If you are making changes to more than just the `source/**` folder contents (most changes are just changes to `source/index.html.md`, but an example of a change that warrants this further testing would be something like a change to `Dockerfile`) , then you should also test by running:

    make build-prod
    make prod

Running `make prod` instead of `make up` will listen on port 80 instead of 4567, and it will use exactly the same docker image that would be deployed if you pushed it.

Deploying
=========================

To make changes and see them deployed to https://docs.homespotter.com you'll need to take the following steps:

* Make your desired changes
* Open a PR with your proposed changes
* Get the PR approved and merged into the `main` branch
* On a clean checkout of the `main` branch, run `make build-prod`
* (If you haven't done so recently) run `make aws-login`
* Run `make push-prod`
* Run the Rundeck job to deploy the latest docker image (which you just pushed) to the docs server

