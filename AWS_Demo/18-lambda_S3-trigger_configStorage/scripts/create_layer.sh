#!/bin/bash

# Create a Directory holds all function dependencies
mkdir objectMigration_dependencies; cd objectMigration_dependencies; mkdir python

# Create a virtual environment with python3.11
python3.11 -m venv objectMigration_dependencies_env

# Activate the virtual environment - Provide the Absolute  path
source ./mnt/c/Scripts/gitRepos/terraform/AWS_Demo/18-lambda_S3-trigger_configStorage/scripts/objectMigration_dependencies/objectMigration_dependencies_env/bin/activate

# Install boto3 library inside the virtual environment - install all the libraries here - Or use requirements.txt
pip install boto3

# Deactivate the virtual environment
deactivate

# Copy the content of the installed library into python dir
#cd fetchVPCs_depens_env/lib
cp -r objectMigration_dependencies_env/lib python/

# Create a zip file containing the current directory content
#zip -r ../../../../../fetchVPCs_depens_packages.zip .
#zip -r ../../../fetchVPCs_dependencies/python/fetchVPCs_depens_packages.zip .
zip -r ../objectMigration_dependencies.zip python/