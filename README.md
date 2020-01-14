# InterSystems IRIS Machine Learning Experience 2019

In this example, we want to show one way how InterSystems IRIS can facilitate Machine Learning Projects. What we focus in this example is how can we operationalize the machine learning projects into existing business processes.

## Requirements

- Docker


## How to Install

- To build an image: `docker image build --tag akovacev/iris-ml-exp:2019.03.3 .`
- To run a container: `docker run --name irisSummitTest -d --publish 9091:51773 --publish 9092:52773 akovacev/iris-ml-exp:2019.03.3`

