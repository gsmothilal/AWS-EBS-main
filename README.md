
#  Terraform CI/CD: EC2 + EBS with Cost Estimation & Manual Approval

This project automates the creation of:
- An **EC2 instance**
- An **EBS volume**
- Automatic **attachment of EBS to the EC2**

All using **Terraform + GitHub Actions**, with a safe and review-based deployment process.

---

##  What It Deploys

-  **EC2 Instance**
  - Created from Terraform config
  - Region: `us-east-1`
-  **EBS Volume**
  - 8GB general purpose SSD (gp2)
  - Automatically **attached to EC2**
-  **S3 Bucket**
  - Stores Terraform state
  - Created on first run (if not exists)

---

##  How It Works

- GitHub Action runs on every push to the `main` branch:
  - `terraform init` and `terraform plan` run automatically
  - A **cost estimate summary** is shown
- The pipeline waits for **manual approval**
- Once approved, it runs `terraform apply` to create the EC2 + EBS

---

##  Steps to Use This Project

###  Clone the Repo

```bash
git clone https://github.com/<your-username>/<your-repo-name>.git
cd <your-repo-name>
```

###  Set Up GitHub Secrets

Go to **Settings → Secrets → Actions** in your repo and add:

| Name                   | Value                          |
|------------------------|--------------------------------|
| `AWS_ACCESS_KEY_ID`    | Your AWS access key            |
| `AWS_SECRET_ACCESS_KEY`| Your AWS secret key            |

> These credentials must have permissions to manage EC2, EBS, and S3.

---

### Add Collaborators

1. Go to your repo → **Settings → Collaborators**
2. Click **"Invite a collaborator"**
3. Enter your teammate’s GitHub username
4. Choose appropriate access (usually **Write** or **Admin**)
5. Send invite

>  **Note**: If you're the owner, you cannot add yourself — you already have full access.

---

###  Add a GitHub Environment

1. Go to **Settings → Environments**
2. Click **"New environment"**, name it `dev-approval`
3. Under **"Deployment protection rules"**, click **"Required reviewers"**
4. Add your GitHub username (or a teammate)
5. Click **Save**

This will enforce **manual approval before applying infrastructure**.

---

###  Push Code to Main Branch

```bash
git add .
git commit -m "initial commit"
git push origin main
```

This will trigger the GitHub Actions workflow.

---

##  How to Approve Apply Step

1. Go to your repo → **Actions**
2. Click on the latest run
3. Find the `Terraform Apply (Manual Approval)` job
4. Click **"Review deployments"**
5. Hit **"Approve and deploy"**

---

##  Folder Structure

```
.
├── main.tf               # Resources: EC2, EBS, attachment
├── provider.tf           # AWS provider configuration
├── variables.tf          # Input variable definitions
├── backend.tf            # S3 remote backend configuration
├── environments/
│   ├── dev.tfvars
│   ├── uat.tfvars
│   └── prod.tfvars
├── terraform.tfvars      # Default values (optional)
├── outputs.tf            # Outputs (EC2 ID, Volume ID)
└── .github/workflows/
    └── terraform.yml     # GitHub Actions workflow
```

---

##  Behind the Scenes: What Happens

- EC2 is created using `aws_instance`
- EBS is created using `aws_ebs_volume`
- EBS is attached using `aws_volume_attachment`
- S3 bucket stores the remote Terraform state
- GitHub Actions runs the full flow with cost preview and manual approval

---

##  Estimated Monthly Costs

| Resource     | Amount | Approx Cost        |
|--------------|--------|--------------------|
| EC2          | 1      | ~$8/month          |
| EBS Volume   | 8 GB   | ~$0.64/month       |
| **Total**    |        | **~$8.64/month**   |

> Note: This is a simple estimation for demonstration only.

---

##  Want to Extend It?

- Add Slack/SNS alerts on apply
- Create prod and staging environments
- Use Infracost for real AWS pricing
- Add monitoring or tagging in Terraform

---


---

##  Architecture Diagram

```
GitHub Repo
   |
   |  (push to main)
   ▼
GitHub Actions CI/CD
   |
   ├── terraform init
   ├── terraform plan  -->  Estimated cost in GitHub summary
   ├── waits for approval (via dev-approval environment)
   └── terraform apply (if approved)
        |
        ├── Creates EC2 instance
        ├── Creates EBS volume
        └── Attaches EBS to EC2

AWS Infrastructure (after apply):
   ┌──────────────┐
   │   EC2        │
   │  Instance    │
   └─────┬────────┘
         │ attached via Terraform
   ┌─────▼───────┐
   │    EBS      │
   │   Volume    │
   └─────────────┘
```

---

##  Cleanup (Optional)

To destroy the resources when done:

```bash
terraform destroy -var-file="environments/dev.tfvars"
```

