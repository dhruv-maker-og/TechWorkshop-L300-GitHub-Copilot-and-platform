param resourcePrefix string
param location string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${resourcePrefix}appinsights'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output id string = appInsights.id
output connectionString string = appInsights.properties.ConnectionString
output instrumentationKey string = appInsights.properties.InstrumentationKey
