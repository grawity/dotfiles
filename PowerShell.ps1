# This is the global (Dropbox) profile
# Use:
# . ($dotfile = Resolve-Path "~\Dropbox\.System\Config\PowerShell\Profile.ps1")

$ESC = [char] 0x1B

# All hosts that need an ssh alias
$AllHosts = @("dust", "ember", "land", "myth", "sky", "star", "wind", "wolke")

# Only those hosts that need a non-FQDN stored password for \\foo
$SmbHosts = @("ember", "myth", "wind")

$uk = "utenos-kolegija.lt"
$ukad = "ad.$uk"

$env:PATH += ";$(Resolve-Path ~\Dropbox\Apps\iperf-3.1.3-win32)"

$env:DISPLAY = "localhost:0"
$env:PATH += ";$env:ProgramFiles\VcXsrv"
#Function xauth {& "$env:ProgramFiles\VcXsrv\xauth.exe" $args}

# --- Input ---

Set-PSReadlineKeyHandler -Chord Alt+F4 -Function ViExit
Set-PSReadlineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Chord Ctrl+w -Function BackwardDeleteWord

# Work around PSReadline regression until the next Windows release comes out
# https://github.com/Microsoft/console/issues/282
Set-PSReadlineKeyHandler -Chord Shift+SpaceBar -ScriptBlock {
	[Microsoft.Powershell.PSConsoleReadLine]::Insert(' ')
}

# --- Aliases ---

# Backport Remove-Alias from 6.0+ and add our own similar helpers for env/func.
Function Remove-Alias([Parameter(Mandatory)] $Name) {
	Remove-Item -Path Alias:$Name -ErrorAction Ignore
}
Function Remove-Function([Parameter(Mandatory)] $Name) {
	Remove-Item -Path Function:$Name -ErrorAction Ignore
}

Remove-Item -Path Alias:curl -ErrorAction Ignore
Remove-Item -Path Alias:wget -ErrorAction Ignore
Remove-Item -Path Alias:mount -ErrorAction Ignore

Set-Alias -Name host -Value nslookup
Set-Alias -Name py -Value python
Set-Alias -Name w -Value quser
Set-Alias -Name who -Value qwinsta
Set-Alias -Name which -Value where.exe
Set-Alias -Name far -Value 'C:\Program Files\Far Manager\Far.exe'

Function ad {ssh -q -t star "SILENT=1 . ~/.profile; ad $(AtArgsToString $args)"}
Function cisco($Name) {telnet cisco-${Name}.sym}
Function f($Match) {Get-ChildItem -Filter "*$Match*" -Recurse | select FullName}
Function hostname.bind($Address) {nslookup -cl=chaos -q=txt hostname.bind. $Address}
Function id.server($Address) {nslookup -cl=chaos -q=txt id.server. $Address}
Function irc {ssh -t star "LANG=en_US.UTF-8 tmux attach -t irc"}
Function mkfile($Path, $Size) {fsutil file createnew "$Path" "$Size"}
Function resolve($HostName) {Resolve-DnsName $HostName | ft Name,TTL,Type,Address}
Function wup {winget list --upgrade-available}
Function wupd($Package) {winget upgrade --id $Package}
Function wupi($Package) {winget upgrade --id $Package --interactive}

Function loc([Parameter(ValueFromRemainingArguments)] $Name) {
	dbg "Running: locate $Name"
	@("myth", "ember") | % {
		$rhost = $_
		say (hl "Results on $(bold $rhost):")
		ssh $rhost "locate -Abi $Name | grep -v '/\.old/' | sed `"s:^`$HOME/:~/:`";"
	}
}

Function touch($Name) {
	# touch nonexistent ==> ni foo
	# touch existent    ==> (gi foo).LastWriteTime = date
	$item = if (Test-Path $Name) {Get-Item $Name} else {New-Item $Name}
	$item.LastWriteTime = date
	$item
}

Function kl {~\Dropbox\Projects\kl}
Function klist {& "$env:SystemRoot\System32\klist.exe" $args}
Function kaddhost($HostName) {cmdkey /add:$HostName /user:grawity@NULLROUTE.LT /pass}
Function kdelhost($HostName) {cmdkey /del:$HostName}
Function kgethost($HostName) {cmdkey /list:$HostName}
Function kssh {ssh -o PubkeyAuthentication=no $args}
Function kplink {plink -no-antispoof -noagent $args}

