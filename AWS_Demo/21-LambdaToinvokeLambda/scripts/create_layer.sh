#!/bin/bash

# Create a Directory holds all function dependencies
mkdir URL_Invokation_depends; cd URL_Invokation_depends; mkdir python

# Create a virtual environment with python3.11
python3.11 -m venv URL_Invokation_depends_env

# Activate the virtual environment - Provide the Absolute  path
source ./mnt/c/Scripts/gitRepos/terraform/AWS_Demo/19-lambda-config_EFS_storage-URL_invokation/scripts/URL_Invokation_depends/URL_Invokation_depends_env/bin/activate

# Install boto3 library inside the virtual environment - install all the libraries here - Or use requirements.txt
pip install boto3
pip install json

# Deactivate the virtual environment
deactivate

# Copy the content of the installed library into python dir
#cd fetchVPCs_depens_env/lib
cp -r URL_Invokation_depends_env/lib python/

# Create a zip file containing the current directory content
#zip -r ../../../../../fetchVPCs_depens_packages.zip .
#zip -r ../../../fetchVPCs_dependencies/python/fetchVPCs_depens_packages.zip .
zip -r ../URL_Invokation_depends.zip python/