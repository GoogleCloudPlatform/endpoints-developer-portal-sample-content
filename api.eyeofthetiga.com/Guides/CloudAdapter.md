
# Bluetooth Documentation

### Reference

* (Assigned Numbers)[https://www.bluetooth.com/specifications/assigned-numbers/]
* (Appearance Values)[https://specificationrefs.bluetooth.com/assigned-values/Appearance%20Values.pdf]


#### TODO

add settings defined here https://github.com/Plantiga/CloudAdapter/issues/206

# About the CloudAdapter Emulator
# GATT WIFI Service

| Allocated UUID | Description                     | Attributes  |
| -------------- | ------------------------------- | ----------- |
| 0xD000         | WIFI Service                    | service     |
| 0xD001         | Network SSID                    | read,write  |
| 0xD002         | Password                        | write       |
| 0xD003         | Network List of Available SSIDs | notify      |
| 0xD004         | Trigger a Connection Attempt    | write       |
| 0xD005         | Connection Status               | read,notify |
<br>

## 0xD000 WIFI Service

If the emulator is started with --no-networks, then no networks will be shown for `0xD003` 
network list of available ssids.

Writing the `0xD001` and `0xD002` characteristics will not be enough to start a network connection attempt, `0xD004` should be written to to trigger a network connection attempt. 
<br>

## 0xD001 Network SSID
| Defined Submissions | Description                                                                    |
| ------------------- | ------------------------------------------------------------------------------ |
| `"Happy Path"`      | All passwords work on this network, `0xD005` will always notify as `CONNECTED` |
| `"Bad Password"`    | After `0xD004` is set, then `0xD005` will always notify as `PASSWORD_ERROR`    |
| `"Bad Network"`     | After `0xD004` is set, then 0xD005 will always notify as `CONNECTION_ERROR`    |
| `"Firewall"`        | After `0xD004` is set, then 0xD005 will always notify as `NETWORK_ERROR`       |
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
<br>

##  0xD004 Trigger a Connection Attempt

Write any value to start a connection
| Defined Submissions           | Description                                                                      | Behaviour of other Characteristics                                                                            |
| ----------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `"connect"` or anything else            | A value written to tigger a connection                                                                      | see `0xD001`|
<br>

## 0xD005 Connection Status

Get or watch the connection status

|Defined Values|Description|
|--------------|-----------|
|`WPA_DISCONNECTED`| This state indicates that client is not associated, but is likely to start looking for an access point. This state is entered when a connection is lost.|
|`WPA_INACTIVE`| This state is entered if there are no enabled networks in the configuration. wpa_supplicant is not trying to associate with a new network and external interaction (e.g., ctrl_iface call to add or enable a network) is needed to start association.|
|`WPA_SCANNING`| This state is entered when wpa_supplicant starts scanning for a network.|
|`WPA_ASSOCIATING`| This state is entered when wpa_supplicant has found a suitable BSS to associate with and the driver is configured to try to associate with this BSS in ap_scan=1 mode. When using ap_scan=2 mode, this state is entered when the driver is configured to try to associate with a network using the configured SSID and security policy.|
|`WPA_ASSOCIATED`| This state is entered when the driver reports that association hasbeen successfully completed with an AP. If IEEE 802.1X is used(with or without WPA/WPA2), wpa_supplicant remains in this stateuntil the IEEE 802.1X/EAPOL authentication has been completed.|
|`WPA_4WAY_HANDSHAKE`|This state is entered when WPA/WPA2 4-Way Handshake is started. Incase of WPA-PSK, this happens when receiving the first EAPOL-Keyframe after association. In case of WPA-EAP, this state is enteredwhen the IEEE 802.1X/EAPOL authentication has been completed.|
|`WPA_GROUP_HANDSHAKE`| This state is entered when 4-Way Key Handshake has been completed (i.e., when the supplicant sends out message 4/4) and when Group Key rekeying is started by the AP (i.e., when supplicant receives message 1/2).|
|`WPA_COMPLETED`|This state is entered when the full authentication process iscompleted. In case of WPA2, this happens when the 4-Way Handshake issuccessfully completed. With WPA, this state is entered after theGroup Key Handshake; with IEEE 802.1X (non-WPA) connection iscompleted after dynamic keys are received (or if not used, afterthe EAP authentication has been completed). With static WEP keys andplaintext connections, this state is entered when an associationhas been completed.This state indicates that the supplicant has completed itsprocessing for the association phase and that data connection isfully configured.|


Possible Values: *TODO: define our wrapper values *

* `CONNECTING` * establishing connection
* `CONNECTION_ERROR` * can not connect to the wifi network
* `PASSWORD_ERROR` * user password was incorrect -- (need to figure out how to find this from wpa_cli)
* `NETWORK_ERROR` * connected to network, but there is an issue connecting to internet
* `CONNECTED` * all good
<br><br>

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
| `NO_KEY`             | `0xD101` has not been written to                                                       |
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
