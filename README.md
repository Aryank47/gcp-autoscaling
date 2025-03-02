# GCP Auto-Scaling Project

This repository contains scripts for setting up automated VM scaling and security configurations on Google Cloud Platform (GCP).

## Prerequisites

1. Google Cloud Account

   - Create an account at [Google Cloud Console](https://console.cloud.google.com/)
   - Set up billing (free tier available)

2. GCP Project

   - Create a new project or select an existing one
   - Note your Project ID

3. GCP Account Permissions

   - Ensure your account has "Compute Admin" permissions

4. Installed Software
   - Git
   - Google Cloud SDK (gcloud CLI)

## Setup Instructions

### Step 1: Install Google Cloud SDK

1. Download and install the Google Cloud SDK for your operating system:

   - [Google Cloud SDK Downloads](https://cloud.google.com/sdk/docs/install)

2. Initialize the SDK:

   ```bash
   gcloud init
   ```

3. Authenticate your account:
   ```bash
   gcloud auth login
   ```

### Step 2: Configure gcloud CLI

1. Set your project ID:

   ```bash
   gcloud config set project [YOUR_PROJECT_ID]
   ```

2. Set the default compute zone (replace with your preferred zone):
   ```bash
   gcloud config set compute/zone asia-south1-c
   ```

### Step 3: Clone Repository

```bash
git clone https://github.com/Aryank47/gcp-autoscaling.git
cd gcp-autoscaling
```

### Step 4: Run the Scripts

1. Create resources:

   ```bash
   chmod +x *.sh
   ```

2. Configure security:

   ```bash
   export PROJECT_ID="YOUR_PROJECT_ID"
   ```

3. Test auto-scaling:
   ```bash
   ./main.sh
   ```

### Step 5: View Metrics

1. Open the GCP Console: [Google Cloud Console](https://console.cloud.google.com/)

2. Navigate to "Compute Engine" > "Monitoring"

3. Select your project and view the CPU utilization metrics for your instances

## Script Details

- `setup.sh`: Creates VM instance template and managed instance group
- `security.sh`: Configures firewall rules and IAM roles
- `check_scaling.sh`: Generates CPU load and validates auto-scaling
- `cleanup.sh`: Deletes all created resources

## Notes

- Ensure you have the "Compute Admin" role for your GCP account
- Monitor your billing account to avoid unexpected charges
- Adjust the `MAX_INSTANCES` and `TARGET_CPU` variables in `setup.sh` as needed

---
