#-------------------------------------------------------------------------------------#
#  This power shell script will help configure the git configuration settings         #
#-------------------------------------------------------------------------------------#
param([String]$name)
param([String]$email)

function isSuccess {
	param([String]$property = "unknown")
	if($?) {
		"Config $property... is updated"
	}
	else {
		"Config $property... is not updated"
	}
}

git config --global user.name "$name"
isSuccess -property user.name
git config --global user.email "$email"
isSuccess -property user.email
git config --global http.proxy http://165.225.104.34:9480
isSuccess -property http.proxy
git config --global https.proxy http://165.225.104.34:9480
isSuccess -property https.proxy
