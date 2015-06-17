# File::      <tt>init.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: pubkeyfs
#
# Configure and manage pubkeyfs
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of pubkeyfs
#
# == Actions:
#
# Install and configure pubkeyfs
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import pubkeyfs
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'pubkeyfs':
#             ensure => 'present'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class pubkeyfs(
    $ensure      = $pubkeyfs::params::ensure,
    $fstab       = $pubkeyfs::params::fstab,
    $mount_point = $pubkeyfs::params::mount_point,
    $uri         = $pubkeyfs::params::uri,
    $dn          = $pubkeyfs::params::dn,
    $password    = $pubkeyfs::params::password,
    $base        = $pubkeyfs::params::base,
    $key_attr    = $pubkeyfs::params::key_attr
)
inherits pubkeyfs::params
{
    info ("Configuring pubkeyfs (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("pubkeyfs 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ! ($fstab in [ 'yes', 'no' ]) {
        fail("pubkeyfs 'fstab' parameter must be set to either 'yes' or 'no'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include pubkeyfs::common::debian }
        default: {
            fail("Module ${::module_name} is not supported on ${::operatingsystem}")
        }
    }
}
