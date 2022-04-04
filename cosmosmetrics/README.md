## Get Cosmos DB metrics for Mongo API 

This script collects Cosmos DB metrics for Mongo API to help analyze resource utilization. 
This below metrics are collected. 

    ProvisionedThroughput
    MongoRequests
    TotalRequests
    TotalRequestUnits
    NormalizedRUConsumption

You can find more details on the these metrics [over here](https://docs.microsoft.com/en-us/azure/cosmos-db/monitor-cosmos-db-reference)

### Prerequisites

    azure cli - sudo apt install azure-cli
    jq - sudo apt install jq


### Execute script

Clone this repo

    git clone https://github.com/anildwarepo/utils
    cd utils/cosmosmetrics
    ./getcosmosmetrics.sh 2022-04-01T05:30:00Z 2022-04-02T07:40:00Z


The metrics are collected in folder metrics. 







