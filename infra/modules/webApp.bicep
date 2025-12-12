param resourcePrefix string
param location string
param appServicePlanId string
param environment string
param appInsightsConnectionString string
param acrLoginServer string

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: '${resourcePrefix}linux-webapp'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrLoginServer}/zavastorefront:latest'
      acrUseManagedIdentityCreds: true
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: environment
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${acrLoginServer}'
        }
      ]
    }
  }
}

output id string = webApp.id
output principalId string = webApp.identity.principalId
