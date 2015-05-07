#
# Copyright (c) 2015 Nordstrom, Inc.
#

require 'spec_helper'

# this is a generic ServerSpec test.  It just runs 'whoami'
# and confirms that it returns 'root'.  In a real test suite,
# you would want to test things like directories, users,
# processes, services, etc.
#
# for more information on the things ServerSpec can test, refer
# to the documentation at http://serverspec.org
describe command('whoami') do
  its(:stdout) { should eq "root\n" }
end
