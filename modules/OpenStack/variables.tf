variable "openstack_user_name" {
    description = "The username for the Tenant."
    default  = "ecg578-TAII"
}

variable "openstack_tenant_name" {
    description = "The name of the Tenant."
    default  = "ecg578-TAII"
}

variable "openstack_auth_url" {
    description = "The endpoint url to connect to OpenStack."
    default  = "https://openstack.di.ual.es:5000/v3"
}

variable "openstack_keypair" {
    description = "The keypair to be used."
    default  = "ecg578-ssh"
}

variable "PASSWORD" {
    default="xxxxxxx"
}


