Slate: 

Forked from: https://github.com/slatedocs/slate

Documentation hosted at docs.homespotter.com used for 3rd party customers
integrating with Boost.

Development
====
To run locally:

```bash
make up
```

Deployment
====
First, build and push the production docker image with:

```bash
make build-prod push-prod
```

Then deploy with the following Rundeck job:
https://rundeck.homespotter.com/project/WebArchitecture/job/show/5c97aee9-05fd-4f49-97c6-071ec6d86cb5

To test the prod build, you can run it locally:

```bash
make prod
```

Then access the site at http://localhost:8080



