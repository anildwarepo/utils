#!/bin/bash


echo "This script collects Cosmos DB MongoDB API metrics from Azure monitor"

if [ $# -eq 0 ]; then
    echo "Please provide startTime and endTime as arguments. For e.g ./getcosmosmetrics.sh  2022-04-01T05:30:00Z 2022-04-02T07:40:00Z"
    exit 1
fi



startTime=$1 #"2022-04-01T05:30:00Z"
endTime=$2 #"2022-04-02T07:40:00Z"

echo Metrics will be collected from $startTime and $endTime
folderName="metrics"
mkdir -p $folderName
az cosmosdb list --query "[?kind=='MongoDB'].{id:id, name:name, resourceGroup: resourceGroup}"  | jq -c '.[]' | while read i; do
        id=$(echo $i | jq -c -r '.id')
        resourceGroup=$(echo $i | jq -c -r '.resourceGroup')
        accountName=$(echo $i | jq -c -r '.name')
        az cosmosdb mongodb database list -g $resourceGroup -a $accountName --query "[].{id:id, dbname:name, resourceGroup: resourceGroup}"  | jq -c  '.[]' | while read d; do
            mongoDBName=$(echo $d | jq -c -r '.dbname')
            az cosmosdb mongodb collection list -g $resourceGroup -a $accountName --database-name $mongoDBName --query "[].{id:id, collname:name, resourceGroup: resourceGroup}" | jq -c '.[]' | while read c; do
                collectionName=$(echo $c | jq -c -r '.collname')
                QUOTE="'"
                fileName=$accountName-$mongoDBName-$collectionName.txt
                metricName=ProvisionedThroughput
                metricAggretation=Maximum
                echo Collecting $metricName-$metricAggretation on collection $collectionName
                az monitor metrics list --resource $id --metric $metricName --aggregation $metricAggretation --interval 5m \
                --filter "CollectionName eq $QUOTE$collectionName$QUOTE" --start-time $startTime --end-time $endTime -o table > ./$folderName/$metricName-$metricAggretation-$fileName
                
                
                metricName=ProvisionedThroughput
                metricAggretation=Average
                echo Collecting $metricName-$metricAggretation on collection $collectionName
                az monitor metrics list --resource $id --metric $metricName --aggregation $metricAggretation --interval 5m \
                --filter "CollectionName eq $QUOTE$collectionName$QUOTE" --start-time $startTime --end-time $endTime -o table > ./$folderName/$metricName-$metricAggretation-$fileName

                metricName=MongoRequests
                metricAggretation=Average
                echo Collecting $metricName-$metricAggretation on collection $collectionName
                az monitor metrics list --resource $id --metric $metricName --aggregation $metricAggretation \
                --filter "CollectionName eq $QUOTE$collectionName$QUOTE" --start-time $startTime --end-time $endTime -o table > ./$folderName/$metricName-$metricAggretation-$fileName
                
                metricName=MongoRequests
                metricAggretation=Count
                echo Collecting $metricName-$metricAggretation on collection $collectionName
                az monitor metrics list --resource $id --metric $metricName --aggregation $metricAggretation \
                --filter "CollectionName eq $QUOTE$collectionName$QUOTE" --start-time $startTime --end-time $endTime -o table > ./$folderName/$metricName-$metricAggretation-$fileName

                metricName=TotalRequests
                metricAggretation=Average
                echo Collecting $metricName-$metricAggretation on collection $collectionName
                az monitor metrics list --resource $id --metric $metricName --aggregation $metricAggretation \
                --filter "CollectionName eq $QUOTE$collectionName$QUOTE" --start-time $startTime --end-time $endTime -o table > ./$folderName/$metricName-$metricAggretation-$fileName
               
                metricName=TotalRequests
                metricAggretation=Count
                echo Collecting $metricName-$metricAggretation on collection $collectionName
                az monitor metrics list --resource $id --metric $metricName --aggregation $metricAggretation \
                --filter "CollectionName eq $QUOTE$collectionName$QUOTE" --start-time $startTime --end-time $endTime -o table > ./$folderName/$metricName-$metricAggretation-$fileName
                              
                metricName=TotalRequestUnits
                metricAggretation=Count
                echo Collecting $metricName-$metricAggretation on collection $collectionName
                az monitor metrics list --resource $id --metric $metricName --aggregation $metricAggretation \
                --filter "CollectionName eq $QUOTE$collectionName$QUOTE" --start-time $startTime --end-time $endTime -o table > ./$folderName/$metricName-$metricAggretation-$fileName

                metricName=NormalizedRUConsumption
                metricAggretation=Average
                echo Collecting $metricName-$metricAggretation on collection $collectionName
                az monitor metrics list --resource $id --metric $metricName --aggregation $metricAggretation \
                --filter "CollectionName eq $QUOTE$collectionName$QUOTE" --start-time $startTime --end-time $endTime -o table > ./$folderName/$metricName-$metricAggretation-$fileName

            done
        done
done

echo "Metrics collection completed"