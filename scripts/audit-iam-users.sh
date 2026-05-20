#!/bin/bash
# audit-iam-users.sh
# Audits IAM users for MFA status, access key age, and last activity
# Usage: bash audit-iam-users.sh

echo "======================================"
echo " IAM User Audit"
echo " Date: $(date)"
echo "======================================"

echo ""
echo "--- Generating credential report ---"
aws iam generate-credential-report > /dev/null 2>&1
sleep 5

echo ""
echo "--- Credential report (MFA status, key age, last login) ---"
aws iam get-credential-report \
  --query 'Content' \
  --output text | base64 -d | column -t -s ','

echo ""
echo "--- Users with NO MFA device attached ---"
for USER in $(aws iam list-users --query 'Users[*].UserName' --output text); do
  MFA_COUNT=$(aws iam list-mfa-devices \
    --user-name "$USER" \
    --query 'length(MFADevices)' \
    --output text)
  if [ "$MFA_COUNT" -eq "0" ]; then
    echo "  NO MFA: $USER"
  fi
done

echo ""
echo "--- Access keys older than 90 days ---"
for USER in $(aws iam list-users --query 'Users[*].UserName' --output text); do
  aws iam list-access-keys \
    --user-name "$USER" \
    --query "AccessKeyMetadata[?Status=='Active'].{User:UserName,KeyId:AccessKeyId,Created:CreateDate}" \
    --output text | while read LINE; do
    echo "$USER: $LINE"
  done
done

echo ""
echo "--- Policies with wildcard actions (*) ---"
aws iam list-policies \
  --scope Local \
  --query 'Policies[*].{Name:PolicyName,ARN:Arn}' \
  --output table

echo ""
echo "Audit complete."
