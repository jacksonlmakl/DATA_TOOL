#!/bin/bash

# Kill the Airflow webserver process
echo "Stopping Airflow webserver..."
pkill -f "airflow webserver"

# Kill the Airflow scheduler process
echo "Stopping Airflow scheduler..."
pkill -f "airflow scheduler"

echo "Airflow webserver and scheduler have been stopped."
