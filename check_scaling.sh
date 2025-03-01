#!/bin/bash

# Function to check scaling
check_scaling() {
    echo "=== Auto-Scaling Test Report ==="
    echo "Starting instances: $(gcloud compute instance-groups managed list-instances $MIG_NAME --zone=$ZONE --format="value(NAME)" | wc -l)"
    
    # Trigger load generation
    INSTANCE_IP=$(gcloud compute instances describe $VM_NAME --format="value(networkInterfaces[0].accessConfigs[0].natIP)" --zone=$ZONE)
    # ssh -o StrictHostKeyChecking=no $INSTANCE_IP 'python3 /d/Mtech_IITJ/Sem_3_assignments/VCC/gcp-autoscaling/load_generator.py' &
    gcloud compute ssh $VM_NAME --zone=$ZONE --command='python3 /d/Mtech_IITJ/Sem_3_assignments/VCC/gcp-autoscaling/load_generator.py' &
    
    # Wait for scaling
    sleep 300

    echo "Ending instances: $(gcloud compute instance-groups managed list-instances $MIG_NAME --zone=$ZONE --format="value(NAME)" | wc -l)"
    
    # Verify firewall and IAM
    echo "Firewall rules:"
    gcloud compute firewall-rules list --filter="name~allow-ssh OR name~allow-http"

    echo "IAM Policy:"
    gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format="table(bindings.role, bindings.members)"
}

# Cleanup resources
cleanup() {
    echo "Cleaning up resources..."
    gcloud compute instance-groups managed delete $MIG_NAME --zone=$ZONE -q
    gcloud compute instances delete $VM_NAME --zone=$ZONE -q
    gcloud compute firewall-rules delete allow-ssh allow-http deny-all -q
    gcloud iam service-accounts delete "compute-reader@$PROJECT_ID.iam.gserviceaccount.com" -q
}