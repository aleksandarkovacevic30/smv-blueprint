docker image build --tag akovacev/smavoo:0.1 .
docker run --rm --name smavoo -d --publish 9091:51773 --publish 9092:52773 akovacev/smavoo:0.1
