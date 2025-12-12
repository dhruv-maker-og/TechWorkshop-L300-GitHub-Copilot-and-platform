@minLength(3)
param resourcePrefix string = 'zava'
param location string = 'westus3'
param environment string = 'dev'
param acrSku string = 'Basic'
param appServicePlanSku string = 'B1'

// Generate unique suffix for resource names
var uniqueSuffix = uniqueString(resourceGroup().id)

module acr 'modules/acr.bicep' = {
  name: '${resourcePrefix}-acr'
  params: {
    resourcePrefix: '${resourcePrefix}${uniqueSuffix}'
    location: location
    sku: acrSku
  }
}

module appServicePlan 'modules/appServicePlan.bicep' = {
  name: '${resourcePrefix}-plan'
  params: {
    resourcePrefix: '${resourcePrefix}${uniqueSuffix}'
    location: location
    sku: appServicePlanSku
  }
}

module appInsights 'modules/appInsights.bicep' = {
  name: '${resourcePrefix}-ai'
  params: {
    resourcePrefix: '${resourcePrefix}${uniqueSuffix}'
    location: location
  }
}

module webApp 'modules/webApp.bicep' = {
  name: '${resourcePrefix}-webapp'
  params: {
    resourcePrefix: '${resourcePrefix}${uniqueSuffix}'
    location: location
    appServicePlanId: appServicePlan.outputs.id
    environment: environment
    appInsightsConnectionString: appInsights.outputs.connectionString
    acrLoginServer: acr.outputs.loginServer
  }
}

module roleAssignment 'modules/roleAssignment.bicep' = {
  name: '${resourcePrefix}-role'
  params: {
    principalId: webApp.outputs.principalId
    acrName: '${resourcePrefix}${uniqueSuffix}acr'
  }
}

module foundry 'modules/foundry.bicep' = {
  name: '${resourcePrefix}-foundry'
  params: {
    resourcePrefix: '${resourcePrefix}${uniqueSuffix}'
    location: location
    sku: 'Standard'
  }
}
