# README.md

# HAMSIP Windows Setup — Complete Guide

This repository provides a complete guide to set up HAMSIP on Windows using MicroSIP, including:

* Requesting VPN and HAMSIP credentials
* Configuring VPN
* Installing and configuring MicroSIP
* Importing contacts automatically from SNOM/HAMSIP
* Automating updates via PowerShell and Task Scheduler

## Repository Structure

```
hamsip-windows-setup/
├── README.md
├── powershell/
│   └── update_hamsip_contacts.ps1
```

## Step 1 — Request Credentials

1. Request a HAMSIP account at your local HAMSIP provider (e.g., via email).
2. You will receive:

```
SIP Username: <yourcallsign>
SIP Password: <yourpassword>
SIP Server: <ip-or-hostname>
VPN Server: <vpn-server-address>
VPN Username: <vpn-user>
VPN Password: <vpn-pass>
```

* Keep these credentials safe.
* You will use them to connect both VPN and MicroSIP.

## Step 2 — VPN Setup on Windows 

0. Request HAMNET VPN via HAMWEB.AT
1. Open **Settings → Network & Internet → VPN → Add VPN connection**
2. Choose **VPN provider: Windows (built-in)**
3. Connection name: `HAMSIP VPN`
4. Server name/address: `<vpn-server-address>`
5. VPN type: e.g., `L2TP/IPSec`
6. Pre-shared key (if required): `securevpn`
7. Username: `<vpn-user>`
8. Password: `<vpn-pass>`
9. Save and connect.
10. Verify connection is established.

## Step 3 — Install MicroSIP

1. Download MicroSIP (Full version) from [https://www.microsip.org/](https://www.microsip.org/)
2. Install it on your PC.
3. Open MicroSIP and add a new account:

   * Account Name: `<callsign>`
   * SIP server: `<sip-server>`
   * Username: `<sip-username>`
   * Password: `<sip-password>`
4. Test calling a known extension (e.g., your own number) to verify connectivity.

## Step 4 — Import SNOM/HAMSIP Contacts

1. SNOM phonebook URL: `http://44.143.70.8/phonebook/snom.php`
2. Use PowerShell script `powershell/update_hamsip_contacts.ps1` to fetch and convert contacts into `contacts.xml` for MicroSIP.

**Close MicroSIP before running the script.**
The script will generate:

* `contacts.xml` → used by MicroSIP
* Optional `hamsip_phonebook.csv` → stored in `data/` for reference or WordPress integration.

## Step 5 — Automate Contact Updates

1. Open **Task Scheduler → Create Task**
2. Trigger: Daily or every X minutes
3. Action: Run PowerShell script:

```text
powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\hamsip-windows-setup\powershell\update_hamsip_contacts.ps1"
```

4. Ensure MicroSIP is closed during updates.

## Step 6 — WordPress Article Integration (Optional)

* Place `data/hamsip_phonebook.csv` in WordPress uploads.
* Display it with a simple CSV plugin or PHP snippet.

## Step 7 — Notes & Tips

* Always **close MicroSIP** when updating contacts.
* Leading `00` is removed automatically for proper SIP dialing.
* Name/number fields are switched as required by MicroSIP:

  * `Name` = number
  * `Number` = callsign
