#!/bin/bash

ENV="terraform-prod"

REDIS_SECURITY_GROUP=$(aws ec2 describe-security-groups | \
jq '.SecurityGroups[] | select (.GroupName | contains("'${ENV}'-redis"))' | \
jq -r '.GroupId')
API_SECURITY_GROUP=$(aws ec2 describe-security-groups | \
jq '.SecurityGroups[] | select (.GroupName | contains("'${ENV}'-api"))' | \
jq -r '.GroupId')

terraform import aws_security_group.api "${API_SECURITY_GROUP}"
terraform import aws_security_group.redis "${REDIS_SECURITY_GROUP}"
terraform import aws_security_group_rule.allow_api_6379_to_redis \
"${REDIS_SECURITY_GROUP}_ingress_tcp_6379_6379_${API_SECURITY_GROUP}"
