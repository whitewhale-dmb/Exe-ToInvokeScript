# Exe-ToInvokeScript.ps1
This Powershell script will take an EXE and compress and base-64 encode it within a Powershell script, allowing it to be extracted and executed directly in-memory, based on the technique used for Invoke-Mimikatz, Invoke-Rubeus, etc.

# Use
Create a Powershell-invoked version of an EXE:

```
./Exe-ToInvokeScript.ps1 -InFile <file.exe> -OutFile ./Invoke-File.ps1
```
