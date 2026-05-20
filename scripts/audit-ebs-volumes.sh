#!/bin/bash
# audit-ebs-volumes.sh
# Audits EBS volumes for encryption status, type (gp2/gp3), and attachment state
# Usage: bash audit-ebs-volumes.sh [--region us-east-1]

REGION=${1:-us-east-1}

echo "======================================"
echo " EBS Volume Audit"
echo " Region: $REGION"
echo " Date: $(date)"
echo "======================================"

echo ""
echo "--- All volumes: state, type, encryption, size ---"
aws ec2 describe-volumes \
  --region "$REGION" \
  --query 'Volumes[*].{ID:VolumeId,State:State,Type:VolumeType,Encrypted:Encrypted,Size:Size,AZ:AvailabilityZone}' \
  --output table

echo ""
echo "--- UNENCRYPTED volumes ---"
aws ec2 describe-volumes \
  --region "$REGION" \
  --filters "Name=encrypted,Values=false" \
  --query 'Volumes[*].{ID:VolumeId,Type:VolumeType,Size:Size,State:State}' \
  --output table

echo ""
echo "--- gp2 volumes (candidates for gp3 upgrade) ---"
aws ec2 describe-volumes \
  --region "$REGION" \
  --filters "Name=volume-type,Values=gp2" \
  --query 'Volumes[*].{ID:VolumeId,Size:Size,Encrypted:Encrypted,State:State}' \
  --output table

echo ""
echo "--- UNATTACHED volumes (State=available) ---"
aws ec2 describe-volumes \
  --region "$REGION" \
  --filters "Name=status,Values=available" \
  --query 'Volumes[*].{ID:VolumeId,Type:VolumeType,Size:Size,Encrypted:Encrypted}' \
  --output table

echo ""
echo "--- Summary counts ---"
TOTAL=$(aws ec2 describe-volumes --region "$REGION" --query 'length(Volumes)' --output text)
UNENCRYPTED=$(aws ec2 describe-volumes --region "$REGION" --filters "Name=encrypted,Values=false" --query 'length(Volumes)' --output text)
GP2=$(aws ec2 describe-volumes --region "$REGION" --filters "Name=volume-type,Values=gp2" --query 'length(Volumes)' --output text)
UNATTACHED=$(aws ec2 describe-volumes --region "$REGION" --filters "Name=status,Values=available" --query 'length(Volumes)' --output text)

echo "  Total volumes:     $TOTAL"
echo "  Unencrypted:       $UNENCRYPTED"
echo "  gp2 (not gp3):     $GP2"
echo "  Unattached:        $UNATTACHED"

echo ""
echo "Audit complete."
