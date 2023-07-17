#!/bin/bash

# Set the backup script path
MONICRON_HOME="/home/ec2-user/monicron"

# Create a temporary cron file
CRON_FILE=$(mktemp)

# Retrieve existing crontab content (if any)
crontab -l > "$CRON_FILE"

# Append the new cron job entry
echo "* * * * * /bin/bash $(echo $MONICRON_HOME)/monicron.sh" >> "$CRON_FILE"

# Install the updated cron file
crontab "$CRON_FILE"

# Remove the temporary cron file
rm "$CRON_FILE"

# Prevent monicron.sh from deletions
chmod 500 monicron.sh