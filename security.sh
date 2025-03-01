#!/bin/bash

# Function to configure security
configure_security() {
    # Firewall rules
    gcloud compute firewall-rules create allow-ssh \
        --allow tcp:22 \
        --target-tags=allow-ssh

    gcloud compute firewall-rules create allow-http \
        --allow tcp:80 \
        --target-tags=allow-http

    gcloud compute firewall-rules create deny-all \
        --deny=all \
        --priority=65534 \
        --direction=INGRESS \
        --source-ranges=0.0.0.0/0

    # IAM policy
    SERVICE_ACCOUNT="compute-reader@$PROJECT_ID.iam.gserviceaccount.com"
    gcloud iam service-accounts create compute-reader --display-name="Compute Reader"
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT" \
        --role="roles/compute.instanceViewer"
}