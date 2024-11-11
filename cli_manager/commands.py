GET_USER_LIST="awk -F: '$3 >= 1000 { print $1 }' /etc/passwd"
CHECK_TO_LOCK='sudo grep "^{}:" /etc/shadow | cut -d: -f2'
ADD_USER="sudo useradd -m -p '$(mkpasswd -m sha-512 '{}')' '{}'"
DEL_USER="sudo userdel -r {}"
SUDO_MODE_ON="echo '{}' | sudo -S -v"
SUDO_MODE_OFF="sudo -k"
LOCK_USER="sudo passwd -l {}"
UNLOCK_USER="sudo passwd -u {}"

