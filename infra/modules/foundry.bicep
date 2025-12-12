// Azure OpenAI Service (alternative to Microsoft Foundry)
param resourcePrefix string
param location string
param sku string

resource openAI 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: '${resourcePrefix}openai'
  location: location
  kind: 'OpenAI'
  sku: {
    name: sku == 'Standard' ? 'S0' : 'S0'
  }
  properties: {
    customSubDomainName: '${resourcePrefix}openai'
  }
}

output endpoint string = openAI.properties.endpoint
output id string = openAI.id
