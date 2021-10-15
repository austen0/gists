#!/usr/bin/env bash

source ~/.bash2phonerc

MESSAGE="${@}"

curl "https://api.twilio.com/2010-04-01/Accounts/${ACCT_SID}/Messages.json" -X POST \
    --data-urlencode "To=${RECIPIENT}" \
    --data-urlencode "From=${SENDER}" \
    --data-urlencode "Body=${MESSAGE}" \
    -u ${ACCT_SID}:${AUTH_TOKEN} &>> ~/.bash2phone.log

# Empty log file if it gets bigger than 10MB
if [[ $(stat -c%s ~/.bash2phone.log) -gt $((10**7)) ]]; then
    echo "" > ~/.bash2phone.log
fi
