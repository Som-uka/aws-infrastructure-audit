#!/bin/bash
# audit-security-groups.sh
# Audits all EC2 security groups for high-risk ingress rules
# Flags: open to 0.0.0.0/0 on sensitive ports (22, 23, 3306, 5432, 6379, 27017)
# Usage: bash audit-security-groups.sh [--region us-east-1]

REGION=${1:-us-east-1}
SENSITIVE_PORTS=(22 23 3306 5432 6379 27017 1433)

echo "======================================"
echo " Security Group Audit"
echo " Region: $REGION"
echo " Date: $(date)"
echo "======================================"

echo ""
echo "--- Fetching all security groups ---"
ALL_SGS=$(aws ec2 describe-security-groups \
  --region "$REGION" \
  --query 'SecurityGroups[*].{ID:GroupId,Name:GroupName,VPC:VpcId}' \
  --output json)

echo ""
echo "--- Checking for 0.0.0.0/0 ingress on sensitive ports ---"
for PORT in "${SENSITIVE_PORTS[@]}"; do
  echo ""
  echo "[Port $PORT]"
  aws ec2 describe-security-groups \
    --region "$REGION" \
    --filters \
      "Name=ip-permission.from-port,Values=$PORT" \
      "Name=ip-permission.to-port,Values=$PORT" \
      "Name=ip-permission.cidr,Values=0.0.0.0/0" \
    --query 'SecurityGroups[*].{ID:GroupId,Name:GroupName,VPC:VpcId}' \
    --output table
done

echo ""
echo "--- Checking for fully open security groups (all ports 0.0.0.0/0) ---"
aws ec2 describe-security-groups \
  --region "$REGION" \
  --filters \
    "Name=ip-permission.from-port,Values=-1" \
    "Name=ip-permission.cidr,Values=0.0.0.0/0" \
  --query 'SecurityGroups[*].{ID:GroupId,Name:GroupName,VPC:VpcId}' \
  --output table

echo ""
echo "--- RDS instances with PubliclyAccessible=true ---"
aws rds describe-db-instances \
  --region "$REGION" \
  --query 'DBInstances[?PubliclyAccessible==`true`].{ID:DBInstanceIdentifier,Engine:Engine,Class:DBInstanceClass,Public:PubliclyAccessible}' \
  --output table

echo ""
echo "Audit complete."
