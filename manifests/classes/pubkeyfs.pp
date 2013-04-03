# File::      <tt>pubkeyfs.pp</tt>
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
        debian, ubuntu:         { include pubkeyfs::debian }
        default: {
            fail("Module ${::module_name} is not supported on ${::operatingsystem}")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: pubkeyfs::common
#
# Base class to be inherited by the other pubkeyfs classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class pubkeyfs::common {

    # Load the variables used in this module. Check the pubkeyfs-params.pp file
    require pubkeyfs::params

    # Configuration file
    file { $pubkeyfs::params::configfile:
        ensure  => $pubkeyfs::ensure,
        path    => $pubkeyfs::params::configfile,
        owner   => $pubkeyfs::params::configfile_owner,
        group   => $pubkeyfs::params::configfile_group,
        mode    => $pubkeyfs::params::configfile_mode,
        content => template('pubkeyfs/pkfs.conf.erb')
    }

    # git clone
    git::clone { 'git-pubkeyfs':
        ensure    => $pubkeyfs::ensure,
        path      => $pubkeyfs::params::build_dir,
        source    => $pubkeyfs::params::git_url,
        user      => $pubkeyfs::params::install_user
    }


    $mount_ensure = $pubkeyfs::fstab ? {
        'yes'   => 'mounted',
        default => 'absent'
    }
    mount { $pubkeyfs::mount_point:
        ensure   => $mount_ensure,
        device   => "${pubkeyfs::params::installdir}/bin/${pubkeyfs::params::processname}",
        fstype   => 'fuse',
        options  => 'allow_other',
        atboot   => true,
        remounts => false
    }

    $mount_point_ensure = $pubkeyfs::ensure ? {
        'present' => 'directory',
        default   => 'absent',
    }
    file { $pubkeyfs::mount_point:
        ensure => $mount_point_ensure,
        owner  => $pubkeyfs::params::install_user,
        group  => $pubkeyfs::params::install_group
    }

    # module fuse

    package { $pubkeyfs::params::fuse_packagename:
        ensure  => $pubkeyfs::ensure,
        name    => $pubkeyfs::params::fuse_packagename
    }
    include kernel
    kernel::module { 'fuse':
        ensure  => $pubkeyfs::ensure
    }

    if $pubkeyfs::ensure == 'present' {
        Package[$pubkeyfs::params::fuse_packagename] -> Kernel::Module['fuse']
        Kernel::Module['fuse'] -> File[$pubkeyfs::mount_point]

        if ($fstab == 'yes') {
          File[$pubkeyfs::mount_point] -> Mount[$pubkeyfs::mount_point]
        }

        exec { 'install_pkfs':
          path    => '/sbin:/usr/bin:/usr/sbin:/bin',
          command => "apt-get install -y ${pubkeyfs::params::makedep} ;
                      cd ${pubkeyfs::params::build_dir} ;
                      sed -i 's/gcc/clang/' Makefile ;
                      make install PREFIX=${pubkeyfs::params::installdir} ;
                      git checkout Makefile ;
                      apt-get purge -y ${pubkeyfs::params::makedep}",
          unless  => "test -f ${pubkeyfs::params::installdir}/bin/${pubkeyfs::params::processname}",
          user    => $pubkeyfs::params::install_user,
          group   => $pubkeyfs::params::install_group,
          require => Git::Clone['git-pubkeyfs']
        }

        Exec['install_pkfs'] -> Mount[$pubkeyfs::mount_point]
    }
    else
    {
        exec { 'remove_pkfs':
          path    => '/sbin:/usr/bin:/usr/sbin:/bin',
          command => "rm -f ${pubkeyfs::params::installdir}/bin/${pubkeyfs::params::processname}",
          unless  => "test ! -f ${pubkeyfs::params::installdir}/bin/${pubkeyfs::params::processname}",
          user    => $pubkeyfs::params::install_user,
          group   => $pubkeyfs::params::install_group
        }
    }

}


# ------------------------------------------------------------------------------
# = Class: pubkeyfs::debian
#
# Specialization class for Debian systems
class pubkeyfs::debian inherits pubkeyfs::common { }

