#!/bin/sh

# this script creates a new webhook receiver on the webhook container and uses that 
# in the alertmanager.yml file to send alerts to a webhook

# Create a new webhook on webhook.site container
export WEBHOOK_UUID=`curl -X POST -H "Content-Type: application/json" -d '{"default_status": 200, "default_content": "Hello world!", "default_content_type": "application/json", "timeout": 0, "cors": false, "expiry": true, "alias": "webhook", "actions": true}' http://podman:8084/token | jq -r '.uuid'`

echo "WEBHOOK_UUID: $WEBHOOK_UUID"

# Substitute webhook UUID environment variable and generate final configuration file
envsubst < /etc/alertmanager/alertmanager.yml.template > /etc/alertmanager/alertmanager.yml

# Start Alertmanager with the generated configuration
exec /bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml