Concourse Demo
==============

Prerequisites
-------------

* Docker engine
* Docker Compose


Spin up local Concourse with Docker Compose
-------------------------------------------

```bash
docker compose up -d
```

Afterwards open [http://localhost:8080](http://localhost:8080) and login with user `test` and password `test`.

**Caution** do not use this setup in production, since we are using non-secret ssh keys which are checked-in to this repository.


1st Tutorial: Download `fly`cli and login to Concourse
------------------------------------------------------

Download `fly` CLI with

```bash
export concourse_fqdn=localhost
curl --noproxy ${concourse_fqdn} -s -f -o /usr/local/bin/fly "http://${concourse_fqdn}:8080/api/v1/cli?arch=amd64&platform=darwin"
chmod u+x /usr/local/bin/fly
```

Login to Concourse via

```bash
fly --target=demo login \
    --concourse-url="http://${concourse_fqdn}:8080" \
    --username=test \
    --password=test \
    --team-name=main
```

this will generate a fly target `demo` that you have to reference in your further fly operations, e.g.

```bash
fly -t demo pipelines
```

> Normally `/usr/local/bin` would be a good place to download the fly cli locally. Since we are working with multiple Concourse versions in parallel, we put the corresponding fly binary into the root of the project folder and reference this one from within all our scripts in the project. An alternative would be the usage of the [`fly sync`](https://concourse-ci.org/fly.html#fly-sync) command.


2nd Tutorial: Upload your first Pipeline
----------------------------------------

Our first pipeline contains only a single job with a single task that outputs "Hello World":

```yaml
---
jobs:
  - name: hello-world
    plan:
      - task: hello-world
        config:
          platform: linux
          image_resource:
            type: docker-image
            source: {repository: busybox}
          run:
            path: echo
            args:
              - hello world
```

we use `fly`'s `set-pipeline` command to upload the pipeline to Concourse:

```bash
cd tutorial-2
fly --target=demo set-pipeline \
    --non-interactive \
    --pipeline=tutorial-2 \
    --config=pipeline.yml
```

afterwards we *unpause* the pipeline via

```bash
fly --target=demo unpause-pipeline -p tutorial-2
```

Now go to the Concourse UI in your browser again and after login, you will see a first pipeline. You can directly access it via [http://localhost:8080/teams/main/pipelines/tutorial-2](http://localhost:8080/teams/main/pipelines/tutorial-2)


3rd Tutorial: Create a Pipeline with an Input
---------------------------------------------

We will know create a pipeline that uses the content of a git repository as an input for a task. For simplicity, we will use this repository and run a simple shell script within it.

Here's our pipeline:

```yaml
 
```


4th Tutorial: Re-use of Tasks
-----------------------------

TODO show how to use tasks from an external repository


5th Tutorial: Use Variables and Settings
----------------------------------------


6th Tutorial: Use Credentials from Vault
----------------------------------------

