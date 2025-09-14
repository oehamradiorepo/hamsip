## PowerShell script for updating HAMSIP contacts

# Save this as update_hamsip_contacts.ps1 in powershell/ folder

# --- SETTINGS ---
$phonebookUrl = "http://44.143.70.8/phonebook/snom.php" #using the currently known snom.php => change accordingly if this changes
$microsipContactsPath = "$env:APPDATA\MicroSIP\contacts.xml"
$csvPath = "$PSScriptRoot/../data/hamsip_phonebook.csv"

# --- DOWNLOAD SNOM PHONEBOOK ---
try {
    $text = Invoke-WebRequest -Uri $phonebookUrl -UseBasicParsing | Select-Object -Expand Content
} catch {
    Write-Host "ERROR: Could not download phonebook."
    exit
}

# --- CLEAN UP THE TEXT ---
$textClean = $text -replace "<[^>]+>","" -replace "&#xA;",""

# --- SPLIT INTO NUMBER/NAME PAIRS ---
$entries = $textClean -split '\s+'
$contacts = @()
for ($i=0; $i -lt $entries.Length - 1; $i+=2) {
    $number = $entries[$i].Trim()
    $name   = $entries[$i+1].Trim()
    # Optional: remove leading 00
    if ($number.StartsWith("00")) { $number = $number.Substring(2) }
    if ($number -ne "" -and $name -ne "") {
        # SWITCHED: name = number, number = callsign
        $contacts += [PSCustomObject]@{
            Name   = $number
            Number = $name
        }
    }
}

# --- SAVE CSV ---
$contacts | Export-Csv $csvPath -NoTypeInformation

# --- CREATE MICROSIP CONTACTS.XML ---
$contactsXml = New-Object System.Xml.XmlDocument
$decl = $contactsXml.CreateXmlDeclaration("1.0","utf-8",$null)
$contactsXml.AppendChild($decl) | Out-Null
$contactsRoot = $contactsXml.CreateElement("contacts")
$contactsXml.AppendChild($contactsRoot) | Out-Null

foreach ($c in $contacts) {
    $contact = $contactsXml.CreateElement("contact")
    $contact.SetAttribute("name", $c.Name)
    $contact.SetAttribute("number", $c.Number)
    $contactsRoot.AppendChild($contact) | Out-Null
}

$contactsXml.Save($microsipContactsPath)

Write-Host "MicroSIP contacts.xml updated. CSV saved to $csvPath"
Write-Host "Total contacts: $($contacts.Count)"
