# if there is a user named 'glassfish' on the system, we'll assume
# that is the user asadmin should be run as
# grep -e '^glassfish' /etc/passwd > /dev/null && alias asadmin='sudo -u glassfish asadmin'