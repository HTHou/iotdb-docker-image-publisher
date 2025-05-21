name: docker publish 1.3

on:
  # allow manually run the action:
  workflow_dispatch:


jobs:

  build:
    runs-on: ubuntu-latest

    steps:
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      
      - name: Make package
        run: | 
          git clone https://github.com/apache/iotdb.git
          cd iotdb
          cat docker/src/main/Dockerfile-1.0.0-datanode
          cd docker/src/main
          mkdir target
          cd target
          wget https://dlcdn.apache.org/iotdb/1.3.4-1/apache-iotdb-1.3.4-1-all-bin.zip
          wget https://dlcdn.apache.org/iotdb/1.3.4-1/apache-iotdb-1.3.4-1-confignode-bin.zip
          wget https://dlcdn.apache.org/iotdb/1.3.4-1/apache-iotdb-1.3.4-1-datanode-bin.zip
          cd ../DockerCompose
          sed -i 's/ docker run --rm --privileged tonistiigi/# docker run --rm --privileged tonistiigi/' do-docker-build.sh
          sed -i 's/--platform=$TARGETPLATFORM//g' do-docker-build.sh
          ./do-docker-build.sh -t confignode -v 1.3.4-1 -p
          ./do-docker-build.sh -t datanode -v 1.3.4-1 -p
          ./do-docker-build.sh -t standalone -v 1.3.4-1 -p
