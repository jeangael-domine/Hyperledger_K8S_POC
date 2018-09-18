#!/bin/bash

kubectl delete deployment cli-org1-deployment
kubectl delete deployment ca-deployment
kubectl delete deployment orderer-deployment
kubectl delete deployment peer0-org1-deployment
kubectl delete deployment peer1-org1-deployment
kubectl delete deployment peer0-org2-deployment
kubectl delete deployment peer1-org2-deployment

kubectl delete service ca-node-port
kubectl delete service orderer-node-port
kubectl delete service peer0-org1-node-port
kubectl delete service peer1-org1-node-port
kubectl delete service peer0-org2
kubectl delete service peer1-org2

kubectl delete pvc couchdb-peer0-org1-volume-claim
kubectl delete pvc couchdb-peer1-org1-volume-claim
kubectl delete pvc couchdb-peer0-org2-volume-claim
kubectl delete pvc couchdb-peer1-org2-volume-claim

printf "Deployments\n"
kubectl get deployments
sleep 5
printf "\n\n"
printf "Pods\n"
kubectl get pods
printf "\n\n"
printf "Services\n"
kubectl get services
printf "\n\n"
printf "Persistent volumes\n"
kubectl get pv
printf "\n\n"
printf "Persistent volume claims\n"
kubectl get pvc