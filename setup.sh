#!/bin/bash

# Variables
PROJECT_ID=$(gcloud config get-value project)
ZONE=asia-south1-c
MACHINE_TYPE=e2-micro
VM_NAME=test-vm
MIG_NAME=test-mig
TARGET_CPU=0.7
MAX_INSTANCES=3
LOAD_DURATION=300

# Function to create VM and MIG
setup_resources() {
    # Create VM template
    gcloud compute instances create $VM_NAME \
        --machine-type=$MACHINE_TYPE \
        --image-family=debian-11 \
        --image-project=debian-cloud \
        --tags=allow-ssh,allow-http \
        --zone=$ZONE \
        --metadata=startup-script='apt update && apt install -y stress-ng python3
        wget -q -O /d/Mtech_IITJ/Sem_3_assignments/VCC/gcp-autoscaling/load_generator.py https://raw.githubusercontent.com/Aryank47/gcp-autoscaling/main/load_generator.py'

    # Create MIG
    gcloud compute instance-groups managed create $MIG_NAME \
        --template=$VM_NAME \
        --base-instance-name=$VM_NAME \
        --zone=$ZONE \
        --size=1

    # Configure auto-scaling
    gcloud compute instance-groups managed set-autoscaling $MIG_NAME \
        --max-num-replicas=$MAX_INSTANCES \
        --min-num-replicas=1 \
        --target-cpu-utilization=$TARGET_CPU \
        --zone=$ZONE
}