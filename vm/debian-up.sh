#!/usr/bin/env bash
# Check if the script is run as root (or using sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

# Check if openssh server is installed.
if command -v sshd &> /dev/null; then
    echo "openssh-server is installed."
else
    echo "openssh-server is not installed."
    echo "Installing openssh-server."
    apt-get update && apt-get install -y openssh-server
fi

sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' -e 's/^PasswordAuthentication.*/PasswordAuthentication yes/#   ' /etc/ssh/sshd_config
ssh-keygen -A
systemctl restart sshd
   
PERMIT_ROOT_LOGIN=$(grep -E '^PermitRootLogin' /etc/ssh/sshd_config)
PASSWORD_AUTH=$(grep -E '^PasswordAuthentication' /etc/ssh/sshd_config)
SSH_STATUS=$(systemctl is-active sshd)
#   
if [[ "$PERMIT_ROOT_LOGIN" == "PermitRootLogin yes" ]] && [[ "$PASSWORD_AUTH" == "PasswordAuthentication yes" ]] && [[ #   "$SSH_STATUS" == "active" ]]; then
  echo "SSH configuration and service validated successfully."
else
  echo "There was an issue applying the SSH configuration changes."
  echo "Current settings:"
  echo "$PERMIT_ROOT_LOGIN"
  echo "$PASSWORD_AUTH"
  echo "SSH Service Status: $SSH_STATUS"
  return 1
fi   
echo 'Perfect'
