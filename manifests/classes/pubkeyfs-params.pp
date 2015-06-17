# File::      <tt>pubkeyfs-params.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: pubkeyfs::params
#
# In this class are defined as variables values that are used in other
# pubkeyfs classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class pubkeyfs::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of pubkeyfs
    $ensure = $::pubkeyfs_ensure ? {
        ''      => 'present',
        default => $::pubkeyfs_ensure
    }

    # add a pubkeyfs line in /etc/fstab
    $fstab = $::pubkeyfs_fstab ? {
        ''      => 'yes',
        default => $::pubkeyfs_fstab
    }

    # mount_point
    $mount_point = $::pubkeyfs_mount_point ? {
        ''      => '/var/lib/publickeys',
        default => $::pubkeyfs_mount_point
    }

    # URI
    $uri = $::pubkeyfs_uri ? {
        ''      => 'ldaps://hpc-ldap.uni.lux',
        default => $::pubkeyfs_uri
    }

    # base
    $base = $::pubkeyfs_base ? {
        ''      => 'dc=uni,dc=lu',
        default => $::pubkeyfs_base
    }

    # dn
    $dn = $::pubkeyfs_dn ? {
        ''      => 'cn=admin,dc=uni,dc=lu',
        default => $::pubkeyfs_dn
    }

    # password
    $password = $::pubkeyfs_password ? {
        ''      => 'secret_password',
        default => $::pubkeyfs_password
    }

    # ldap ssh pub key attribute
    $key_attr = $::pubkeyfs_key_attr ? {
        ''      => 'sshPublicKey',
        default => $::pubkeyfs_key_attr
    }


    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    # pubkeyfs packages

    $git_url = 'https://github.com/kelseyhightower/pubkeyfs.git'

    $build_dir = '/root/pubkeyfs'

    $fuse_packagename = $::operatingsystem ? {
        default => [ 'fuse'],
    }

    $makedep = $::operatingsystem ? {
        default => 'clang libfuse-dev libconfig-dev libldap2-dev',
    }

    $installdir = $::operatingsystem ? {
        default => '/usr/local/',
    }

    $processname = $::operatingsystem ? {
        default => 'pkfs',
    }

    $configfile = $::operatingsystem ? {
        default => '/etc/pkfs.conf',
    }
    $configfile_mode = $::operatingsystem ? {
        default => '0600',
    }
    $configfile_owner = $::operatingsystem ? {
        default => 'root',
    }
    $configfile_group = $::operatingsystem ? {
        default => 'root',
    }

    $install_user = $::operatingsystem ? {
        default => 'root',
    }
    $install_group = $::operatingsystem ? {
        default => 'root',
    }

}

