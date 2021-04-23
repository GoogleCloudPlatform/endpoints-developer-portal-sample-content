
# Bluetooth Documentation

### Reference

* (Assigned Numbers)[https://www.bluetooth.com/specifications/assigned-numbers/]
* (Appearance Values)[https://specificationrefs.bluetooth.com/assigned-values/Appearance%20Values.pdf]


### GATT WIFI Service

| Allocated UUID | Description                     | Attributes  |
| -------------- | ------------------------------- | ----------- |
| 0xD000         | WIFI Service                    | service     |
| 0xD001         | network ssid                    | read,write  |
| 0xD002         | password                        | write       |
| 0xD003         | network list of available ssids | notify      |
| 0xD004         | trigger a connection attempt    | write       |
| 0xD005         | connection status               | read,notify |

#### TODO

add settings defined here https://github.com/Plantiga/CloudAdapter/issues/206

### GATT API Key Service

| Allocated UUID | Description     | Attributes  |
| -------------- | --------------- | ----------- |
| 0xD100         | API Key Service | service     |
| 0xD101         | API Key         | write       |
| 0xD102         | Api status      | read,notify |
| 0xD103         | Team ID         | notify      |
| 0xD104         | Team Name       | notify      |


### About the CloudAdapter Emulator

#### WIFI Service

If the emulator is started with --no-networks, then no networks will be shown for `0xD003` 
network list of available ssids


##### 0xD003 network list

Subscribe will notify for each network found, listener should handle duplicate networks.
Will not notify if network is no longer available.

The following networks will be presented

* "Happy Path" - all passwords will work on this network
* "Bad Password" - the after `0xD004` is set, then 0xD005 will always notify as `PASSWORD_ERROR`
* "Bad Network" - the after `0xD004` is set, then 0xD005 will always notify as `CONNECTION_ERROR`
* "Firewall" - the after `0xD004` is set, then 0xD005 will always notify as `NETWORK_ERROR`

#####  0xD004 trigger a connection attempt

write any value to start a connection

##### 0xD005 connection status

Get or watch the connection status

Possible Values: *TODO: define better*

* `NOT_CONNECTED` *
* `CONNECTING` * waiting for connection
* `CONNECTION_ERROR` * can not connect to the wifi
* `PASSWORD_ERROR` * user password was incorrect -- need to determine how to get this from wpa_cli
* `NETWORK_ERROR` * connected, but there is
* `CONNECTED` * all good

### GATT API Key Service

| Allocated UUID | Description     | Attributes  |
| -------------- | --------------- | ----------- |
| 0xD100         | API Key Service | service     |
| 0xD101         | API Key         | write       |
| 0xD102         | Api status      | read,notify |
| 0xD103         | Team ID         | notify      |
| 0xD104         | Team Name       | notify      |


##### 0xD005 connection status

# 0xD101 API Key

| Possible Values | Description                                                                      | Behaviour                                                                                                     |
| --------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `"my_team_key"` | A good key                                                                       | <ul><li>0xD102 : `KEY_OK`</li><li>0xD103 : `super_awesome_team`</li><li>0xD104 : `SuperAwesomeTeam`</li></ul> |
| `"bad_key"`     | A bad key                                                                        | <ul><li>0xD102 : `KEY_INVALID`</li><li>0xD103 : `0xXXXX` </li><li>0xD104 : `0xXXXX`</li></ul>                 |
| `"timeout_key"` | A key that will cause the emulator to return a timeout error to Plantiga Servers | <ul><li>0xD102 : `CONNECTION_TIMEOUT`</li><li>0xD103 : `0xXXXX` </li><li>0xD104 : `0xXXXX`</li></ul>          |


# 0xD102 Api status

Possible Values: *TODO: define better*

* `KEY_OK`
* `NO_KEY`
* `KEY_INVALID` - AHH!
* `CONNECTION_TIMEOUT` 
