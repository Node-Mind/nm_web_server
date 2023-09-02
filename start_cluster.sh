#!/bin/bash

kubectl_proxy_pid=$(ps aux | grep 'kubectl proxy' | grep -v grep | awk '{print $2}')

if [ -n "$kubectl_proxy_pid" ]; then
  echo "Killing kubectl proxy process with PID $kubectl_proxy_pid"
  kill -9 "$kubectl_proxy_pid"
else
  echo "No kubectl proxy process found."
fi

IMAGE_NAME="nm/nm_web_server"
IMAGE_TAG="latest"

if docker image inspect "$IMAGE_NAME:$IMAGE_TAG" >/dev/null 2>&1; then
  echo "Docker image $IMAGE_NAME:$IMAGE_TAG already exists."
else
  echo "Building Docker image $IMAGE_NAME:$IMAGE_TAG"
  docker build -t "$IMAGE_NAME:$IMAGE_TAG" -f build/Dockerfile.alpine.prod .
fi

NAMESPACE="nm"

if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
  echo "Kubernetes namespace $NAMESPACE already exists."
else
  echo "Creating Kubernetes namespace $NAMESPACE"
  kubectl create namespace "$NAMESPACE"
fi

# Check if the secret 'regcred' exists, and create it if necessary.
SECRET_NAME="regcred"
if ! kubectl get secret "$SECRET_NAME" --namespace="$NAMESPACE" >/dev/null 2>&1; then
  echo "Creating Docker secret $SECRET_NAME in namespace $NAMESPACE"
  kubectl create secret docker-registry "$SECRET_NAME" \
    --docker-server='localhost:5005' \
    --docker-username='admin' \
    --docker-password='admin' \
    --namespace="$NAMESPACE"
else
  echo "Docker secret $SECRET_NAME already exists in namespace $NAMESPACE."
fi

# Tag and push the Docker image
docker tag "$IMAGE_NAME:$IMAGE_TAG" "localhost:5005/$IMAGE_NAME:$IMAGE_TAG"
docker push "localhost:5005/$IMAGE_NAME:$IMAGE_TAG"

# Apply Kubernetes resources
kubectl apply -f k8s/nm_web_server.namespace.yaml
kubectl apply -f k8s/nm_web_server.deployment.yaml
kubectl apply -f k8s/nm_web_server.service.yaml
kubectl apply -f k8s/nm_web_server.load_balancer.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f k8s/nm.account.yaml
kubectl apply -f k8s/nm.role_binding.yaml

# Create a token for the admin user
kubectl -n kubernetes-dashboard create token admin-user

# Display the list of services
kubectl get svc

# Start kubectl proxy
kubectl proxy &

echo "http://127.0.0.1:80/"


# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
# http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

# ps aux | grep kubectl
# kill -9 PID

# docker login localhost:5005 -u admin -p admin

# kubectl create secret docker-registry regcred --docker-server='localhost:5005' --docker-username='admin' --docker-password='admin' -n nm