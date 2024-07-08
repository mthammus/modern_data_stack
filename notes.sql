python3 -m venv dbt-env
source dbt-env/bin/activate
pip install dbt
mkdir dbt_project
cd dbt_project
pip install dagster-dbt
pip install dbt-dremio
dbt init <Project_Name>



dbt debug
dbt compile
dbt run
dbt test
dbt docs generate
dbt docs serve

