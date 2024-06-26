import yaml
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.bash_operator import BashOperator

name_ = '*<PLACEHOLDER_NAME_HERE>&'


# Load configuration from YAML file
with open(f"{name_}_configuration.yaml", "r") as file:
    config = yaml.safe_load(file)

# Parse configuration
frequency = config['frequency']
print("LOOK",(config['start_date_year'], config['start_month_year'], config['start_day_year']))
start_date = datetime(config['start_date_year'], config['start_month_year'], config['start_day_year'])
retries = config['retries']
retry_delay = timedelta(minutes=(config['retry_delay']))
schedule_interval = config['schedule_interval']

dbt_project = config['dbt_project']
python_scripts = config['python_scripts']
requirements_file = config['requirements_file']
code_env_name = config['name']
dag_name = config['name']

# Create Airflow DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': start_date,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': retries,
    'retry_delay': retry_delay,
}

dag = DAG(
    dag_name,
    default_args=default_args,
    description='A dynamically generated DAG from YAML configuration',
    schedule_interval=schedule_interval,
)

# # Task to create virtual environment
# create_env_cmd = f"python3 -m venv {name_} && source ~/DATA_TOOL/dags/{name_}/{name_}/bin/activate && pip install -r {requirements_file}"
# create_env = BashOperator(
#     task_id='create_virtualenv',
#     bash_command=create_env_cmd,
#     dag=dag,
# )

# Task to run dbt project
# run_dbt_cmd = f"cd {dbt_project} && dbt run"
run_dbt_cmd = f"cd "

run_dbt = BashOperator(
    task_id='run_dbt',
    bash_command=run_dbt_cmd,
    dag=dag,
)

if len(python_scripts)>0:
    # Dynamically create Python tasks
    prev_task = run_dbt
    for i, script in enumerate(python_scripts):
        python_task = BashOperator(
            task_id=f'run_python_script_{i+1}',
            bash_command=f"source ~/DATA_TOOL/airflow_venv/bin/activate && python ~/DATA_TOOL/dags/{name_}/python/{script}",
            dag=dag,
        )
        prev_task >> python_task
        prev_task = python_task

    # Set task dependencies
    run_dbt >> python_task
else:
    run_dbt


