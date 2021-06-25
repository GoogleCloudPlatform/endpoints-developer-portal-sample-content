
# Bluetooth Documentation

## Reference

* [Assigned Numbers](https://www.bluetooth.com/specifications/assigned-numbers/)
* [Appearance Values](https://specificationrefs.bluetooth.com/assigned-values/Appearance%20Values.pdf)

# About the BaseStation Emulator

# GATT WIFI Service

| Allocated UUID | Description                     | Attributes  |
| -------------- | ------------------------------- | ----------- |
| `0xD000`       | WIFI Service                    | service     |
| `0xD001`       | Network SSID                    | read,write  |
| `0xD002`       | Password                        | write       |
| `0xD003`       | Network List of Available SSIDs | notify      |
| `0xD004`       | Trigger a Connection Attempt    | write       |
| `0xD005`       | Connection Status               | read,notify |
<br/>  

## 0xD000 WIFI Service

If the emulator is started with `--no-networks`, then no networks will be shown for `0xD003`
network list of available ssids.

Writing the `0xD001` and `0xD002` characteristics will not be enough to start a network connection attempt, `0xD004` should be written to to trigger a network connection attempt.
<br>

## 0xD001 Network SSID

| Defined Submissions   | Description                                                                                                              |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `"Happy Path"`        | All passwords work on this network, `0xD005` will always notify as `CONNECTED` after `0xD004` is set                     |
| `"Bad Network"`       | After `0xD004` is set, then `0xD005` will always notify as `NETWORK_ERROR`                                               |
| `"Firewall"`          | After `0xD004` is set, then `0xD005` will always notify as `CONNECTION_ERROR`                                            |
| `"Bad Password"`      | After `0xD004` is set, then `0xD005` will always notify as `NETWORK_ERROR | PASSWORD_ERROR`                              |
| `"Duplicate Network"` | After `0xD004` is set, then `0xD005` will always notify as `NETWORK_ERROR`                                               |
| `"Error Network"`     | After `0xD004` is set, then `0xD005` will always notify as `SOFTWARE_ERROR`                                              |
<br>

## 0xD002 Password

Password behaviour for the emulator is defined based on the `0xD001` service
<br>

## 0xD003 Network List

Subscribe will notify for each network found, listener should handle duplicate networks.

Will not notify if network is no longer available.

The following networks will be presented:

* `"Happy Path"`
* `"Bad Password"`
* `"Bad Network"`
* `"Firewall"`
* `"Duplicate Network"`
* `"Duplicate Network"`
* `"Error Network"`
<br>

## 0xD004 Trigger a Connection Attempt

Write any value to start a connection
| Defined Submissions          | Description                            | Behaviour of other Characteristics |
| ---------------------------- | -------------------------------------- | ---------------------------------- |
| `"connect"` or anything else | A value written to tigger a connection | see `0xD001`                       |
<br>

## 0xD005 Connection Status

Get or watch the connection status


| Defined Connection Statuses | Description                                                                                       |
| --------------------------- | ------------------------------------------------------------------------------------------------- |
| `NOT_CONNECTED`             | The default state of the base station                                                             |
| `CONNECTING`                | The base station is attempting to establish a connection and confirm connectivity to our servers  |
| `SOFTWARE_ERROR`            | An unexpected error occured while connecting                                                      |
| `PASSWORD_ERROR`            | User password is incorrect, this event is not available for all access points (see NETWORK_ERROR) |
| `NETWORK_ERROR`             | Unable to connect to the network, this may mean incorrect SSID or Password                        |
| `CONNECTION_ERROR`          | Base station connected to the network, but is unable to reach our servers                         |
| `CONNECTED`                 | Full connection is established                                                                    |
<br/>

## User Experience

If a `SOFTWARE_ERROR` is received, the user should be told to retry the connection and if the issue persists they should contact plantiga support.
If a `PASSWORD_ERROR` or `NETWORK_ERROR` is received, the user should be told to check their Password and retry the connection.

# GATT API Key Service

| Allocated UUID | Description     | Attributes  |
| -------------- | --------------- | ----------- |
| `0xD100`       | API Key Service | service     |
| `0xD101`       | API Key         | write       |
| `0xD102`       | Api Status      | read,notify |
| `0xD103`       | Team ID         | notify      |
| `0xD104`       | Team Name       | notify      |
<br>

## 0xD101 API Key

| Defined Submissions           | Description                                                                      | Behaviour of other Characteristics                                                                            |
| ----------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `"my_team_key"`               | A good key                                                                       | <ul><li>0xD102 : `KEY_OK`</li><li>0xD103 : `super_awesome_team`</li><li>0xD104 : `SuperAwesomeTeam`</li></ul> |
| `"timeout_key"`               | A key that will cause the emulator to return a timeout error to Plantiga Servers | <ul><li>0xD102 : `CONNECTION_TIMEOUT`</li><li>0xD103 : `0xXXXX` </li><li>0xD104 : `0xXXXX`</li></ul>          |
| `"bad_key"`  or anything else | A bad key                                                                        | <ul><li>0xD102 : `KEY_INVALID`</li><li>0xD103 : `0xXXXX` </li><li>0xD104 : `0xXXXX`</li></ul>                 |
<br>

## 0xD102 Api status

| Possible Values      | Description                                                                            |
| -------------------- | -------------------------------------------------------------------------------------- |
| `NOT_SET`            | `0xD101` has not been written to                                                       |
| `KEY_OK`             | `0xD101` is valid                                                                      |
| `KEY_INVALID`        | `0xD101` is invalid                                                                    |
| `CONNECTION_TIMEOUT` | `0xD101` may be correct, but there was a network error when attempting to authenticate |
<br>

## 0xD103 Team ID
### **What type of information will show up in this notify characteristic?**
> An arbitrary length slugged string
<br>

## 0xD104 Team Name
### **What type of information will show up in this notify characteristic?**
> An arbitrary length string, all characters valid
