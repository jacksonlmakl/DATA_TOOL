#!/bin/bash

# Function to display an error message and exit
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Update and install dependencies
echo "Updating package list..."
sudo apt-get update || error_exit "Failed to update package list"
echo "Installing dependencies..."
sudo apt-get install -y python3 python3-venv python3-pip libpq-dev || error_exit "Failed to install dependencies"

# Create a virtual environment
echo "Creating a virtual environment..."
python3 -m venv airflow_venv || error_exit "Failed to create a virtual environment"

# Activate the virtual environment
source airflow_venv/bin/activate || error_exit "Failed to activate the virtual environment"

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip || error_exit "Failed to upgrade pip"
pip install apache-airflow>=2.7.0
# Install Apache Airflow
echo "Installing Apache Airflow..."
export AIRFLOW_VERSION=2.9.0
export PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
export CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}" || error_exit "Failed to install Apache Airflow"

# Initialize the Airflow database
echo "Initializing the Airflow database..."
airflow db init || error_exit "Failed to initialize the Airflow database"

# Create an Airflow user
echo "Creating an Airflow user..."
airflow users create --username admin --password admin --firstname Admin --lastname User --role Admin --email admin@example.com || error_exit "Failed to create an Airflow user"

# Setup Airflow home and environment variables
echo "Setting up Airflow environment variables..."
export AIRFLOW_HOME=~/DATA_TOOL/airflow
mkdir -p $AIRFLOW_HOME

# Create a basic Airflow configuration file
echo "Creating Airflow configuration file..."
cat <<EOF > $AIRFLOW_HOME/airflow.cfg
[core]
dags_folder = ~/DATA_TOOL/dags
base_log_folder = $AIRFLOW_HOME/logs
executor = SequentialExecutor
sql_alchemy_conn = sqlite:///$AIRFLOW_HOME/airflow.db
[webserver]
web_server_port = 8080
expose_config = True
EOF

echo "Airflow setup completed successfully!"

# Instructions for the user
echo "To start the Airflow web server, run the following commands:"
echo "source airflow_venv/bin/activate"
echo "airflow webserver --port 8080"

echo "To start the Airflow scheduler, run the following command in a new terminal:"
echo "source airflow_venv/bin/activate"
echo "airflow scheduler"
mkdir ~/DATA_TOOL/dags
mkdir $AIRFLOW_HOME/logs
