param resourcePrefix string
param location string
param sku string

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${resourcePrefix}linux-plan'
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: sku
    tier: 'Basic'
  }
}

output id string = plan.id
