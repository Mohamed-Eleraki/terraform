param($blobTrigger, $TriggerMetadata)

# Read SAS URLs from environment variables
$srcContainerSasUrl = $env:SRC_CONTAINER_SAS_URL   # e.g. https://storageaccount.blob.core.windows.net/sourcecontainer?<SAS>
$dstContainerSasUrl = $env:DST_CONTAINER_SAS_URL   # e.g. https://storageaccount.blob.core.windows.net/destinationcontainer?<SAS>

# Define source and destination relative folder paths
$srcFolder = "source_dir1/source_subdir1/"
$dstFolder = "destination_dir1/destination_subdir1/"

# Compose full source and destination URLs including folder path
$fullSrcUrl = "${srcContainerSasUrl.TrimEnd('/')}/$srcFolder"
$fullDstUrl = "${dstContainerSasUrl.TrimEnd('/')}/$dstFolder"

Write-Output "Copying from: $fullSrcUrl"
Write-Output "Copying to:   $fullDstUrl"

# Run azcopy copy command recursively (include all files & subfolders)
azcopy copy "$fullSrcUrl" "$fullDstUrl" --recursive=true --overwrite=true

Write-Output "Copy operation completed."
