# #!/bin/bash

# # Variables
# USERID=$(id -u) # User id
# TIMESTAMP=$(date +%F-%H-%M-%S)
# SCRIPT_NAME=$(basename "$0" | cut -d "." -f1)
# LOG_FILE="/tmp/${TIMESTAMP}-${SCRIPT_NAME}.log"
# REPO_URL="https://github.com/ullagallu123/expense-backend.git"
# APP_DIR="/app"
# SERVICE_FILE="/etc/systemd/system/backend.service"

# # Colors for terminal output
# R="\e[31m"   # Red
# G="\e[32m"   # Green
# Y="\e[33m"   # Yellow
# N="\e[0m"    # Reset

# echo "Script started executing at: $TIMESTAMP"
# echo "Log file: $LOG_FILE"

# # Function to log command success or failure
# LOG() {
#     local MESSAGE="$1"
#     local STATUS="$2"
#     if [ "$STATUS" -eq 0 ]; then
#         echo -e "$MESSAGE ..... ${G}Success${N}" | tee -a "$LOG_FILE"
#     else
#         echo -e "$MESSAGE ..... ${R}Failed${N}" | tee -a "$LOG_FILE"
#         exit 1
#     fi
# }

# # Check if the script is run as root
# if [ $USERID -ne 0 ]; then
#     echo -e "${R}Please run this script with sudo privileges${N}" | tee -a "$LOG_FILE"
#     exit 1
# else
#     echo -e "${G}Here we go to installation${N}" | tee -a "$LOG_FILE"
# fi

# dnf update -y &>>"$LOG_FILE"
# LOG "Updating the packages" $?

# curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &>>"$LOG_FILE"
# LOG "Downloading Node.js setup script" $?

# # Install required packages
# dnf install git telnet nodejs -y &>>"$LOG_FILE"
# LOG "Installing git, telnet, and Node.js 20" $?

# # Add 'expense' user if not exists
# if ! id -u expense &>/dev/null; then
#     useradd expense &>>"$LOG_FILE"
#     LOG "Adding 'expense' user" $?
# fi

# # Clone backend repository if directory doesn't exist
# if [ ! -d "$APP_DIR" ]; then
#     mkdir "$APP_DIR" &>>"$LOG_FILE"
#     LOG "Creating directory $APP_DIR" $?

#     git clone "$REPO_URL" "$APP_DIR" &>>"$LOG_FILE"
#     LOG "Cloning expense-backend repository to $APP_DIR" $?
# else
#     echo "Directory $APP_DIR already exists. Skipping cloning." | tee -a "$LOG_FILE"
# fi

# # Install dependencies for the backend
# cd "$APP_DIR" && npm install &>>"$LOG_FILE"
# LOG "Installing npm dependencies for the backend" $?

# # Configure systemd service for backend
# cat <<EOF | tee "$SERVICE_FILE" &>>"$LOG_FILE"
# [Unit]
# Description=Backend Service

# [Service]
# User=expense
# Environment="DB_HOST=qa-expense.bapatlas.site"
# Environment="DB_USER=expense"
# Environment="DB_PWD=ExpenseApp@1"
# Environment="DB_DATABASE=transactions"
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



# echo "Script execution completed successfully." | tee -a "$LOG_FILE"

#!/bin/bash

# Variables
USERID=$(id -u) # User id
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(basename "$0" | cut -d "." -f1)
LOG_FILE="/tmp/${TIMESTAMP}-${SCRIPT_NAME}.log"
REPO_URL="https://github.com/ullagallu123/expense-backend.git"
APP_DIR="/app"
SERVICE_FILE="/etc/systemd/system/backend.service"
NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v1.9.0/node_exporter-1.9.0.linux-amd64.tar.gz"
NODE_EXPORTER_DIR="/home/ec2-user/node_exporter"
NODE_EXPORTER_SERVICE="/etc/systemd/system/node-exporter.service"

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
dnf install git telnet nodejs  -y &>>"$LOG_FILE"
LOG "Installing git, telnet, and Node.js 20" $?

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

# Configure systemd service for backend
cat <<EOF | tee "$SERVICE_FILE" &>>"$LOG_FILE"
[Unit]
Description=Backend Service

[Service]
User=expense
Environment="DB_HOST=test-db.konkas.tech"
Environment="DB_USER=expense"
Environment="DB_PWD=ExpenseApp@1"
Environment="DB_DATABASE=transactions"
ExecStart=/usr/bin/node $APP_DIR/index.js
SyslogIdentifier=backend

[Install]
WantedBy=multi-user.target
EOF

LOG "Creating systemd service file $SERVICE_FILE" $?

# Reload systemd daemon and start backend service
systemctl daemon-reload &>>"$LOG_FILE"
LOG "Reloading systemd daemon" $?

systemctl enable backend &>>"$LOG_FILE"
LOG "Enabling backend service to start on boot" $?

# Install Node Exporter
wget "$NODE_EXPORTER_URL" -P /home/ec2-user &>>"$LOG_FILE"
LOG "Downloading Node Exporter" $?

tar -xvzf /home/ec2-user/node_exporter-1.9.0.linux-amd64.tar.gz -C /home/ec2-user &>>"$LOG_FILE"
LOG "Extracting Node Exporter" $?

mv /home/ec2-user/node_exporter-1.9.0.linux-amd64 "$NODE_EXPORTER_DIR" &>>"$LOG_FILE"
LOG "Moving Node Exporter to $NODE_EXPORTER_DIR" $?

# Configure systemd service for Node Exporter
cat <<EOF | tee "$NODE_EXPORTER_SERVICE" &>>"$LOG_FILE"
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=ec2-user
Group=ec2-user
Type=simple
ExecStart=$NODE_EXPORTER_DIR/node_exporter --web.listen-address=0.0.0.0:9100

Restart=always

[Install]
WantedBy=multi-user.target
EOF

LOG "Creating systemd service file for Node Exporter" $?

# Reload systemd daemon and start Node Exporter service
systemctl daemon-reload &>>"$LOG_FILE"
LOG "Reloading systemd daemon" $?

systemctl enable node-exporter &>>"$LOG_FILE"
LOG "Enabling Node Exporter service to start on boot" $?

echo "Script execution completed successfully." | tee -a "$LOG_FILE"

