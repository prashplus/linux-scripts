# Rancher

Rancher is an open source software platform that enables organizations to run and manage Docker and Kubernetes in production. With Rancher, organizations no longer have to build a container services platform from scratch using a distinct set of open source technologies. Rancher supplies the entire software stack needed to manage containers in production.

Rancher software consists of four major components:

## INFRASTRUCTURE ORCHESTRATION

Rancher takes in raw computing resources from any public or private cloud in the form of Linux hosts. Each Linux host can be a virtual machine or physical machine. Rancher does not expect more from each host than CPU, memory, local disk storage, and network connectivity. From Rancher’s perspective, a VM instance from a cloud provider and a bare metal server hosted at a colo facility are indistinguishable.

Rancher implements a portable layer of infrastructure services designed specifically to power containerized applications. Rancher infrastructure services include networking, storage, load balancer, DNS, and security. Rancher infrastructure services are typically deployed as containers themselves, so that the same Rancher infrastructure service can run on any Linux hosts from any cloud.

## CONTAINER ORCHESTRATION AND SCHEDULING

Many users choose to run containerized applications using a container orchestration and scheduling framework. Rancher includes a distribution of all popular container orchestration and scheduling frameworks today, including Docker Swarm, Kubernetes, and Mesos. The same user can create multiple Swarm or Kubernetes clusters. They can then use the native Swarm or Kubernetes tools to manage their applications.

In addition to Swarm, Kubernetes, and Mesos, Rancher supports its own container orchestration and scheduling framework called Cattle. Cattle is used extensively by Rancher to orchestrate infrastructure services as well as setting up, managing, and upgrading Swarm, Kubernetes, and Mesos clusters.


![alt text](https://rancher.com/docs/img/rancher/rancher_overview_2.png)


## Quick Setup

Step 1: Install the Docker on the host where you want deploy rancher server.

```bash
$ sudo bash rancherdockersetup17.03.sh
```

or

```bash
$ sudo curl -sS https://get.docker.com | sh
```


Step 2: Run the Rancher server as a Docker container
```
$ sudo docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:stable
```

Step 3: After few minutes, open the Rancher Server GUI at [Server IP]:8080 or localhost:8080

Now you can browse the GUI for the further things like setting up the ENV or more.


## Authors

* **Prashant Piprotar** - - [Prash+](https://github.com/prashplus)
and visit my blog for more Tech Stuff
### http://www.prashplus.com
