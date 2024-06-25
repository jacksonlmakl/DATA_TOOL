echo "Name: "
read DAG_NAME

mkdir ~/DATA_TOOL/dags/${DAG_NAME}
mkdir ~/DATA_TOOL/dags/${DAG_NAME}/python
mkdir ~/DATA_TOOL/dags/${DAG_NAME}/dbt

cp -R ~/DATA_TOOL/dag_templates/dag.py ~/DATA_TOOL/dags/${DAG_NAME}/dag.py
cp -R ~/DATA_TOOL/dag_templates/requirements.txt ~/DATA_TOOL/dags/${DAG_NAME}/requirements.txt
cp -R ~/DATA_TOOL/dag_templates/configuration.yaml ~/DATA_TOOL/dags/${DAG_NAME}/configuration.yaml