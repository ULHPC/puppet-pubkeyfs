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

$names = ['ensure', 'fstab', 'mount_point', 'uri', 'base', 'dn', 'password', 'key_attr', 'git_url', 'build_dir', 'fuse_packagename', 'makedep', 'installdir', 'processname', 'configfile', 'configfile_mode', 'configfile_owner', 'configfile_group', 'install_user', 'install_group']

notice("pubkeyfs::params::ensure = ${pubkeyfs::params::ensure}")
notice("pubkeyfs::params::fstab = ${pubkeyfs::params::fstab}")
notice("pubkeyfs::params::mount_point = ${pubkeyfs::params::mount_point}")
notice("pubkeyfs::params::uri = ${pubkeyfs::params::uri}")
notice("pubkeyfs::params::base = ${pubkeyfs::params::base}")
notice("pubkeyfs::params::dn = ${pubkeyfs::params::dn}")
notice("pubkeyfs::params::password = ${pubkeyfs::params::password}")
notice("pubkeyfs::params::key_attr = ${pubkeyfs::params::key_attr}")
notice("pubkeyfs::params::git_url = ${pubkeyfs::params::git_url}")
notice("pubkeyfs::params::build_dir = ${pubkeyfs::params::build_dir}")
notice("pubkeyfs::params::fuse_packagename = ${pubkeyfs::params::fuse_packagename}")
notice("pubkeyfs::params::makedep = ${pubkeyfs::params::makedep}")
notice("pubkeyfs::params::installdir = ${pubkeyfs::params::installdir}")
notice("pubkeyfs::params::processname = ${pubkeyfs::params::processname}")
notice("pubkeyfs::params::configfile = ${pubkeyfs::params::configfile}")
notice("pubkeyfs::params::configfile_mode = ${pubkeyfs::params::configfile_mode}")
notice("pubkeyfs::params::configfile_owner = ${pubkeyfs::params::configfile_owner}")
notice("pubkeyfs::params::configfile_group = ${pubkeyfs::params::configfile_group}")
notice("pubkeyfs::params::install_user = ${pubkeyfs::params::install_user}")
notice("pubkeyfs::params::install_group = ${pubkeyfs::params::install_group}")

#each($names) |$v| {
#    $var = "pubkeyfs::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
