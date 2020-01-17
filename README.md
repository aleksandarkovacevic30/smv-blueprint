# SMV Blueprint

## Requirements

- Docker

## How to Install

buildAndRun.sh

- This script will build a docker image 
  + based on InterSystems IRIS Data Platform Community Edition,
  + install codes necessary for this blueprint to work
  + make automaric configurations
  + instantiate image as docker container
  
Once the container is active, you will be able to open:

- [The Management Portal](http://localhost:9092/csp/sys/%25CSP.Portal.Home.zen?$NAMESPACE=SMAVOO)
- [Integration Portal](http://localhost:9092/csp/smavoo/EnsPortal.ProductionConfig.zen?$NAMESPACE=SMAVOO&$NAMESPACE=SMAVOO)

Input rest api for sensors would be:
  - http://localhost:9092/smavoo/api/device/status

It then saves the received messages, filters duplicates (based on sensor id and cycle not older than 1 day) and forwards it to further to hub.
