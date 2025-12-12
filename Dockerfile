FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY src/ZavaStorefront.csproj src/
RUN dotnet restore "src/ZavaStorefront.csproj"
COPY . .
WORKDIR "/src/src"
RUN dotnet build "ZavaStorefront.csproj" -c Release -o /app/build
RUN dotnet publish "ZavaStorefront.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "ZavaStorefront.dll"]