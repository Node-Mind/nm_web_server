#!/bin/bash

IMAGE_NAME="nm/nm_web_server"

if ! docker image inspect $IMAGE_NAME >/dev/null 2>&1; then
    docker build -t $IMAGE_NAME -f build/Dockerfile.alpine.prod .
fi

docker tag nm/nm_web_server localhost:5005/nm/nm_web_server
docker push localhost:5005/nm/nm_web_server

kubectl create -f k8s/nm_web_server.namespace.yaml

kubectl apply -f k8s/nm_web_server.deployment.yaml
kubectl apply -f k8s/nm_web_server.service.yaml
kubectl apply -f k8s/nm_web_server.load_balancer.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f k8s/nm.account.yaml
kubectl apply -f k8s/nm.role_binding.yaml

kubectl -n kubernetes-dashboard create token admin-user

kubectl get svc -owide

kubectl get deployments -n nm
kubectl get pods -n nm
kubectl get services -n nm

kubectl proxy &
# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
# http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

# ps aux | grep kubectl
# kill -9 PID
