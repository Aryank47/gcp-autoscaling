#!/bin/bash

# Variables
PROJECT_ID=$(gcloud config get-value project)
ZONE=asia-south1-c
MACHINE_TYPE=e2-micro
TEMPLATE_NAME=test-template
MIG_NAME=test-mig
TARGET_CPU=0.7
MAX_INSTANCES=3
LOAD_DURATION=300

setup_resources() {
    # Create Instance Template
    gcloud compute instance-templates create $TEMPLATE_NAME \
        --machine-type=$MACHINE_TYPE \
        --image-family=debian-11 \
        --image-project=debian-cloud \
        --tags=allow-ssh,allow-http \
        --metadata=startup-script='
#!/bin/bash
apt update
apt install -y stress-ng python3
(
cat <<-EOF
import os

def generate_stress(duration=300):
    command = f"stress-ng --cpu 2 --timeout {duration}s"
    os.system(command)

if __name__ == "__main__":
    generate_stress()
EOF
) > /usr/local/bin/load_generator.py
chmod +x /usr/local/bin/load_generator.py
        '

    # Create Managed Instance Group (MIG)
    gcloud compute instance-groups managed create $MIG_NAME \
        --template=$TEMPLATE_NAME \
        --base-instance-name=test-vm \
        --zone=$ZONE \
        --size=1

    # Wait for MIG to stabilize
    sleep 100

    # Configure Auto-Scaling
    gcloud compute instance-groups managed set-autoscaling $MIG_NAME \
        --max-num-replicas=$MAX_INSTANCES \
        --min-num-replicas=1 \
        --target-cpu-utilization=$TARGET_CPU \
        --zone=$ZONE
}