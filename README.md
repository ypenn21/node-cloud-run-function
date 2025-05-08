# node-cloud-run-function
node cloud run functions deployment on GCP


#Checkout node js service repo.

git clone https://github.com/ypenn21/node-cloud-run-function/tree/main

#Install build packs for source to image build.

sudo add-apt-repository ppa:cncf-buildpacks/pack-cli

sudo apt-get update

sudo apt-get install pack-cli


#Build docker image for node js service.

sudo add-apt-repository ppa:cncf-buildpacks/pack-cli

sudo apt-get update

sudo apt-get install pack-cli

gcloud config list
export google_project_id=”project_id”

cd functions/hello-world/

pack build --builder=gcr.io/buildpacks/builder us-central1-docker.pkg.dev/${google_project_id}/cloud-run-functions/cloud-run-function-v2:v1



#Provision artifact registry repo with terraform.

cd ../../terraform-cloud-run

terraform init

terraform plan

terraform apply -target=google_artifact_registry_repository.default



#Push the docker image for node js service to artifact registry.

docker push us-central1-docker.pkg.dev/${google_project_id}/cloud-run-functions/cloud-run-function-v2:v1



#Deploy node js service to Cloud Run Functions.

terraform apply



#Test the endpoint from terraform output using curl or on your browser.
