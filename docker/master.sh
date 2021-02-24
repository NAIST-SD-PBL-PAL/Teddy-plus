export URL=$1 INTERVAL=$2
docker rm $(docker ps -a -q)
docker-compose up --exit-code-from ted-client
echo "csv files and html plot are avaible at /var/lib/docker/volumes/$(basename $(pwd))_csv_data"
