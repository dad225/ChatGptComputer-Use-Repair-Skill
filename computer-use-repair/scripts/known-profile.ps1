[CmdletBinding()]
param([ValidateSet('Status','Install','Rollback')][string]$Mode='Status')
$ErrorActionPreference='Stop'
$patch='C:\Users\Administrator\.codex\desktop-control-audit\20261030-49C7F43D\patch-local-0.7.13.ps1'
if((Get-FileHash -LiteralPath $patch -Algorithm SHA256).Hash -ne '708B2527ADC3C2076B04E1EADE541A86D847E7B1AF442D063DA2A1D15A25136E'){throw 'Reviewed installer hash mismatch; refuse execution'}
& $patch -Mode $Mode
