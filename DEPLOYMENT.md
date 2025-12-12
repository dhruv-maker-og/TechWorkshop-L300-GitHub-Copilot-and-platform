# GitHub Actions Deployment Setup

This document explains how to configure GitHub secrets and variables for the automated deployment of the ZavaStorefront application to Azure App Service.

## Required GitHub Secrets

Configure these secrets in your GitHub repository under **Settings → Secrets and variables → Actions → Secrets**:

### `AZURE_CREDENTIALS`
Azure service principal credentials in JSON format:
```json
{
  "clientId": "your-service-principal-client-id",
  "clientSecret": "your-service-principal-secret",
  "subscriptionId": "your-azure-subscription-id",
  "tenantId": "your-azure-tenant-id"
}
```

**To create a service principal:**
```bash
az ad sp create-for-rbac --name "github-actions-sp" --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group-name} \
  --sdk-auth
```

## Required GitHub Variables

Configure these variables in your GitHub repository under **Settings → Secrets and variables → Actions → Variables**:

| Variable | Example Value | Description |
|----------|---------------|-------------|
| `AZURE_WEBAPP_NAME` | `zava{uniqueString}linux-webapp` | Name of your Azure App Service |
| `AZURE_CONTAINER_REGISTRY` | `zava{uniqueString}acr` | Name of your Azure Container Registry |
| `AZURE_RESOURCE_GROUP` | `rg-TechWorkshop-L300-GitHub-Copilot-and-platform-dev` | Azure Resource Group name |

## Getting Resource Values

If you've deployed the infrastructure using the Bicep templates, you can find these values using:

```bash
# List all resources in your resource group
az resource list --resource-group <your-resource-group> --output table

# Get specific resource details
az webapp list --resource-group <your-resource-group> --query "[].name" --output tsv
az acr list --resource-group <your-resource-group> --query "[].name" --output tsv
```

## Deployment Trigger

The workflow will automatically deploy when:
- Code is pushed to the `main` branch
- Manually triggered via the GitHub Actions tab

The deployment process:
1. Builds the Docker container using Azure Container Registry
2. Deploys the new container image to App Service
3. Restarts the App Service to pick up the new image

## Troubleshooting

- Ensure the service principal has **Contributor** access to the resource group
- Verify all GitHub secrets and variables are correctly configured
- Check the Azure resource names match exactly (case-sensitive)
- Review the GitHub Actions logs for specific error messages