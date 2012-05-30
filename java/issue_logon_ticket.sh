#!/bin/bash
SCRIPT_DIR=`dirname $0` # so this script can be run from any directory

if [ "$2" == "" ]; then
  echo 1>&2 "Please specify the path to the keystore and the user ID to create a ticket for.  For example, $0 ./keystore1 12345"
  exit 1
fi
KEYSTORE=`pwd`/$1
USER_ID=$2

echo > $SCRIPT_DIR/props
echo "Ticketfile=logon_ticket_new.txt" >> $SCRIPT_DIR/props
echo "keystore=$KEYSTORE" >> $SCRIPT_DIR/props
echo "password=password" >> $SCRIPT_DIR/props
echo "user=$USER_ID" >> $SCRIPT_DIR/props
echo "client=client" >> $SCRIPT_DIR/props
echo "system=system" >> $SCRIPT_DIR/props
echo "defaultKeyAlias=mykey" >> $SCRIPT_DIR/props

OLD_DIR=`pwd`
cd $SCRIPT_DIR
# Hide the sentence Dies ist das Ticket so it's not confused with the contents
#   of the ticket.
# Convert + to ! because SAP does that to avoid having +'s being URLDecoded
#   and interpreted as spaces.
java -cp iaik_jce.jar:com.sap.security.api.jar:com.sap.security.core.jar com.sap.security.core.ticket.imp.Ticket create props | sed "s/Dies ist das Ticket://" | sed "s/+/!/g"
cd $OLD_DIR
rm -f $SCRIPT_DIR/logon_ticket_new.txt
rm -f $SCRIPT_DIR/props
