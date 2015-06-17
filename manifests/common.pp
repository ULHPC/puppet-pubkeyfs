# File::      <tt>common.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
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
    vcsrepo { 'git-pubkeyfs':
        ensure   => $pubkeyfs::ensure,
        provider => git,
        user     => $pubkeyfs::params::install_user,
        path     => $pubkeyfs::params::build_dir,
        source   => $pubkeyfs::params::git_url,
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
        ensure => $pubkeyfs::ensure,
        name   => $pubkeyfs::params::fuse_packagename
    }
    include kernel
    kernel::module { 'fuse':
        ensure  => $pubkeyfs::ensure
    }

    if $pubkeyfs::ensure == 'present' {
        $mount_ensure = $pubkeyfs::fstab ? {
            'yes'   => 'mounted',
            default => 'absent'
        }

        Package[$pubkeyfs::params::fuse_packagename] -> Kernel::Module['fuse']
        Kernel::Module['fuse'] -> File[$pubkeyfs::mount_point]

        if ($pubkeyfs::fstab == 'yes') {
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
          require => [ Vcsrepo['git-pubkeyfs'], File[$pubkeyfs::mount_point]]
        }

        Exec['install_pkfs'] -> Mount[$pubkeyfs::mount_point]
    }
    else
    {
        $mount_ensure = 'absent'

        exec { 'remove_pkfs':
          path    => '/sbin:/usr/bin:/usr/sbin:/bin',
          command => "rm -f ${pubkeyfs::params::installdir}/bin/${pubkeyfs::params::processname}",
          unless  => "test ! -f ${pubkeyfs::params::installdir}/bin/${pubkeyfs::params::processname}",
          user    => $pubkeyfs::params::install_user,
          group   => $pubkeyfs::params::install_group
        }
    }

    mount { $pubkeyfs::mount_point:
        ensure   => $mount_ensure,
        device   => "${pubkeyfs::params::installdir}/bin/${pubkeyfs::params::processname}",
        fstype   => 'fuse',
        options  => 'allow_other',
        atboot   => true,
        remounts => false
    }


}
