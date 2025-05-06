# App Engine Docs

## Steps

- Create a new project in the Google Cloud Console.
- Enbale App Engine API.
- Create a new App Engine application.
- Open-up cloud shell, app editor, then upload the code existing here.
- Check config project by `gcloud config list`, `gcloud config set project_id`
- Run the command `gcloud app deploy --no-cache` to deploy the application.
- Ensure the service account have a sufficient permisions as `cloud build service account`, `Storage Object Viewer`
- Get app URL by `gcloud app browse`
