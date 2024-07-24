#!/bin/bash

USERID=$(id -u) # User id
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
dnf install git telnet mariadb105 nodejs20 unzip -y &>>"$LOG_FILE"
LOG "Installing git, telnet, MariaDB 10.5, Node.js 20, and unzip" $?

# Create symbolic links for npm and node
ln -sf /usr/bin/npm-20 /usr/bin/npm &>>"$LOG_FILE"
LOG "Creating npm symbolic link" $?

ln -sf /usr/bin/node-20 /usr/bin/node &>>"$LOG_FILE"
LOG "Creating node symbolic link" $?

# Add 'expense' user if not exists
if ! id -u expense &>/dev/null; then
    useradd expense &>>"$LOG_FILE"
    LOG "Adding 'expense' user" $?
fi

# Create /app directory if it doesn't exist
if [ ! -d "/app" ]; then
    mkdir /app &>>"$LOG_FILE"
    LOG "Creating directory /app" $?
else
    echo "Directory /app already exists. Skipping creation." | tee -a "$LOG_FILE"
fi

# Download and unzip the application
APP_ZIP_URL="https://your-nexus-url/repository/your-repo/application.zip"

curl -u admin:admin -o /tmp/application.zip "$APP_ZIP_URL" &>>"$LOG_FILE"
LOG "Downloading application zip file" $?

unzip /tmp/application.zip -d /app &>>"$LOG_FILE"
LOG "Unzipping application to /app" $?

# Configure systemd service for backend
cat <<EOF | tee /etc/systemd/system/backend.service &>>"$LOG_FILE"
[Unit]
Description=Backend Service

[Service]
User=expense
Environment="DB_HOST=expense.db.test.ullagallu.cloud"
ExecStart=/usr/bin/node /app/index.js
SyslogIdentifier=backend

[Install]
WantedBy=multi-user.target
EOF

LOG "Creating systemd service file /etc/systemd/system/backend.service" $?

# Reload systemd daemon and start backend service
systemctl daemon-reload &>>"$LOG_FILE"
LOG "Reloading systemd daemon" $?

systemctl start backend &>>"$LOG_FILE"
LOG "Starting backend service" $?

systemctl enable backend &>>"$LOG_FILE"
LOG "Enabling backend service to start on boot" $?

echo "Script execution completed successfully." | tee -a "$LOG_FILE"
