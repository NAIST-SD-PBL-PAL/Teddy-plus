export URL=$1 INTERVAL=$2
docker rm $(docker ps -a -q)
docker-compose up --exit-code-from ted-client"
