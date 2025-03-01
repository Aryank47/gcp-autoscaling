#!/bin/bash

# Pre-requisites: Ensure gcloud is installed and authenticated
source setup.sh
source security.sh
source check_scaling.sh

echo "=== Starting GCP Auto-Scaling Test ==="

# 1. Create resources
setup_resources

# 2. Configure security
configure_security

# 3. Initiate load test
generate_load

# 4. Validate scaling
check_scaling

# 5. Cleanup (uncomment to destroy resources)
Cleanup (uncomment to destroy resources)
gcloud compute instance-groups managed delete $MIG_NAME --zone=$ZONE -q
gcloud compute instances delete $VM_NAME --zone=$ZONE -q
gcloud compute firewall-rules delete allow-ssh allow-http deny-all -q
gcloud iam service-accounts delete "compute-reader@$PROJECT_ID.iam.gserviceaccount.com" -q