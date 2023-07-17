#!/bin/bash

# Email configuration
TO_EMAIL="CHANGE_IT@example.com"
FROM_EMAIL="sender@example.com"
SUBJECT="Crontab Modification Detected"
MONICRON_HOME="/home/ec2-user/monicron"
LOG_FILE="$MONICRON_HOME/monicron.log"

# File path for storing the previous crontab status with timestamp
PREVIOUS_CRONTAB_FILE="$MONICRON_HOME/previous_crontab_status"

# Function to send email notification
send_email_notification() {
  local message="$1"
  echo "$message" | mail -r "$FROM_EMAIL" -s "$SUBJECT" "$TO_EMAIL"
}

# Function to log messages
log_message() {
  local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
  local message="$1"
  echo "[$timestamp] $message" >>"$LOG_FILE"
}

# Check if TO_EMAIL and FROM_EMAIL have been updated
if [[ $TO_EMAIL == "CHANGE_IT@example.com" ]] || [[ $FROM_EMAIL == "sender@example.com" ]]; then
  log_message "ERROR: Please update the email configuration in the script."
  exit 1
fi

log_message "Checking crontab changes"
# Check if the previous crontab status file exists
if [ ! -f "$PREVIOUS_CRONTAB_FILE" ]; then
  # Send notification that the file was created
  send_email_notification "Attention: Previous crontab status file created."
  mkdir -p "$MONICRON_HOME"
  touch "$PREVIOUS_CRONTAB_FILE"
else
  log_message "No changes detected"
fi

# Temporary file to store the current crontab status
TMP_FILE=$(mktemp)

# Get the current crontab status
crontab -l >"$TMP_FILE"

# Compare with the previous crontab status
if ! cmp -s "$TMP_FILE" "$PREVIOUS_CRONTAB_FILE"; then
  # Send a notification about the crontab modification
  send_email_notification "Attention: Crontab has been modified!"
fi

# Update the previous crontab status
cp "$TMP_FILE" "$PREVIOUS_CRONTAB_FILE"

# Remove the temporary file
rm "$TMP_FILE"
