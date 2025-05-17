#!/bin/bash

# Variables
USERID=$(id -u) # User id
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(basename "$0" | cut -d "." -f1)
LOG_FILE="/tmp/${TIMESTAMP}-${SCRIPT_NAME}.log"
REPO_URL="https://github.com/sivaramakrishna-konka/3-tier-vm-backend.git"
APP_DIR="/app"
# SERVICE_FILE="/etc/systemd/system/backend.service"
# CW_CONFIG_FILE="/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"

# Colors for terminal output
R="\e[31m"   # Red
G="\e[32m"   # Green
Y="\e[33m"   # Yellow
N="\e[0m"    # Reset

echo "Script started executing at: $TIMESTAMP"
echo "Log file: $LOG_FILE"

# Function to log command success or failure
LOG() {
    local MESSAGE="$1"
    local STATUS="$2"
    if [ "$STATUS" -eq 0 ]; then
        echo -e "$MESSAGE ..... ${G}Success${N}" | tee -a "$LOG_FILE"
    else
        echo -e "$MESSAGE ..... ${R}Failed${N}" | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Check if the script is run as root
if [ $USERID -ne 0 ]; then
    echo -e "${R}Please run this script with sudo privileges${N}" | tee -a "$LOG_FILE"
    exit 1
else
    echo -e "${G}Here we go to installation${N}" | tee -a "$LOG_FILE"
fi

dnf update -y &>>"$LOG_FILE"
LOG "Updating the packages" $?

curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &>>"$LOG_FILE"
LOG "Downloading Node.js setup script" $?

# Install required packages
dnf install git telnet nodejs amazon-cloudwatch-agent -y &>>"$LOG_FILE"
LOG "Installing git, telnet, Node.js 20, and CloudWatch Agent" $?

# Add 'expense' user if not exists
if ! id -u expense &>/dev/null; then
    useradd expense &>>"$LOG_FILE"
    LOG "Adding 'expense' user" $?
fi

# Clone backend repository if directory doesn't exist
if [ ! -d "$APP_DIR" ]; then
    mkdir "$APP_DIR" &>>"$LOG_FILE"
    LOG "Creating directory $APP_DIR" $?

    git clone "$REPO_URL" "$APP_DIR" &>>"$LOG_FILE"
    LOG "Cloning expense-backend repository to $APP_DIR" $?
else
    echo "Directory $APP_DIR already exists. Skipping cloning." | tee -a "$LOG_FILE"
fi

# Install dependencies for the backend
cd "$APP_DIR" && npm install &>>"$LOG_FILE"
LOG "Installing npm dependencies for the backend" $?

# # Configure systemd service for backend
# cat <<EOF | tee "$SERVICE_FILE" &>>"$LOG_FILE"
# [Unit]
# Description=Backend Service

# [Service]
# User=expense
# Environment="DB_HOST=test-db.konkas.tech"
# Environment="DB_USER=crud"
# Environment="DB_PASSWORD=CrudApp@1"
# Environment="DB_NAME=crud_app"
# Environment="REDIS_HOST=test-redis.konkas.tech"
# Environment="REDIS_PORT=6379"
# ExecStart=/usr/bin/node $APP_DIR/index.js
# SyslogIdentifier=backend


# [Install]
# WantedBy=multi-user.target
# EOF

# LOG "Creating systemd service file $SERVICE_FILE" $?

# # Reload systemd daemon and start backend service
# systemctl daemon-reload &>>"$LOG_FILE"
# LOG "Reloading systemd daemon" $?

# systemctl enable backend &>>"$LOG_FILE"
# LOG "Enabling backend service to start on boot" $?

# # Configure CloudWatch Agent
# cat <<EOF | tee "$CW_CONFIG_FILE" &>>"$LOG_FILE"
# {
#   "agent": {
#     "metrics_collection_interval": 60,
#     "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
#   },
#   "logs": {
#     "logs_collected": {
#       "files": {
#         "collect_list": [
#           {
#             "file_path": "/var/log/messages",
#             "log_group_name": "backend-log-group",
#             "log_stream_name": "{instance_id}",
#             "timestamp_format": "%b %d %H:%M:%S"
#           },
#           {
#             "file_path": "/tmp/${TIMESTAMP}-${SCRIPT_NAME}.log",
#             "log_group_name": "backend-installation-log",
#             "log_stream_name": "{instance_id}",
#             "timestamp_format": "%Y-%m-%d-%H-%M-%S"
#           }
#         ]
#       }
#     }
#   }
# }
# EOF

# LOG "Creating CloudWatch Agent configuration file" $?

# # Start and enable CloudWatch Agent
# systemctl enable amazon-cloudwatch-agent &>>"$LOG_FILE"
# LOG "Enabling CloudWatch Agent to start on boot" $?

# systemctl restart amazon-cloudwatch-agent &>>"$LOG_FILE"
# LOG "Restarting CloudWatch Agent" $?

echo "Script execution completed successfully." | tee -a "$LOG_FILE"
