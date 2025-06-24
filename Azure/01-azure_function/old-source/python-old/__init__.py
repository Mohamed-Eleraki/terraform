import logging
import os
import csv
import io
from datetime import datetime, timedelta
from azure.storage.blob import BlobServiceClient, generate_blob_sas, BlobSasPermissions

def main(inputBlob: bytes):
    logging.info("Triggered by new or updated CSV blob.")

    source_container = "source"
    destination_container = "destination"
    src_connection_str = "source_dir1/source_subdir1/"
    dst_connection_str = "destination_dir1/destination_subdir1/"
    
    # Initialize clients
    src_service = BlobServiceClient.from_connection_string(src_connection_str)
    dst_service = BlobServiceClient.from_connection_string(dst_connection_str)

    src_blob_client = src_service.get_blob_client(container=source_container, blob=source_blob_name)
    dst_blob_client = dst_service.get_blob_client(container=destination_container, blob=destination_blob_name)


    if not all([src_conn_str, dst_conn_str, source_container, dest_container]):
        raise ValueError("Missing one or more required environment variables.")

    # Setup blob clients
    src_service = BlobServiceClient.from_connection_string(src_conn_str)
    dst_service = BlobServiceClient.from_connection_string(dst_conn_str)

    src_container_client = src_service.get_container_client(source_container)
    dst_container_client = dst_service.get_container_client(dest_container)

    # Parse the CSV
    csv_file = io.StringIO(inputBlob.decode('utf-8'))
    reader = csv.DictReader(csv_file)

    for row in reader:
        src_blob_path = row["source_blob"]
        dst_blob_path = row["destination_blob"]

        logging.info(f"Copying {src_blob_path} -> {dst_blob_path}")

        # Source blob client
        src_blob_client = src_container_client.get_blob_client(src_blob_path)

        # Generate temporary SAS for source blob
        sas_token = generate_blob_sas(
            account_name=src_blob_client.account_name,
            container_name=source_container,
            blob_name=src_blob_path,
            permission=BlobSasPermissions(read=True),
            expiry=datetime.utcnow() + timedelta(minutes=10)
        )

        src_sas_url = f"{src_blob_client.url}?{sas_token}"

        # Destination blob client
        dst_blob_client = dst_container_client.get_blob_client(dst_blob_path)

        # Start the copy
        dst_blob_client.start_copy_from_url(src_sas_url)

    logging.info("All blob copies initiated.")
