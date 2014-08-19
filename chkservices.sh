#!/bin/bash
# Script to check services and start when something stops
# hflautert@gmail.com

### CUSTOM FIELDS
# Add services separeted with space, eg: "httpd squid"
SERVICES="httpd squid"
MAIL_TO="sysadmin@company.com"
### END OF CUSTOM FIELDS

# Log function
LOG()
{
        logger -t chkservices[$$] $1
}

# Try to recover - start services function
START_SERVICE() {
        local SERVICE=$1
        /etc/init.d/$SERVICE start 1>/dev/null 2>/dev/null
        # Some services like httpd could return status error if test just after start
        # So lets sleep a little bit
        sleep 3
        /etc/init.d/$SERVICE status 1>/dev/null 2>/dev/null
        if [ $? -eq 0 ]; then
                LOG "The service $SERVICE was started successfully."
                local MAIL_BODY="The service $SERVICE has stopped, and was started successfuly by chkservices. Have a look on $HOSTNAME logs, and try to figure out what happened."
                local SUBJECT="Service $SERVICE has restarted on $HOSTNAME"
                echo $MAIL_BODY | mail -s "$SUBJECT" $MAIL_TO
        else
                LOG "The service $SERVICE is stopped and need mantaince to get start."
                local MAIL_BODY="The service $SERVICE is stopped and need mantaince to get start. Access $HOSTNAME and check it out!"
                local SUBJECT="Service $SERVICE is stopped on $HOSTNAME"
                echo $MAIL_BODY | mail -s "$SUBJECT" $MAIL_TO
                #XXX - Develop kill -9, remove pid, something like a powerfull restart
        fi
}

# Main
for i in `echo $SERVICES`; do
# If service exists, get status
test -e /etc/init.d/$i 1>/dev/null 2>/dev/null
if [ "$?" -eq "0" ]; then
        /etc/init.d/$i status 1> /dev/null 2> /dev/null
        # If is not running, try to start
        if [ $? != 0 ]; then
                LOG "The service $i is stopped, chkservices is going to restart it."
                START_SERVICE $i
        fi
        else
                LOG "The declared service $i, was not found."
        fi
done
