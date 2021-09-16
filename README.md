# Host Bindle Server in Azure. 

The [ARM Template](azuredeploy.json) deploys a [bindle server](https://github.com/deislabs/bindle) to Azure using ACI as a host.

The bindle server is front-ended with a caddy web server acting as a reverse proxy which automatically obtains and updates an SSL certificate from Let's Encrypt or Zero SSL.

Once deployed the resource group with contain a container instance named bindle-server-resource which runs the bindle server. It will also contain a storage account that contains 2 file shares which are used to store the certificates/keys and bindle server data.

## Deploy from the Azure Portal:

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsimongdavies%2Fbindle-server-docker%2Fmain%2Fazuredeploy.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fsimongdavies%2Fbindle-server-docker%2Fmain%2FcreateUIDefinition.json)

## Deploy using Cloud Shell

 1. Obtain an Azure subscription (sign up for free at [Azure](https://azure.microsoft.com/en-us/free/))
 1. In your browser, navigate to the [Azure CloudShell](https://shell.azure.com/).
 1. Enter the following commands: 

``` console
az group create -n bindle-server -l westeurope
az deployment group create -g bindle-server --template-uri https://raw.githubusercontent.com/simongdavies/bindle-server-docker/main/azuredeploy.json  -p bindleServerUserName=bindleuser -p bindleServerPassword=secret -o json --query 'properties.outputs.bindleUrl.Value'
```

Once the deployment sucessfully completes you should see the output similar to the following:
```
export BINDLE_URL=https://f394485d2e0a5f45b9508fcfb0566278.westeurope.azurecontainer.io/v1
```

## Testing the deployment

```console
# Set the environment variables BINDLE_URL, BINDLE_USERNAME and BINDLE_PASSWORD with values from the deployment.
bindle search
=== Showing results 1 to 0 of 0 (limit: 50)
```