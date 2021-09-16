# Host Bindle Server in Azure. 

The [ARM Template](azuredeploy.json) deploys a [bindle server](https://github.com/deislabs/bindle) to Azure using ACI as a host.

The bindle server is front-ended with a caddy web server acting as a reverse proxy which automatically obtains and updates an SSL certificate from Let's Encrypt or Zero SSL.

Steps to deploy:
 1. Obtain an Azure subscription (sign up for free at [Azure](https://azure.microsoft.com/en-us/free/))
 1. In your browser, navigate to the [Azure CloudShell](https://shell.azure.com/).
 1. Enter the following commands: 

```

az group create -n bindle-server -l westeurope

```