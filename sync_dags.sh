#!/bin/bash

# Define the root DAGs directory
DAGS_DIR=~/DATA_TOOL/dags

# Find all dag.py files in the subdirectories
find $DAGS_DIR -type f -name "dag.py" | while read -r DAG_FILE; do
    # Get the directory name and create a symbolic link in the root DAGs directory
    DAG_NAME=$(basename "$(dirname "$DAG_FILE")")
    LINK_NAME="$DAGS_DIR/$DAG_NAME.py"
    if [ -L "$LINK_NAME" ]; then
        # If the link already exists, remove it
        rm "$LINK_NAME"
    fi
    ln -s "$DAG_FILE" "$LINK_NAME"

    echo "Symbolic links created for all DAG files."
    cp -R ~/DATA_TOOL/dags/${DAG_NAME}/configuration.yaml ~/DATA_TOOL/dags/${DAG_NAME}_configuration.yaml
    sudo apt-get update
    sudo apt-get install -y build-essential cmake libre2-dev
    source ~/DATA_TOOL/airflow_venv/bin/activate && pip install -r ~/DATA_TOOL/dags/${DAG_NAME}/requirements.txt
    done