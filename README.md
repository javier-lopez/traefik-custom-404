About
-----

[Traefik](https://www.vagrantup.com/) is a modern HTTP reverse proxy and load balancer made to deploy microservices with ease. It supports several backends (Docker, Swarm mode, Kubernetes, Marathon, Consul, Etcd, Rancher, Amazon ECS, and a lot more) to manage its configuration automatically and dynamically. This repository builds a custom traefik docker image with custom 404/502 message errors.

Usage
-----

    $ ./create-docker-image.sh v1.5.4
    $ echo '127.0.0.1 whoami.docker.localhost' | sudo tee -a /etc/hosts
    $ echo '127.0.0.1 404.docker.localhost'    | sudo tee -a /etc/hosts
    $ docker-compose -f traefik.yml rm -f && docker-compose -f traefik.yml up
    $ docker-compose -f whoami.yml  rm -f && docker-compose -f whoami.yml
    $ curl whoami.docker.localhost #shows whoami backend service output
    $ curl 404.docker.localhost #shows the 404 custom error message

Dependencies
------------

- [docker](https://docker.com)
- [docker-compose](https://docs.docker.com/compose/)
