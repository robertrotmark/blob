#!/bin/bash

#This is required for Azure devops to work with AZ cli
az extension add --name azure-devops


#Change this value to true if you want to run this script locally.
runlocal=false
if [ $runlocal == "true" ] 
then
  #Variables for local use of script.
  createServiceconnectionKubernetes=false;
  createServiceconnectionARM=false;
  namespace="testnamespace"
  project="testproject"
else
  #Saving namespace to a variable
  namespace=$(namespace)
  project=$(project)
fi

#Check so that we have work to do.
if [ $(createServiceconnectionARM) != "true" ] || [ $(createServiceconnectionKubernetes) != "true" ]
then
   echo No service endpoint will be created.
   exit 0;
fi

#Creating names for the both service connections
kscname="${namespace}-kubernetes"
ascname="${namespace}-arm"

#Exporting the Personal Access Token
export AZURE_DEVOPS_EXT_PAT=$(az_devops_PAT)
export AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY=$(az_devops_PAT)

#Login into Devops
echo $AZURE_DEVOPS_EXT_PAT | az devops login --organization "https://changeme.visualstudio.com/" 


if [ $(createServiceconnectionKubernetes) == "true" ]
then   

#Show what namespace we are working with
echo "Creating a serviceconnection towards Namespace: ${namespace}, using Project: ${project}"

#Verify that the namespace exist and that it's ready.
nsexist=$(kubectl get ns ${namespace} --template={{.status.phase}} )
if [ "$nsexist" != "Active" ]
then
    echo "Namespace does not exist or is not active."
    exit 1;
fi

#Setup Service connection for a namespace
#Get Serviceaccount
sa="$(kubectl get sa -n $namespace -o=go-template --template='{{(index .items 0).metadata.name}}')"
#echo "Serviceaccount: ${sa}"

#Get token
satoken=$(kubectl get serviceaccounts ${sa} -o=go-template -n ${namespace} --template='{{(index .secrets 0).name}}')
#echo "Serviceaccounttoken: ${satoken}"

#Get secret
secret="$(kubectl get secrets $satoken -n $namespace -o=go-template --template='{{ .data }}')"
#echo "Secret: ${secret}"

#Get fqdn used for creating service connection
fqdn=$(kubectl config view --minify -o=go-template --template='{{(index .clusters 0).cluster.server }}')
#echo "FQDN: ${fqdn}"

#Kubernetes Service connection template
kubetemplate=$(System.DefaultWorkingDirectory)/_ProjectBoostrap/kubernetes.json

#Replacing template values
sed -i "s/{ApiToken}/${satoken}/g" "$kubetemplate" <<< "$kubetemplate"
sed -i "s/{serviceAccountCertificate}/${secret}/g" "$kubetemplate" <<< "$kubetemplate"
sed -i "s/{ServiceconnectionName}/${kscname}/g" "$kubetemplate" <<< "$kubetemplate"
sed -i "s,{fqdn},${fqdn},g" "$kubetemplate" <<< "$kubetemplate"

echo Creating Service Endpoint for Kubernetes
az devops service-endpoint create --project "Devops" --service-endpoint-configuration "$kubetemplate"
echo Successfull created Service Endpoint
else
  echo "Will not create Kubernetes service endpoint."
fi


if [ $(createServiceconnectionARM) == "true" ]
then
echo Creating ARM Service Connection
armname=${namespace}-ARM

accountSettings=$(az account show --query '{Name:name,TenantId:tenantId,AccountId:id}')
subname=$(echo $accountSettings | jq '.Name')
tenantid=$(echo $accountSettings | jq '.TenantId')
accountId=$(echo $accountSettings | jq '.AccountId')

echo Name: ${subname}, TenantId: ${tenantid}, AccountId: ${accountId}

az devops service-endpoint azurerm create \
--name "${armname}" \
--azure-rm-tenant-id "${tenantid:1:-1}" \
--azure-rm-service-principal-id ${armname:1:-1} \
--azure-rm-subscription-id ${accountId:1:-1} \
--azure-rm-subscription-name "${subname}" \
--project $project
echo "ARM Service Endpoint created successfully.

else
  echo "Will not create ARM service endpoint."
fi
