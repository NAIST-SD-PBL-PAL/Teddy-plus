export URL=$1
docker-compose up --exit-code-from ted-client
echo "csv files and html plot are avaible at /var/docker/volumes/$(basename $(pwd))_csv_data"
