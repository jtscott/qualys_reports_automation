#bypass certificate trust for fiddler
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

#api setup
$username = "CHANGEME"
$password = "CHANGEME"
$headers = @{"X-Requested-With"="powershell"} #Create a hashtable with all the necessary headers

[xml]$xml_login = Invoke-RestMethod -Headers $headers -SessionVariable QualysSession -Uri "https://qualysapi.qualys.com/api/2.0/fo/session/?action=login&username=$username&password=$password" -Method Post -Proxy http://127.0.0.1:8888
$xml_login_status = $xml_login.simple_return.response.text
Write-Host Qualys login status: $xml_login_status


[xml]$xml_logout = Invoke-RestMethod -Headers $headers -WebSession $QualysSession -Uri "https://qualysapi.qualys.com/api/2.0/fo/session/?action=logout" -Method Post -Proxy http://127.0.0.1:8888
$xml_logout_status = $xml_logout.simple_return.response.text
Write-Host Qualys logout status: $xml_logout_status