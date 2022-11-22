# This is the global (Dropbox) profile
# Use:
# . ($dotfile = Resolve-Path "~\Dropbox\.System\Config\PowerShell\Profile.ps1")

$ESC = [char] 0x1B

$uk = "utenos-kolegija.lt"
$ukad = "ad.$uk"

$env:PATH += ";$(Resolve-Path ~\Dropbox\Apps\iperf-3.1.3-win32)"

$env:DISPLAY = "localhost:0"

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

# Remove-Alias is a 6.0 addition
Function Remove-Alias($Name) {Remove-Item -Path Alias:$name -ErrorAction Ignore}
Remove-Item -Path Alias:curl -ErrorAction Ignore
Remove-Item -Path Alias:wget -ErrorAction Ignore
Remove-Item -Path Alias:mount -ErrorAction Ignore

Set-Alias -Name host -Value nslookup
Set-Alias -Name py -Value python
Set-Alias -Name w -Value quser
Set-Alias -Name who -Value qwinsta
Set-Alias -Name which -Value where.exe
Set-Alias -Name far -Value 'C:\Program Files\Far Manager\Far.exe'

# touch nonexistent ==>  ni foo; New-Item foo
# touch existent    ==>  (gi foo).LastWriteTime = date

Function ad {ssh -q -t star "SILENT=1 . ~/.profile; ad $args"}
Function f($Match) {Get-ChildItem -Filter "*$Match*" -Recurse | select FullName}
Function hostname.bind($Address) {nslookup -cl=chaos -q=txt hostname.bind. $Address}
Function id.server($Address) {nslookup -cl=chaos -q=txt id.server. $Address}
Function irc {ssh -t star "LANG=en_US.UTF-8 tmux attach -t irc"}
Function resolve($HostName) {Resolve-DnsName $HostName | ft Name,TTL,Type,Address}

Function kl {~\Dropbox\Projects\kl}
Function klist {& "$env:SystemRoot\System32\klist.exe" $args}
Function kaddhost($HostName) {cmdkey /add:$HostName /user:grawity@NULLROUTE.LT /pass}
Function kdelhost($HostName) {cmdkey /del:$HostName}
Function kgethost($HostName) {cmdkey /list:$HostName}
Function kssh {ssh -o PubkeyAuthentication=no $args}
Function kplink {plink -no-antispoof -noagent $args}

Function hl($String) {
	"$ESC[48;5;238m$String$ESC[m"
}
Function hlerr($String) {
	"$ESC[48;5;237m$ESC[91m$String$ESC[m"
}

Function at($HostName) {
	#$dropbox = Resolve-Path -LiteralPath "~\Dropbox"
	$wd = "$PWD\"
	$IC = "CurrentCultureIgnoreCase"
	if ($wd.StartsWith("Microsoft.PowerShell.Core\FileSystem::")) {
		$wd = $wd.Substring("Microsoft.PowerShell.Core\FileSystem::".Length)
	}
	if ($wd.StartsWith("$HOME\Dropbox\", $IC)) {
		$child = $wd.Substring("$HOME\".Length)
	} elseif ($wd.StartsWith("$HOME\Music\", $IC)) {
		$child = $wd.Substring("$HOME\".Length)
	} elseif ($wd.StartsWith("$HOME\Pictures\", $IC)) {
		$child = $wd.Substring("$HOME\".Length)
	} elseif ($wd.StartsWith("\\$HostName\Home\", $IC)) {
		$child = $wd.Substring("\\$HostName\Home\".Length)
	} else {
		echo (hlerr "Current location '$wd' cannot be mapped to location on \\$HostName.")
		return
	}
	$rpath = $child.Replace("\", "/")
	echo (hl "Current location mapped to '${HostName}:$rpath'")
	$qpath = $rpath -replace '[$\\"`]', '\$0'
	# Weird double quoting needed as ssh.exe itself seems to strip the "s
	$cmd = "export SILENT=1; cd \`"$qpath\`" && bash"
	ssh -t $HostName "$cmd"
}

# All hosts that need an ssh alias
$AllHosts = @("ember", "land", "myth", "sky", "star", "wind", "wolke")
# Only those hosts that need a non-FQDN stored password for \\foo
$SmbHosts = @("ember", "myth", "wind")

$AllHosts | % {
	Remove-Item -Path Function:$_ -ErrorAction Ignore
	New-Item -Path Function:$_ -Value "ssh $_ `$args"
	Remove-Item -Path Function:!$_ -ErrorAction Ignore
	New-Item -Path Function:!$_ -Value "at $_ `$args"
} > $null

Function farcolors {
	Param($name)
	$dir = "C:\Program Files\Far Manager\Addons\Colors\Interface"
	if ($name) {
		far /import "$dir\$name.farconfig"
		far
	} else {
		gci 'C:\Program Files\Far Manager\Addons\Colors\Interface\'
	}
}

Function Get-GenericCredential {
	Param($name)
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

Function ukrsh {
	Param($HostName)
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

Function Ping-DNS {
	Param($af)
	$dns = (Get-NetIPConfiguration -InterfaceAlias Ethernet).DNSServer
	if ($af -eq "-4") {
		$dns = $dns | ? {$_.AddressFamily -eq 2}
	} elseif ($af -eq "-6") {
		$dns = $dns | ? {$_.AddressFamily -eq 23}
	}
	$dns = $dns.ServerAddresses[0]
	ping -t $dns
}

Function MoveTo-Attic {
	Param($File)
	$year = (Get-Item $File).LastWriteTime.Year
	$dest = "\\myth\Home\Attic\Misc\$year\"
	Write-Host "Moving '$File' to '$dest'"
	Move-Item $File $dest
}

# --- Prompt ---

# Prompt() is called every time the prompt is shown, returns a string.
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_prompts

Function Shorten-Path {
	Param($path)
	# If we're passed a PathInfo, make sure to stringify it.
	$path = "$path"
	$lpath = $path.ToLower()
	$lhome = $home.ToLower()
	if ($lpath -eq $lhome) {
		return $HOME
	} elseif ($lpath.StartsWith("$lhome\")) {
		return "~\" + $path.Substring("$HOME\".Length)
	} else {
		return "$path"
	}
}

Function Prompt {
	$ver = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
	$wd = Shorten-Path (Get-Location)
	$dbg = "$(if (Test-Path variable:/PSDebugContext) {'[DBG]: '})"
	$nest = "$(if ($NestedPromptLevel -ge 1) {' >>'})"
	# $dbg and $nest come from the default Prompt() function

	$wd = $wd -replace "^Microsoft\.PowerShell\.Core\\FileSystem::\\\\", "\\"

	#return "$($dbg)PS($($ver)) $($wd)$($nest)> "

	Write-Host -NoNewLine -ForegroundColor DarkGray	"{"
	#Write-Host -NoNewLine -ForegroundColor Blue	"PS $($ver) "
	Write-Host -NoNewLine -ForegroundColor White	"$($wd)"
	Write-Host -NoNewLine -ForegroundColor DarkGray	"}"
	Write-Host -NoNewLine -ForegroundColor White	"$($nest)"
	# PowerShell generally assumes the prompt will always end with "> "
	# and will sometimes overdraw it (e.g. when in "quoted string" mode).
	return " > "
}
