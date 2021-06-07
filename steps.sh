#Variables
RESOURCE_GROUP="k8s-httpd-azure-file"
LOCATION="northeurope"
AKS_NAME="httpd-demo"

#Create resource group
az group create -n $RESOURCE_GROUP -l $LOCATION

# Create AKS cluster
az aks create -n $AKS_NAME -g $RESOURCE_GROUP --node-count 1 --generate-ssh-keys

#Get the context for the new AKS
az aks get-credentials -n $AKS_NAME -g $RESOURCE_GROUP

#Apply resources
kubectl apply -f .

#Get the configuration for Apache
docker run --rm httpd:2.4 cat /usr/local/apache2/conf/httpd.conf > httpd.conf

#Create a new config map with Apache configuration
kubectl create configmap httpdconf --from-file=httpd.conf

kubectl apply -f .