Function pgrep($String) {
	Get-Process | ? { $_.CommandLine -like "*$String*" } | fl Id,Path,CommandLine
}

Function bold($String) {
	"$ESC[1m$String$ESC[22m"
}
Function hl($String) {
	"$ESC[48;5;238m$String$ESC[m"
}
Function hldbg($String) {
	"$ESC[48;5;237m$ESC[95m$String$ESC[m"
}
Function hlerr($String) {
	"$ESC[48;5;237m$ESC[91m$String$ESC[m"
}
Function say($Text) {Write-Information $Text -InformationAction Continue}
Function dbg($Text) {if ($env:DEBUG) {say (hldbg $Text)}}
Function debug($Value) {
	if ($Value) {
		$env:DEBUG = "$Value"
		say (hldbg "Debug mode set to $Value.")
	} else {
		rm Env:\DEBUG -ErrorAction Ignore
		say (hldbg "Debug mode disabled.")
	}
}

# on/at SSH commands

Function AtGetCurrentDir {
	#$wd = Get-Location
	$wd = "$PWD"
	if ($wd.StartsWith("Microsoft.PowerShell.Core\FileSystem::")) {
		$wd = $wd.Substring("Microsoft.PowerShell.Core\FileSystem::".Length)
	}
	return $wd
}

