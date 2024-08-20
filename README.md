# Coworking Space Service

## Description
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

## Table of Contents
1. [Pre-requisites](#prequisites)
2. [Building the application](#building)
3. [Running the application](#running)
4. [Deploying the application](#deploying)
5. [Troubleshooting](#troubleshooting)
6. [Suggestions](#suggestions)

## Pre-requisites <a name="prequisites"></a>

### Requirements
The following tools are required to build and deploy the project:
- [Git](https://git-scm.com/downloads)
- [Docker](https://docs.docker.com/get-started/get-docker/)
- A Docker registry for your images (e.g. AWS ECR)
- A Kubernetes cluster (if not, see [Setting up a Kubernetes cluster with Amazon EKS and eksctl](#eks))
- A running PostgreSQL database containing valid data (if not, see [Setting up a PostgreSQL database](#postgresql))
- [kubectl](https://kubernetes.io/docs/reference/kubectl/) - ensure that your `kubectl` configuration file is pointed towards your Kubernetes cluster. The default location is:
    - Linux and macOS: `~/.kube/config`
    - Windows: `%USERPROFILE%\.kube\config`

### Setting up a Kubernetes cluster with Amazon EKS and `eksctl` <a name="eks"></a>
1. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and ensure it's using the correct details: `aws configure`
2. Install [eksctl](https://eksctl.io/installation/). Make sure your IAM account has the minimum access levels stated in the installation guide.
3. Create your cluster using `eksctl`. Modify the parameters to suit your needs:
```bash
eksctl create cluster --name my-cluster --region us-east-1 --nodegroup-name my-nodes --node-type t3.small --nodes 1 --nodes-min 1 --nodes-max 2
```
A recommended starting instance type is a `t3.medium` as it is a general-purpose instance that has a good balance between resources (CPU, memory, etc.) and is relatively cheap.

4. Allow `kubectl` to access your cluster:
```bash
aws eks update-kubeconfig --name my-cluster
```

### Setting up a PostgreSQL database <a name="postgresql"></a>
1. [Clone this repository.](#cloning)
2. Install PostgresQL's command-line tool: [psql](https://www.postgresql.org/)
3. Verify the database configuration in `deployment/postgresql.yaml`. Update the details to suit your needs.
4. Once you're happy with the details, deploy the changes with Kubernetes:
```bash
kubectl apply -f deployment/dbvolume.yaml
kubectl apply -f deployment/postgresql.yaml
```
5. Set up port-forwarding to the newly created database service:
```bash
kubectl port-forward service/postgresql-service 5433:5432 &
```
6. Populate the database with tables and data:
```bash
cd db
export DB_PASSWORD=<DB_PASSWORD>
./init-db.sh 1_create_tables.sql 2_seed_users.sql 3_seed_tokens.sql
```
7. You can connect to the database to verify it's set up properly by running:
```bash
PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U <DB_USERNAME> -d <DB_NAME> -p 5433
```

## Building the application <a name="building"></a>

### Clone the repository <a name="cloning"></a>
```bash
git clone https://github.com/Dioti/cd12355-microservices-aws-kubernetes-project-starter.git
```

### Build the Docker image
```bash
docker build -t <REPOSITORY-NAME>/<IMAGE-NAME>:<TAG> -f analytics/Dockerfile .
```

### Push the Docker image
```bash
docker push <REPOSITORY-NAME>/<IMAGE-NAME>:<TAG>
```

## Running the application <a name="running"></a>

### Run the Docker image locally
Once it's been built, you can run the Docker image locally:
```bash
docker run \
  -e DB_USERNAME=<DB_USERNAME> \
  -e DB_PASSWORD=<DB_PASSWORD> \
  -e DB_HOST=<DB_HOST> \
  -e DB_PORT=<DB_PORT> \
  -e DB_NAME=<DB_NAME> \
  <REPOSITORY-NAME>/<IMAGE-NAME>:<TAG>
```

## Deploying the application <a name="deploying"></a>

### Update the deployment configuration
Update the database details in `deployment/dbconfig.yaml` and `deployment/dbsecret.yaml`. Kubernetes will read these properties when deploying your application, so make sure they are correct.

Also update your application properties in `deployment/coworking.yaml`.
- Ensure that your image has the tag (ideally this is incremented automatically).
- Configure the resources (replicas, memory, cpu) to suit your needs.

### Deploying to Kubernetes
Deploy the changes to your Kubernetes cluster:
```bash
kubectl apply -f deployment/dbconfig.yaml
kubectl apply -f deployment/dbsecret.yaml
kubectl apply -f deployment/coworking.yaml
```

## Troubleshooting <a name="troubleshooting"></a>
You can verify the application is running by looking at the Kubernetes resources:
```bash
kubectl get services
kubectl get deployments
kubectl get pods
kubectl get nodes
```

If a pod is shown in an unsuccessful state, you can get more information about it by running:
```bash
kubectl describe pod <POD-NAME>
```

To view the application logs, you can do:
```bash
kubectl logs <POD-NAME>
```

## Suggestions <a href="suggestions"></a>

### Autoscaling
Consider implementing Kubernetes Horizontal Pod Autoscaler (HPA) to help manage the deployed pods depending on the traffic. The HPA can help reduce costs by scaling down the number of pods when the application has low traffic and then scale up when the traffic increases.

### Logging
Using a logging service like AWS CloudWatch can help identify underutilized resources and reduce costs by preventing overprovisioning.