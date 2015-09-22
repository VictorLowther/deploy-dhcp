#!/bin/bash

if ! rebar nodes roles "$HOSTNAME" |grep -q 'dhcp_database'; then
    rebar nodes bind "$HOSTNAME" to 'dhcp-database'
fi
