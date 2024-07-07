mkdir data_stack
cd data_stack
# clone Airbyte from GitHub
git clone --depth=1 https://github.com/airbytehq/airbyte.git
# switch into Airbyte directory
cd airbyte
# start Airbyte
nohup ./run-ab-platform.sh > airbyte.log 2>&1 &

cd ..

docker compose up -d postgres mongodb minio minio-setup dremio spark

#Set up Superset
docker run -d -p 8080:8088 -e "SUPERSET_SECRET_KEY=cHnqm6yfvmwZtJLr4rhkkZQoDKP+Rr+ScSPkXWJBbFYmBVpEeod+njXoRjZbu+801tg=" --name superset apache/superset
docker exec -it superset superset fab create-admin \
              --username mthammu \
              --firstname Manoj \
              --lastname Thammu \
              --email mthammu@terces.io \
              --password SecretDataStack5623#
docker exec -it superset superset db upgrade
docker exec -it superset superset load_examples
docker exec -it superset superset init

