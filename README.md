### Running GL
Here are the running params.

```
sudo docker run --name=gitlab -d --env-file /opt/docker_conf/gitlab/env.conf -v /opt/gitlab/data:/home/git/data -p xxx.xxx.xxx.xxx:22:22 -p 127.0.0.1:8080:80 registry/gitlab:latest
```
