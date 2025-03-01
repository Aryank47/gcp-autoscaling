#!/bin/bash

# Pre-requisites: Ensure gcloud is installed and authenticated
source setup.sh
source security.sh
source check_scaling.sh

echo "=== Starting GCP Auto-Scaling Test ==="

# Cleanup stale resources
cleanup || true

# Create resources
setup_resources

# Configure security
configure_security

# Validate scaling
check_scaling

# Final cleanup
cleanup