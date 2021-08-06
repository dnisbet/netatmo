#!/bin/bash
# Tutorial https://www.daimto.com/how-to-get-a-google-access-token-with-curl/
# YouTube video https://youtu.be/hBC_tVJIx5w
# Client id from Google Developer console
# Client Secret from Google Developer console
# Scope this is a space seprated list of the scopes of access you are requesting.
. netatmo-creds.sh

# Authorization link.  Place this in a browser and copy the code that is returned after you accept the scopes.
echo "paste this in a browser and authenticate:"
echo "https://api.netatmo.com/oauth2/authorize?client_id=$clientid&redirect_uri=localhost&scope=read_station&state=1234"

# Exchange Authorization code for an access token and a refresh token.
read -p "Enter the authorization code:" authcode


curl \
--request POST \
--data "code=$authcode&client_id=$clientid&client_secret=$clientsecret&grant_type=authorization_code&redirect_uri=localhost" \
https://api.netatmo.com/oauth2/token > netatmo-token.txt

refreshtoken=$(cat netatmo-token.txt | jq -r '.refresh_token')
# Exchange a refresh token for a new access token.
curl \
--request POST \
--data "client_id=$clientid&client_secret=$clientsecret&refresh_token=$refreshtoken&grant_type=refresh_token" \
https://api.netatmo.com/oauth2/token > netatmo-refresh.txt


