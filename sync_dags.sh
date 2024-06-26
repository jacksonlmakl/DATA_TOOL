#!/bin/bash

# Define the root DAGs directory
DAGS_DIR=~/DATA_TOOL/airflow/dags

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
done

echo "Symbolic links created for all DAG files."

# Install requirements
find $DAGS_DIR -type f -name "requirements.txt" | while read -r REQ_FILE; do
    source ~/DATA_TOOL/airflow/airflow_venv/bin/activate && pip install -r "$REQ_FILE"
done
