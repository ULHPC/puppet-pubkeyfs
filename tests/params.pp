# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'pubkeyfs::params'

$names = ["ensure", "protocol", "port", "packagename"]

notice("pubkeyfs::params::ensure = ${pubkeyfs::params::ensure}")
notice("pubkeyfs::params::protocol = ${pubkeyfs::params::protocol}")
notice("pubkeyfs::params::port = ${pubkeyfs::params::port}")
notice("pubkeyfs::params::packagename = ${pubkeyfs::params::packagename}")

#each($names) |$v| {
#    $var = "pubkeyfs::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
