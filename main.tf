
# Ensure you have Control Tower enabled in your organization before running this
data "aws_controltower_account_factory" "smurf_accounts" {
  name = "Smurf Accounts"
}

resource "aws_organizations_organization" "smurf_village" {
  feature_set = "ALL"
}

# Define the accounts you want to create using Account Factory
resource "aws_controltower_account" "barba_smurf" {
  account_name           = "Barba Smurf"
  email                  = "barba.smurf@example.com" # Unique email for Barba Smurf account
  organizational_unit_id = data.aws_controltower_account_factory.smurf_accounts.id
}

resource "aws_controltower_account" "smurfette" {
  account_name           = "Smurfette"
  email                  = "smurfette@example.com" # Unique email for Smurfette account
  organizational_unit_id = data.aws_controltower_account_factory.smurf_accounts.id
}

resource "aws_controltower_account" "brainy_smurf" {
  account_name           = "Brainy Smurf"
  email                  = "brainy.smurf@example.com" # Unique email for Brainy Smurf account
  organizational_unit_id = data.aws_controltower_account_factory.smurf_accounts.id
}

# SCP for denying internet access
resource "aws_organizations_policy" "deny_internet_access" {
  name        = "DenyInternetAccess"
  description = "Prevent Smurfs from accessing the internet"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceVpce" = "vpce-1234567890abcdef0" # Example VPC Endpoint
          }
        }
      }
    ]
  })
}

# Attach SCP to the accounts created
resource "aws_organizations_policy_attachment" "attach_deny_internet_barba" {
  policy_id = aws_organizations_policy.deny_internet_access.id
  target_id = aws_controltower_account.barba_smurf.id
}

resource "aws_organizations_policy_attachment" "attach_deny_internet_smurfette" {
  policy_id = aws_organizations_policy.deny_internet_access.id
  target_id = aws_controltower_account.smurfette.id
}

resource "aws_organizations_policy_attachment" "attach_deny_internet_brainy" {
  policy_id = aws_organizations_policy.deny_internet_access.id
  target_id = aws_controltower_account.brainy_smurf.id
}

output "organization_id" {
  value = aws_organizations_organization.smurf_village.id
}
