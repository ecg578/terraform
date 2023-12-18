# Crear nodo mysql
resource "openstack_compute_instance_v2" "mysql" {

  name              = "mysql"
  image_name        = "jammy"
  availability_zone = "nova"
  flavor_name       = "medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default","ssh", "HTTP"]
  network {
    name = "ecg578-net" 
  }
  user_data = file("install_mysql.sh")
}

# Creacion ip flotante
resource "openstack_networking_floatingip_v2" "mysql_ip" { 
  pool = "externa"
}

# Asociación de la IP flotante a la instancia
# Acceso a la dirección del recurso IP flotante creado
# Acceso al id la instancia creada
resource "openstack_compute_floatingip_associate_v2" "mysql_ip" { 

  floating_ip = openstack_networking_floatingip_v2.mysql_ip.address 
  instance_id = openstack_compute_instance_v2.mysql.id 
}


# Configura el archivo de plantilla para la API
data "template_file" "setup-api-docker" {

  template = file("setup-api-docker.tpl")
  vars = {
    mysql_ip = openstack_compute_instance_v2.mysql.network.0.fixed_ip_v4
  }
  depends_on = [openstack_compute_instance_v2.mysql]
}

# Espera 5 minutos a que se configure la instancia MySQL
# para que no falle el contenedor de la API al conectar a la BD
resource "time_sleep" "wait_5_minutes" {

  depends_on = [openstack_compute_instance_v2.mysql]
  create_duration = "5m"
}

#Crear nodo API
resource "openstack_compute_instance_v2" "book_api" {
  name              = "book_api"
  image_name        = "jammy"
  availability_zone = "nova"
  flavor_name       = "medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default","ssh", "HTTP"]
  network {
    name = "ecg578-net" 
  }
  user_data = data.template_file.setup-api-docker.rendered

  depends_on = [time_sleep.wait_5_minutes ]
}

# Creacion ip flotante
resource "openstack_networking_floatingip_v2" "book_api_ip" { 
  pool = "externa"
}

resource "openstack_compute_floatingip_associate_v2" "book_api_ip" { 

  floating_ip = openstack_networking_floatingip_v2.book_api_ip.address 
  instance_id = openstack_compute_instance_v2.book_api.id 
}



# Configura el archivo de plantilla para la aplicación
data "template_file" "setup-app-docker" {
  template = file("setup-app-docker.tpl")
  vars = {
    book_api_ip = openstack_compute_instance_v2.book_api.network.0.fixed_ip_v4
  }
  depends_on = [openstack_compute_instance_v2.book_api]
}

#Crear nodo APP
resource "openstack_compute_instance_v2" "book_app" {

  name              = "book_app"
  image_name        = "jammy"
  availability_zone = "nova"
  flavor_name       = "medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default","ssh", "HTTP"]
  network {
  name = "ecg578-net" 
  }
  user_data = data.template_file.setup-app-docker.rendered
}


# Creacion ip flotante
resource "openstack_networking_floatingip_v2" "book_app_ip" { 
  pool = "externa"
}

resource "openstack_compute_floatingip_associate_v2" "book_app_ip" { 

  floating_ip = openstack_networking_floatingip_v2.book_app_ip.address 
  instance_id = openstack_compute_instance_v2.book_app.id 
}



# Acceso a la dirección del recurso IP flotante creado
# Esperar a que esté creado el recurso de la IP flotante
output tf_vm_Floating_IP {

  value      = openstack_networking_floatingip_v2.mysql_ip.address 
  depends_on = [openstack_networking_floatingip_v2.mysql_ip] 
}

output tf_vm_Floating_IP_API {

  value      = openstack_networking_floatingip_v2.book_api_ip.address 
  depends_on = [openstack_networking_floatingip_v2.book_api_ip] 
}

output tf_vm_Floating_IP_APP {

  value      = openstack_networking_floatingip_v2.book_app_ip.address 
  depends_on = [openstack_networking_floatingip_v2.book_app_ip] 
}
