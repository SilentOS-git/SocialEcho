# Variables
RESOURCE_GROUP="SocialEcho"
LOCATION="centralindia"
VNET_NAME="SocialEchoVNet"
SUBNET_NAME="SocialEchoSubnet"
NSG_NAME="SocialEchoNSG"
AKS_CLUSTER_NAME="SocialEchoAKSCluster"
NODE_COUNT=3
PUBLIC_IP_PREFIX_NAME="SocialEchoPublicIpPrefix"

# Get Subscription ID (optional)
SUBSCRIPTION_ID=$(az account show --query "id" -o tsv)

az group create --name $RESOURCE_GROUP --location $LOCATION

az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefixes 10.0.0.0/16 \
    --subnet-name $SUBNET_NAME \
    --subnet-prefixes 10.0.1.0/24



az aks create \
  --resource-group $RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --node-count $NODE_COUNT \
  --network-plugin azure \
  --vnet-subnet-id $(az network vnet subnet show --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --name $SUBNET_NAME --query "id" -o tsv) \
  --enable-managed-identity \
  --enable-node-public-ip \
  --generate-ssh-keys
