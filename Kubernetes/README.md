# Getting Started With Kubernetes (K8s)

Kubernetes is an open source system for managing containerized applications across multiple hosts, providing basic mechanisms for deployment, maintenance, and scaling of applications. The open source project is hosted by the Cloud Native Computing Foundation (CNCF).

With modern web services, users expect applications to be available 24/7, and developers expect to deploy new versions of those applications several times a day. Containerization helps package software to serve these goals, enabling applications to be released and updated in an easy and fast way without downtime. Kubernetes helps you make sure those containerized applications run where and when you want, and helps them find the resources and tools they need to work. Kubernetes is a production-ready, open source platform designed with Google's accumulated experience in container orchestration, combined with best-of-breed ideas from the community.

## Quick Setup

For the quick setup of the Kubernetes cluster to go with the Rancher.
You can know more about Rancher at : https://github.com/prashplus/linux-scripts/tree/master/Rancher

Setup the Rancher as per the above link and follow the steps given below:
Note: Don't add nodes before you are told to do so...

Step 1: Go to Environment > Manage Environment Tab

Add new Environment and select Kubernetes as the Orchestrator.
And Switch to the new Environment

Step 2: Go to Infrastructure > Hosts Tab

You will find a command to start an Rancher Agent container, copy it somewhere. You will need to execute it in the hosts that you want to add as the Kubernetes nodes.

Step 3: SSH or login to the host that you want to add

* Install the Docker (using the same script).

* Run the command that you copied earlier.

* Wait for few minutes and visit the Rancher Server, you will find the button to visit the Kubernetes Dashboard.

Step 4: Run your first command at CLI

```bash
kubectl get all
```

### Things to remember

* Always go for the Kubernetes CLI (kubectl).
* Use the Kubernetes GUI for the resource monitoring purpose only.
* Sometime, it would be difficult to remove node from the cluster.


## Kubernetes Tutorial

For learning Kubernetes you can find best tutorials on its official website.
Link : https://kubernetes.io/docs/tutorials/kubernetes-basics/

## Running your first containers

You've run one of the getting started guides and you have successfully turned up a Kubernetes cluster. Now what? This guide will help you get oriented to Kubernetes and running your first containers on the cluster.

### Running a container

From this point onwards, it is assumed that kubectl is on your path from one of the getting started guides.

The kubectl run line below will create two nginx pods listening on port 80. It will also create a deployment named my-nginx to ensure that there are always two pods running.

```
> kubectl run my-nginx --image=nginx --replicas=2 --port=80
```

Once the pods are created, you can list them to see what is up and running:

```
> kubectl get pods
```

You can also see the deployment that was created:

```
> kubectl get deployment
```

### Exposing your pods to the internet

On some platforms (for example Google Compute Engine) the kubectl command can integrate with your cloud provider to add a public IP address for the pods, to do this run:

```
> kubectl expose deployment my-nginx --port=80 --type=LoadBalancer
```

This should print the service that has been created, and map an external IP address to the service. Where to find this external IP address will depend on the environment you run in. For instance, for Google Compute Engine the external IP address is listed as part of the newly created service and can be retrieved by running

```
> kubectl get services
```

In order to access your nginx landing page, you also have to make sure that traffic from external IPs is allowed. Do this by opening a firewall to allow traffic on port 80.


### Cleanup

Delete the deployment using :

```
> kubectl delete deployment my-nginx
```

## More Examples

You can find more examples of yaml scripts in the Example directory.

## Authors

* **Prashant Piprotar** - - [Prash+](https://github.com/prashplus)

Visit my blog for more Tech Stuff

### http://www.prashplus.com
