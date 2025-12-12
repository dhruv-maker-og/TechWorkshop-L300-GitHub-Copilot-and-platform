@minLength(3)
param resourcePrefix string
param location string
param sku string

// Ensure ACR name is at least 5 characters
var acrName = length(resourcePrefix) < 3 ? '${resourcePrefix}storeacr' : '${resourcePrefix}acr'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: false
  }
}

output loginServer string = acr.properties.loginServer
output id string = acr.id
