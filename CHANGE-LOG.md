# Change Log: AWS Infrastructure Audit

Master index of all change records executed in this environment.
Each record documents pre-change state, exact steps performed, post-change validation, and rollback plan.

---

## Format

`CR-YYYY-MM-DD-###_Description.md`

| Field | Description |
|---|---|
| Change ID | Unique identifier |
| Date & Time (CT) | When the change was executed |
| Performed By | Engineer who executed |
| Authorized By | Approver |
| Environment | prod / dev / staging |
| Risk Level | Critical / High / Medium / Low |
| Resources Affected | Resource names and IDs (sanitized) |
| Pre-Change State | CLI output or description before change |
| Steps Performed | Exact CLI commands run |
| Post-Change Validation | How success was confirmed |
| Rollback Plan | How to reverse if needed |
| Outcome | Success / Failed / Partial |

---

## Index

### IAM

| Change ID | Date | Description | Risk | Outcome |
|---|---|---|---|---|
| CR-2025-01-001 | 2025-01-10 | Enable IAM recording in AWS Config | Medium | Success |
| CR-2025-01-002 | 2025-01-14 | MFA enforcement for human and hybrid users | Medium | Success |
| CR-2025-02-001 | 2025-02-03 | Access key rotation: stale keys over 180 days | Medium | Success |
| CR-2025-02-002 | 2025-02-17 | Disable stale IAM users with no recent activity | Low | Success |

### Network / Security Groups

| Change ID | Date | Description | Risk | Outcome |
|---|---|---|---|---|
| CR-2025-03-001 | 2025-03-05 | Aurora dev cluster SG: remove 0.0.0.0/0 ingress | High | Success |
| CR-2025-03-002 | 2025-03-12 | Aurora dev: set PubliclyAccessible=false | High | Success |
| CR-2025-04-001 | 2025-04-02 | Production restriction SG: enrol source SGs | High | Success |
| CR-2025-04-002 | 2025-04-18 | Enable Aurora audit logging: CONNECT events | Low | Success |

### Storage

| Change ID | Date | Description | Risk | Outcome |
|---|---|---|---|---|
| CR-2025-05-001 | 2025-05-01 | Enable EBS encryption by default | Low | Success |
| CR-2025-05-002 | 2025-05-08 | Migrate gp2 volumes to gp3, non-prod | Medium | Success |
| CR-2025-05-003 | 2025-05-15 | Delete 5 unattached EBS volumes | Medium | Success |

### Compute

| Change ID | Date | Description | Risk | Outcome |
|---|---|---|---|---|
| CR-2025-06-001 | 2025-06-10 | Lambda runtime upgrade: nodejs16.x batch 1 | Medium | Success |
| CR-2025-06-002 | 2025-06-24 | Lambda runtime upgrade: nodejs16.x batch 2 | Medium | Success |

### Database

| Change ID | Date | Description | Risk | Outcome |
|---|---|---|---|---|
| CR-2025-07-001 | 2025-07-07 | Delete unused RDS instance: mysqlwebsite | Medium | Success |
| CR-2025-07-002 | 2025-07-14 | Enable Aurora deletion protection: prod cluster | Low | Success |

---

> All resource IDs, ARNs, account numbers, and internal identifiers have been sanitized.
