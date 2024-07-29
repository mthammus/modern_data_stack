python3 -m venv dbt-env
source dbt-env/bin/activate
python3 -m pip install --upgrade pip
pip install dbt
mkdir dbt_project
cd dbt_project
pip install dagster-dbt
pip install dbt-dremio
dbt init <Project_Name>



dbt run --select my_model


dbt debug
dbt compile
dbt run
dbt test
dbt docs generate
dbt docs serve
dbt docs serve --port 5000



![alt text](image.png)



![alt text](image-1.png)

docker exec -it spark_container /bin/bash
