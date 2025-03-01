#!/bin/bash

check_scaling() {
    echo "=== Auto-Scaling Test Report ==="
    echo "Starting instances: $(gcloud compute instance-groups managed list-instances $MIG_NAME --zone=$ZONE --format="value(NAME)" | wc -l)"
    
    INSTANCE_NAME=$(gcloud compute instance-groups managed list-instances $MIG_NAME --zone=$ZONE --format="value(NAME)" | head -n1)
    INSTANCE_IP=$(gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE --format="value(networkInterfaces[0].accessConfigs[0].natIP)")
    
    gcloud compute ssh $INSTANCE_NAME --zone=$ZONE --command='python3 /usr/local/bin/load_generator.py' &
    sleep 300

    echo "Ending instances: $(gcloud compute instance-groups managed list-instances $MIG_NAME --zone=$ZONE --format="value(NAME)" | wc -l)"
    
    echo "Firewall rules:"
    gcloud compute firewall-rules list --filter="name~allow-ssh OR name~allow-http"

    echo "IAM Policy:"
    gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format="table(bindings.role, bindings.members)"
}

# Cleanup
cleanup() {
    echo "Cleaning up..."
    gcloud compute instance-groups managed delete $MIG_NAME --zone=$ZONE -q || true
    sleep 60
    gcloud compute instance-templates delete $TEMPLATE_NAME -q || true
    gcloud compute firewall-rules delete allow-ssh allow-http deny-all -q || true
    gcloud iam service-accounts delete "compute-reader@$PROJECT_ID.iam.gserviceaccount.com" -q || true
}