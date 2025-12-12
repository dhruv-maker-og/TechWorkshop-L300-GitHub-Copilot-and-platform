# Zava Storefront Azure Infrastructure

This folder contains modular Bicep templates for deploying the Zava Storefront web application to Azure using containerized deployment with managed identity authentication.

## Architecture

### Azure Resources Deployed:
- **Azure Container Registry (ACR)** - Container image storage with managed identity access
- **Linux App Service Plan** - Hosting platform for containerized applications  
- **Linux Web App (App Service)** - Main application host configured for containers
- **Application Insights** - Application monitoring and observability
- **System-assigned Managed Identity** - Secure authentication without passwords
- **RBAC Role Assignment** - AcrPull permissions for seamless container deployment
- **Microsoft Foundry** - AI model access for GPT-4 and Phi models *(optional)*

## Key Features ✅

### ✅ **Container-First Deployment**
- No local Docker installation required
- Cloud-based container builds using `az acr build`
- Managed identity authentication to ACR (no passwords/secrets)
- Automatic container deployment and restart capabilities

### ✅ **Infrastructure as Code**
- Modular Bicep template structure in `/modules`
- Parameterized resource names, regions, and SKUs
- Unique naming with collision prevention
- Azure Developer CLI (azd) integration

### ✅ **Security & Best Practices**
- System-assigned managed identity for Web App
- AcrPull role assignment for secure container access
- HTTPS-only configuration
- No hardcoded credentials or API keys

### ✅ **Monitoring & Observability**
- Application Insights integration with connection strings
- Structured logging and telemetry collection
- Azure Portal monitoring dashboards

### ✅ **CI/CD Ready**
- GitHub Actions workflow for automated deployments
- Cloud-based builds eliminate local dependencies  
- Automated container versioning and deployment

## Quick Start

### Prerequisites
- Azure CLI installed and authenticated (`az login`)
- Azure Developer CLI installed (`azd`)
- Azure subscription with contributor access

### 1. Deploy Infrastructure
```bash
# Clone and navigate to project
git clone <repository-url>
cd TechWorkshop-L300-GitHub-Copilot-and-platform

# Deploy all Azure resources
azd provision
```

### 2. Build and Deploy Application
```bash
# Build container image in ACR (cloud build - no local Docker needed)
az acr build --registry <YOUR_ACR_NAME> \
  --image zavastorefront:latest \
  --file Dockerfile .

# Deploy container to Web App  
az webapp config container set \
  --name <YOUR_WEBAPP_NAME> \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --docker-custom-image-name <YOUR_ACR_NAME>.azurecr.io/zavastorefront:latest

# Restart application
az webapp restart --name <YOUR_WEBAPP_NAME> --resource-group <YOUR_RESOURCE_GROUP>
```

### 3. Access Your Application
- Web App URL: `https://<YOUR_WEBAPP_NAME>.azurewebsites.net`
- Azure Portal: Monitor resources and view logs
- Application Insights: Performance and usage analytics

## GitHub Actions CI/CD

### Required Secrets & Variables
Set these in your GitHub repository settings:

**Secrets:**
- `AZURE_CREDENTIALS` - Azure service principal JSON for authentication

**Variables:**
- `AZURE_CONTAINER_REGISTRY_NAME` - Your ACR name
- `AZURE_APP_SERVICE_NAME` - Your Web App name  
- `AZURE_RESOURCE_GROUP_NAME` - Your resource group name

### Workflow Features
- **Trigger:** Push to `main` branch or pull requests
- **Cloud Build:** Uses `az acr build` for container creation
- **Zero Dependencies:** No local Docker or build tools required
- **Secure Deployment:** Managed identity handles all authentication
- **Automatic Restart:** Ensures latest container is running

## Project Structure

```
infra/
├── main.bicep                 # Main orchestration template
├── main.parameters.json       # Configuration parameters
├── README.md                 # This documentation
└── modules/
    ├── acr.bicep            # Azure Container Registry
    ├── appServicePlan.bicep # Linux App Service Plan
    ├── webApp.bicep         # Container-enabled Web App
    ├── appInsights.bicep    # Application monitoring
    ├── roleAssignment.bicep # ACR access permissions
    └── foundry.bicep        # Microsoft Foundry (AI models)

.github/
└── workflows/
    └── deploy.yml           # CI/CD automation

src/                         # .NET 8 application source
Dockerfile                   # Container definition  
.dockerignore               # Build optimization
azure.yaml                  # Azure Developer CLI config
```

## Cost Optimization

All resources use minimal SKUs appropriate for development:
- **ACR:** Basic tier
- **App Service Plan:** B1 (Basic)
- **Application Insights:** Standard telemetry
- **Microsoft Foundry:** Standard tier *(if enabled)*

**Estimated Monthly Cost:** ~$15-30 USD for development workloads

## Troubleshooting

### Common Issues

1. **ACR Name Conflicts**
   - Solution: Resource names include unique suffix automatically

2. **Container Pull Failures** 
   - Check: Managed identity has AcrPull role assignment
   - Verify: Container image exists in ACR

3. **Microsoft Foundry Deployment**
   - Region: Ensure westus3 supports Foundry services
   - Subscription: Verify Foundry provider is registered

### Verification Commands
```bash
# Check role assignments
az role assignment list --assignee <WEBAPP_PRINCIPAL_ID>

# Verify container configuration  
az webapp config show --name <WEBAPP_NAME> --resource-group <RG_NAME>

# View application logs
az webapp log tail --name <WEBAPP_NAME> --resource-group <RG_NAME>
```

## Next Steps

1. **Enable Microsoft Foundry** - Uncomment module in `main.bicep` if AI features needed
2. **Configure Custom Domains** - Add SSL certificates and custom domain names
3. **Set up Staging Slots** - Enable blue-green deployments
4. **Scale Configuration** - Adjust SKUs for production workloads
5. **Security Hardening** - Add Key Vault integration and network restrictions

---

**Status:** ✅ All core requirements implemented and deployed successfully  
**Last Updated:** December 12, 2025  
**Deployment Method:** Azure Developer CLI (azd) + GitHub Actions
