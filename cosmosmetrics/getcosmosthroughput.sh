#!/bin/bash


echo "This script collects Cosmos DB MongoDB API throughput"



folderName="throughput"
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
                fileName=$accountName-$mongoDBName-$collectionName-throughput.json
                echo Collecting throughput on collection $collectionName
                az cosmosdb mongodb collection throughput show -g $resourceGroup -a $accountName -d $mongoDBName --name $collectionName > ./$folderName/$fileName
               
                echo "------------------------------------------"
            done
        done
done

echo "Metrics collection completed"