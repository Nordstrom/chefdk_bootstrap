echo "Starting chefdk_bootstrap_nord bootstrap..."

echo "Setting up proxy environment variables..."
$env:http_proxy='http://webproxysea.nordstrom.net:8181'
$env:https_proxy=$env:http_proxy
$env:no_proxy='localhost,127.0.0.1,nordstrom.net'

# Send these attributes into the bootstrap to be passed into chef-client
$CHEFDK_BOOTSTRAP_JSON_ATTRIBUTES = "https://git.nordstrom.net/projects/CHF/repos/chefdk_bootstrap_nord/browse/attributes.json?raw"
$CHEFDK_BOOTSTRAP_RAW = "https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/bootstrap.ps1"
$CHEFDK_VERSION = "2.4.17"
echo "Starting chefdk_bootstrap..."
Invoke-WebRequest -UseBasicParsing $CHEFDK_BOOTSTRAP_RAW -ProxyUseDefaultCredentials -Proxy $env:https_proxy | Invoke-Expression
install -json_attributes $CHEFDK_BOOTSTRAP_JSON_ATTRIBUTES -version $CHEFDK_VERSION

# Check to see if the .chef folder exists and already has files in it
if (Test-Path $env:USERPROFILE\.chef\*) {
  echo "Chef configuration appears to already be set up."
}
else {
  echo "Configuring chef..."
  echo "(You may be prompted for your password to access git.nordstrom.net)"
  # Add git to the path in case it was freshly installed
  $env:PATH += ';C:\Program Files\Git\cmd'
  git clone https://$env:USERNAME@git.nordstrom.net/scm/chf/dotchef.git $env:USERPROFILE\.chef
}
