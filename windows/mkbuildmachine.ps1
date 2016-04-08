param
(
  [string]$mirror = "",
  [string]$workdir = $env:temp,
  [string]$package
)

function Handle($p) {
  if (&('Test-'+$p)) {
    Write-Host "$p no action needed"
  } else {
    Write-Host "$p missing"
    &('Install-'+$p)
  }
}

$ErrorActionPreference = "Stop"

if ($workdir -ne $env:temp) {
  if (-Not (Test-Path $workdir)) {
     mkdir $workdir
  }
  $env:temp = $workdir
}

Start-Transcript -Append -Path ($env:temp+'\mkbuildmachine.log')

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $ScriptDir\PackageLibrary.psm1 -ArgumentList $mirror

if ($package) {
  Handle($package)
  Write-Host "$package package successfully installed"
} else {
  foreach ($p in (Get-Packages)) {
    Handle($p)
  }
  Write-Host "Default packages successfully installed"
  exit 0
}

