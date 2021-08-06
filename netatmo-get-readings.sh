#!/bin/bash
# https://tanaikech.github.io/2017/01/11/one-liner-code-for-netatmo/
#$ curl -s -d "grant_type=password&client_id='#####'&client_secret='#####'&username='#####'&password='#####'&scope=read_station" "https://api.netatmo.net/oauth2/token"|curl -s -d "access_token=`jq -r '.access_token'`&device_id='#####'" "https://api.netatmo.net/api/getstationsdata"|jq -r '"\nIndoor: Temperature "+(.body.devices[0].dashboard_data.Temperature|tostring)+" [degree C], Humidity "+(.body.devices[0].dashboard_data.Humidity|tostring)+" [%], Pressure "+(.body.devices[0].dashboard_data.Pressure|tostring)+" [hPa]\nOutdoor: Temperature "+(.body.devices[0].modules[0].dashboard_data.Temperature|tostring)+" [degree C], Humidity "+(.body.devices[0].modules[0].dashboard_data.Humidity|tostring)+" [%]"'


. netatmo-creds.sh

refreshtoken=$(cat netatmo-token.txt | jq -r '.refresh_token')
# Exchange a refresh token for a new access token.

curl \
-s --request POST \
--data "client_id=$clientid&client_secret=$clientsecret&refresh_token=$refreshtoken&grant_type=refresh_token" \
https://api.netatmo.com/oauth2/token > netatmo-refresh.txt

token=$(cat netatmo-refresh.txt | jq -r '.access_token')

curl -s -X GET "https://api.netatmo.com/api/getstationsdata?get_favorites=false" -H "accept: application/json" -H "Authorization: Bearer $token" | jq -r '"Outdoor Temp: "+(.body.devices[0].modules[0].dashboard_data.Temperature|tostring)+ "[c] ("+(.body.devices[0].modules[0].dashboard_data.temp_trend|tostring)+")\nPressure: "+(.body.devices[0].dashboard_data.Pressure|tostring)+" [hPa]\nNoise: "+(.body.devices[0].dashboard_data.Noise|tostring)+"[dB]\nRain: "+(.body.devices[0].modules[1].dashboard_data.sum_rain_1|tostring)+"[mm/hr]"'