Function AtMapPathToRemote($Directory, $HostName) {
	$wd = "$Directory\"
	if ($wd.StartsWith("Microsoft.PowerShell.Core\FileSystem::")) {
		$wd = $wd.Substring("Microsoft.PowerShell.Core\FileSystem::".Length)
	}
	dbg "Mapping local directory: $wd"
	if ($wd -eq "$HOME\") {
		$child = ""
	} elseif ($wd.StartsWith("$HOME\Dropbox\", "CurrentCultureIgnoreCase")) {
		$child = $wd.Substring("$HOME\".Length)
	} elseif ($wd.StartsWith("$HOME\Music\", "CurrentCultureIgnoreCase")) {
		$child = $wd.Substring("$HOME\".Length)
	} elseif ($wd.StartsWith("$HOME\Pictures\", "CurrentCultureIgnoreCase")) {
		$child = $wd.Substring("$HOME\".Length)
	} elseif ($wd.StartsWith("\\$HostName\Home\", "CurrentCultureIgnoreCase")) {
		$child = $wd.Substring("\\$HostName\Home\".Length)
	} elseif ($wd.StartsWith("\\$HostName\Attic\", "CurrentCultureIgnoreCase")) {
		$child = "Attic/" + $wd.Substring("\\$HostName\Attic\".Length)
	} else {
		$wd = $wd.TrimEnd("\")
		say (hlerr "Current location '$(bold $wd)' cannot be mapped to location on \\$HostName.")
		return $null
	}
	$rpath = $child.TrimEnd("\").Replace("\", "/")
	return $rpath
}

Function AtInvokeShellHere($HostName, $Command) {
	$rpath = AtMapPathToRemote $PWD $HostName
	if ($null -eq $rpath) {
		return
	}
	echo (hl "Current location mapped to '$(bold "${HostName}:$rpath")'.")
	$qpath = $rpath -replace '[$\\"`]', '\$0'
	if (-not $Command) {
		$Command = "bash"
	}
	if ($PSVersionTable.PSVersion.Major -eq 5) {
		# Weird double quoting needed as ssh.exe itself seems to strip the "s
		$Command = "cd \`"$qpath\`" && $Command"
	} else {
		$Command = "cd `"$qpath`" && $Command"
	}
	AtInvokeShell $HostName $Command
}

Function AtInvokeShell($HostName, $Command) {
	if (-not $Command) {
		$Command = "bash"
	}
	# Dust doesn't have the custom pam_env entry for locale, so we need /etc/profile.
	$cmd = ". /etc/profile; SILENT=1 . ~/.profile; $Command"
	dbg "Running command: $cmd"
	ssh -t $HostName "$cmd"
}

Function AtShellQuote($Argument) {
	return '"' + ($Argument -replace '["$`\\]', '\$0') + '"'
}

Function AtQuoteArgv($Arguments) {
	$special = '[\x00-\x20"^%~!@&?*<>|()$`\\=]'
	$Arguments | % {
		if ($_ -match $special) {
			# Deliberately don't escape $ or `, as we
			# want remote expansion to still happen.
			'"' + ($_ -replace '["\\]', '\$0') + '"'
		} else {
			$_
		}
	}
}

Function AtArgsToString($Arguments) {
	$Arguments | % { dbg "Arg: <$_>" }
	if ($Arguments.Length -eq 1) {
		return "$Arguments"
	} else {
		return "$(AtQuoteArgv $Arguments)"
	}
}

Function at($HostName, [Parameter(ValueFromRemainingArguments)] $Command) {
	AtInvokeShellHere $HostName (AtArgsToString $Command)
}

Function on($HostName, [Parameter(ValueFromRemainingArguments)] $Command) {
	say (hlerr "Remote execution on local paths via SMB not (yet?) implemented.")
}

$AllHosts | % {
	Remove-Item -Path Function:$_ -ErrorAction Ignore
	New-Item -Path Function:$_ -Value "AtInvokeShell $_ (AtArgsToString `$args)"
	Remove-Item -Path Function:!$_ -ErrorAction Ignore
	New-Item -Path Function:!$_ -Value "AtInvokeShellHere $_ (AtArgsToString `$args)"
} > $null

# Other random stuff

Function farcolors($Name) {
	$dir = "C:\Program Files\Far Manager\Addons\Colors\Interface"
	if ($name) {
		far /import "$dir\$name.farconfig"
		far
	} else {
		gci 'C:\Program Files\Far Manager\Addons\Colors\Interface\'
	}
}

Function Get-GenericCredential($Name) {
	$cred = Get-StoredCredential -Target $name
	if ($cred) {
		return $cred
	}
	$cred = Get-Credential -Message "Enter credentials for ${name}:"
	if ($cred) {
		New-StoredCredential `
			-Target $name `
			-Type Generic `
			-Credential $cred `
			-Persist LocalMachine `
			| Out-Null
		return $cred
	}
}

Function Store-KerberosPassword {
	# Install-Module -Name CredentialManager
	$princ = "grawity@NULLROUTE.LT"

	$cred = Get-Credential -Username "$princ" -Message "Enter Kerberos credentials:"
	#$cred = $cred.GetNetworkCredential()
	#$SmbHosts | ForEach-Object {
	#	cmdkey /add:"$_" /user:"$($cred.UserName)" /pass:"$($cred.Password)"
	#}
	$SmbHosts | ForEach-Object {
		New-StoredCredential `
			-Target $_ `
			-Type DomainPassword `
			-Credential $cred `
			-Persist Enterprise
	} | Format-Table Type,TargetName,UserName,Persist
}

Function ukcred {
	# Install-Module -Name CredentialManager
	# Note: Unfortunately, Domain (NTLM) credentials cannot be used with
	#       New-PSSession, as it expects a PSCredential object.
	Get-GenericCredential "Utenos kolegija"
}

Function ukrsh($HostName) {
	Enter-PSSession "$HostName.utenos-kolegija.lt" -Credential (ukcred) -Authentication Kerberos
}

Function Get-Token {
	[System.Security.Principal.WindowsIdentity]::GetCurrent()
}

Function Test-IsElevated {
	$me = [Security.Principal.WindowsIdentity]::GetCurrent()
	#$me = New-Object Security.Principal.WindowsPrincipal($me)
	$me = [Security.Principal.WindowsPrincipal]$me
	return $me.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Function Ping-DNS($af) {
	$dns = (Get-NetIPConfiguration -InterfaceAlias Ethernet).DNSServer
	if ($af -eq "-4") {
		$dns = $dns | ? {$_.AddressFamily -eq 2}
	} elseif ($af -eq "-6") {
		$dns = $dns | ? {$_.AddressFamily -eq 23}
	}
	$dns = $dns.ServerAddresses[0]
	ping -t $dns
}

Function MoveTo-Attic($File) {
	$year = (Get-Item $File).LastWriteTime.Year
	$dest = "\\myth\Home\Attic\Misc\$year\"
	Write-Host "Moving '$File' to '$dest'"
	Move-Item $File $dest
}

Function rpw(
	[int] $Length=20,
	[switch] $LowerCase,
	[switch] $Symbols,
	[switch] $CopyToClipboard
) {
	$alphabet = "0123456789"
	$alphabet += "abcdefghijklmnopqrstuvwxyz"
	if (-not $LowerCase) {
		$alphabet += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	}
	if ($Symbols) {
		$alphabet += "/.,+-!#=_@"
	}
	$alphabet = $alphabet.ToCharArray()
	$buf = ""
	for ($i = 0; $i -lt [math]::Abs($Length); $i++) {
		if ($Length -gt 0 -and $i -gt 0 -and $i % 5 -eq 0) {
			$buf += "-"
		}
		$buf += $alphabet | Get-Random
	}
	if ($CopyToClipboard) {
		$buf | Set-Clipboard
	}
	return $buf
}

# --- Prompt ---

# Prompt() is called every time the prompt is shown, returns a string.
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_prompts

Function Shorten-Path($Path) {
	# If we're passed a PathInfo, make sure to stringify it.
	$Path = "$Path"
	$lpath = $Path.ToLower()
	$lhome = $HOME.ToLower()
	if ($lpath -eq $lhome) {
		return $HOME
	} elseif ($lpath.StartsWith("$lhome\")) {
		return "~\" + $Path.Substring("$HOME\".Length)
	} else {
		return "$Path"
	}
}

# https://learn.microsoft.com/en-us/windows/terminal/tutorials/shell-integration
$Global:__LastHistoryId = -1
function Global:__Terminal-Get-LastExitCode {
	if ($? -eq $True) {
		return 0
	}
	$LastHistoryEntry = Get-History -Count 1
	$IsPowerShellError = $Error[0].InvocationInfo.HistoryId -eq $LastHistoryEntry.Id
	if ($IsPowerShellError) {
		return -1
	}
	return $LastExitCode
}

Function Prompt {
	# [1]: https://github.com/microsoft/terminal/issues/11000
	#      https://devblogs.microsoft.com/commandline/shell-integration-in-the-windows-terminal/
	$ft_prompt   = "$ESC]133;A$ESC\"
	$ft_cmdstart = "$ESC]133;B$ESC\"
	$ft_cmdexec  = "$ESC]133;C$ESC\"
	$ft_cmdsucc  = "$ESC]133;D;0$ESC\"
	$ft_cmdfail  = "$ESC]133;D;1$ESC\"

	# https://learn.microsoft.com/en-us/windows/terminal/tutorials/shell-integration
	$gle = __Terminal-Get-LastExitCode

	$rawcwd = AtGetCurrentDir
	# Replace $env:USERPROFILE with ~\
	$cwd = Shorten-Path $rawcwd

	$ver = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
	$dbg = if (Test-Path variable:/PSDebugContext) {"[DBG]: "}
	$nest = if ($NestedPromptLevel -ge 1) {" >>"}

	$out = ""
	$BEL = [char] 0x07

	# End of command output (
	$LastHistoryEntry = Get-History -Count 1
	if ($Global:__LastHistoryId -ne -1) {
		# Don't provide a command line or exit code if there was no history entry (eg. ctrl+c, enter on no command)
		if ($LastHistoryEntry.Id -eq $Global:__LastHistoryId) {
			$out += "$ESC]133;D$ESC\"
		} else {
			$out += "$ESC]133;D;$gle$ESC\"
		}
	}
	$Global:__LastHistoryId = $LastHistoryEntry.Id

	# Start of prompt (FinalTerm [1])
	$out += "$ESC]133;A$ESC\"
	# Current path
	$out += "$ESC]9;9;${rawcwd}$ESC\"
	# Prompt
	$out += "$ESC[90m{$ESC[m"
	$out += "$ESC[34m$ver $ESC[m"
	$out += "$ESC[97m$cwd$ESC[m"
	$out += "$ESC[90m}$ESC[m"
	$out += "$nest"
	$out += if (Test-IsElevated) {" #> "} else {" > "}
	# End of prompt (start of command)
	$out += "$ESC]133;B$ESC\"
	return $out
}

if ((AtGetCurrentDir).StartsWith("\\myth\", "CurrentCultureIgnoreCase")) {
	AtInvokeShellHere "myth"
}