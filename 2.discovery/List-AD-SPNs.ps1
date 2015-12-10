# List-AD-SPNs.ps1
# http://www.itadmintools.com/2011/08/list-spns-in-active-directory-using.html
param (
  [string]$svc = $(throw "Dammit Bobby. -svc is required.`nE.g. -svc TERMSRV or MSSQLSvc or WSMAN or HTTP or DNS or LDAP or GC or etc.")
)

$serviceType="$svc"

$SPNS = @{}

$FILTER = "(servicePrincipalName=$serviceType/*)"
$DOMAIN = New-Object System.DirectoryServices.DirectoryEntry
$QUERY = New-Object System.DirectoryServices.DirectorySearcher
$QUERY.SearchRoot = $DOMAIN
$QUERY.PageSize = 1000
$QUERY.Filter = $FILTER
$RESULTS = $QUERY.FindAll()

foreach ($RESULT in $RESULTS){
 $ACCOUNT = $RESULT.GetDirectoryEntry()
 foreach ($SPN in $ACCOUNT.servicePrincipalName.Value){
  if($SPN.contains("$serviceType/")){
   $SPNS[$("$SPN")]=1;
  }
 }
}
 
if ($SPNS.keys | Select-String -Pattern "." -AllMatches) { 
	$SPNS.keys.ToUpper() | Select-String -Pattern "." -AllMatches | Sort-Object | Get-Unique
}
