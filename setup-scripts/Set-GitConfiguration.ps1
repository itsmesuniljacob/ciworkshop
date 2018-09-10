$reply = Read-Host -Prompt "This script will add git configuration settings globally. Continue?[y/n]"
if($reply -match "[yY]") {
	param([String]$name,[String]$email)
	$path = @('user.name','user.email','http.proxy','https.proxy')
	$inp = @($name,$email,$proxy,$proxy)
	function isSuccess {
		param([String]$property = "unknown")
		if($?) {
			"Config $property... is updated"
		}
		else {
			"Config $property... is not updated"
			Exit
		}
	}

	$i=0
	do {
			Foreach ($p in $path) {
				git config --global $p $inp[$i]
				isSuccess -property $p
				$i++
			}
	} while ($i -lt 4)
} else {
	"Script aborted"
}
