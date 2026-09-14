#!/usr/bin/env bash
set -euo pipefail

EFS_ID="${EFS_ID:?EFS_ID is required}"
ACCESS_POINT_ID="${ACCESS_POINT_ID:?ACCESS_POINT_ID is required}"

sed \
  -e "s/REPLACE_WITH_EFS_FILE_SYSTEM_ID/${EFS_ID}/" \
  -e "s/REPLACE_WITH_EFS_ACCESS_POINT_ID/${ACCESS_POINT_ID}/" \
  k8s/efs-pv.yaml
