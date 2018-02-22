# chefdk_bootstrap_nord

Here are some development notes to help with maintenance and enhancments.

#### Nordstrom Certificate Bundle

* Source URL
https://confluence.nordstrom.net/display/PKI/Download+Certificate+Chains+-+Nordstrom+Root+and+Issuing+CA+chain+downloads
Download all of the SHA2 certs. Convert to a concatenated pem file.

* Create the bundle to include in the yml attributes file
I ran something along the lines of this script against a .cer file to replace the newlines in prep for
adding the cert to the yml attribute file.

#!/opt/chefdk/embedded/bin/ruby
inp = STDIN.read
puts inp.gsub(/\n/, "\\n")

