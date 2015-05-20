#
# Copyright (c) 2015 Nordstrom, Inc.
#
#

name             'chefdk_bootstrap'
maintainer       'Nordstrom, Inc.'
maintainer_email 'techcheftm@nordstrom.com'
license          'Apache 2.0'
description      'Bootstrap a developer workstation for local Chef development using the ChefDK'
version          '0.1.1'

supports 'windows'

depends 'chocolatey', '~> 0.3'
depends 'git', '~> 4.2'

source_url 'https://github.com/Nordstrom/chefdk_bootstrap'
issues_url 'https://github.com/Nordstrom/chefdk_bootstrap/issues'
