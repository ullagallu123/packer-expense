#!/bin/bash

USERID=$(id -u) # User ID
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(basename "$0" | cut -d "." -f1)
LOG_FILE="/tmp/${TIMESTAMP}-${SCRIPT_NAME}.log"

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

# Install required packages
dnf install git telnet nginx amazon-cloudwatch-agent -y &>>"$LOG_FILE"
LOG "Installing git, telnet, nginx, and CloudWatch Agent" $?

# Enable and start nginx service
systemctl enable nginx &>>"$LOG_FILE"
LOG "Enabling nginx service" $?

systemctl start nginx &>>"$LOG_FILE"
LOG "Starting nginx service" $?

# Clear nginx HTML directory
rm -rf /usr/share/nginx/html/* &>>"$LOG_FILE"
LOG "Clearing /usr/share/nginx/html directory" $?

# Clone frontend repository into nginx HTML directory
if [ ! -d "/usr/share/nginx/html/.git" ]; then
    cd /usr/share/nginx/html && git clone https://github.com/ullagallu123/expense-frontend.git . &>>"$LOG_FILE"
    LOG "Cloning expense-frontend repository into /usr/share/nginx/html" $?
else
    echo "Directory /usr/share/nginx/html already contains a Git repository. Skipping cloning." | tee -a "$LOG_FILE"
fi

# Configure NGINX for the frontend
cat <<EOF | tee /etc/nginx/default.d/expense.conf &>>"$LOG_FILE"
proxy_http_version 1.1;

location /api/ {
    proxy_pass http://dev-expense-internal.bapatlas.site/;  # Ensure trailing slash
}

location /health {
    stub_status on;
    access_log off;
}
EOF

LOG "Creating NGINX configuration file /etc/nginx/default.d/expense.conf" $?

# Configure CloudWatch Agent
cat <<EOF | tee /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/nginx/access.log",
                        "log_group_name": "nginx-access-logs",
                        "log_stream_name": "{instance_id}",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "/var/log/nginx/error.log",
                        "log_group_name": "nginx-error-logs",
                        "log_stream_name": "{instance_id}",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "$LOG_FILE",
                        "log_group_name": "script-execution-logs",
                        "log_stream_name": "{instance_id}",
                        "timezone": "UTC"
                    }
                ]
            }
        }
    }
}
EOF

LOG "Creating CloudWatch Agent configuration file" $?

# Enable and Start CloudWatch Agent
systemctl enable amazon-cloudwatch-agent &>>"$LOG_FILE"
LOG "Enabling CloudWatch Agent" $?

systemctl start amazon-cloudwatch-agent &>>"$LOG_FILE"
LOG "Starting CloudWatch Agent" $?

echo "Script execution completed successfully." | tee -a "$LOG_FILE"
