# node-cloud-run-function
node cloud run functions deployment on GCP

# Checkout node js service repo.
```bash
git clone https://github.com/ypenn21/node-cloud-run-function/tree/main
```

# Install build packs for source to image build.
```bash
sudo add-apt-repository ppa:cncf-buildpacks/pack-cli
sudo apt-get update
sudo apt-get install pack-cli
```

# Build docker image for node js service.
```bash
sudo add-apt-repository ppa:cncf-buildpacks/pack-cli
sudo apt-get update
sudo apt-get install pack-cli
gcloud config list
export google_project_id="project_id"
cd functions/hello-world/
pack build --builder=gcr.io/buildpacks/builder us-central1-docker.pkg.dev/${google_project_id}/cloud-run-functions/cloud-run-function-v2:v1
```

# Provision artifact registry repo with terraform.
```bash
cd ../../terraform-cloud-run
terraform init
terraform plan
terraform apply -target=google_artifact_registry_repository.default
```

# Push the docker image for node js service to artifact registry.
```bash
docker push us-central1-docker.pkg.dev/${google_project_id}/cloud-run-functions/cloud-run-function-v2:v1
```

# Deploy node js service to Cloud Run Functions.
```bash
terraform apply
```

# Test the endpoint from terraform output using curl or on your browser.

```bash
gcloud run deploy functionstest2   --source .   --function helloHttp   --base-image us-central1-docker.pkg.dev/serverless-runtimes/google-22/runtimes/nodejs22   --region us-central1   --image us-central1-docker.pkg.dev/genai-playground24/cloud-run-functions/cloud-run-function-v2:v1
```
