#!/bin/bash
# This script sets up IAM policy bindings for a user in a Google Cloud Project.
# It grants the user the roles of "compute.osLogin" and "iam.serviceAccountUser".

USER_ID="<your user account>"
PROJECT_ID="<your project here>"

# Grant the user the "compute.osLogin" role.
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="user:${USER_ID}" \
    --role="roles/compute.osLogin"

# Grant the user the "iam.serviceAccountUser" role.
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="user:${USER_ID}" \
    --role="roles/iam.serviceAccountUser"
