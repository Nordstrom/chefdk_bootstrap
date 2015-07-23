#
# Copyright (c) 2015 Nordstrom, Inc.
#
#

name             'chefdk_bootstrap'
maintainer       'Nordstrom, Inc.'
maintainer_email 'techcheftm@nordstrom.com'
license          'Apache 2.0'
description      'Bootstrap a developer workstation for local Chef development using the ChefDK'
version          '1.0.3'

supports 'windows'
supports 'mac_os_x'

depends 'windows', '~> 1.37'
depends 'chocolatey', '~> 0.4'
depends 'git', '~> 4.2'
depends 'homebrew', '~> 1.13'

source_url 'https://github.com/Nordstrom/chefdk_bootstrap'
issues_url 'https://github.com/Nordstrom/chefdk_bootstrap/issues'
