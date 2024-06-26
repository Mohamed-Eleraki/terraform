#!/bin/bash

# Create a Directory holds all function dependencies
mkdir scripts/fetchVPCs_dependencies; cd scripts/fetchVPCs_dependencies; mkdir python

# Create a virtual environment with python3.11
python3.11 -m venv fetchVPCs_depens_env

# Activate the virtual environment - Provide the Absolute  path
source ./mnt/c/Scripts/gitRepos/terraform/AWS_Demo/15-lambda_layers/scripts/fetchVPCs_dependencies/fetchVPCs_depens_env/bin/activate

# Install boto3 library inside the virtual environment - install all the libraries here - Or use requirements.txt
pip install boto3
pip install pg8000

# Deactivate the virtual environment
deactivate

# Copy the content of the installed library into python dir
#cd fetchVPCs_depens_env/lib
cp -r fetchVPCs_depens_env/lib python/

# Create a zip file containing the current directory content
#zip -r ../../../../../fetchVPCs_depens_packages.zip .
#zip -r ../../../fetchVPCs_dependencies/python/fetchVPCs_depens_packages.zip .
zip -r ../fetchVPCs_depens_packages.zip python/