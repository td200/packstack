class packstack::ironic ()
{
    create_resources(packstack::firewall, hiera('FIREWALL_IRONIC_API_RULES', {}))

    ironic_config {
      'glance/glance_host': value => hiera('CONFIG_STORAGE_HOST_URL');
    }

    class { '::ironic::api::authtoken':
      auth_uri => hiera('CONFIG_KEYSTONE_PUBLIC_URL'),
      password => hiera('CONFIG_IRONIC_KS_PW'),
    }

    class { '::ironic::api': }

    class { '::ironic::client': }

    #Enable pxe_ssh
    class { '::ironic::conductor':
      enabled_drivers => ['pxe_ipmitool','pxe_ssh'],
    }

    #Enable iPXE
    class { '::ironic::drivers::pxe':
       ipxe_enabled => true,
       ipxe_timeout => 60,
    }

    # Configure access to other services
    #include ::ironic::cinder
    include ::ironic::drivers::inspector
    include ::ironic::glance
    include ::ironic::neutron
    #include ::ironic::service_catalog
    #include ::ironic::swift

     class { '::ironic::inspector::authtoken':
       auth_uri => hiera('CONFIG_KEYSTONE_PUBLIC_URL'),
       password => hiera('CONFIG_IRONIC_KS_PW'),
     }
}
