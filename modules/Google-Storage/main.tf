# Regla imagen 1 publica
resource "google_storage_object_access_control" "public_rule_imagen1" {
  object = google_storage_bucket_object.imagen1.name
  bucket = google_storage_bucket.bucket.name
  role   = "READER"
  entity = "allUsers"
}

# Regla imagen 2 publica
resource "google_storage_object_access_control" "public_rule_imagen2" {
  object = google_storage_bucket_object.imagen2.name
  bucket = google_storage_bucket.bucket.name
  role   = "READER"
  entity = "allUsers"
}

# Crea el bucket
resource "google_storage_bucket" "bucket" {
name     = var.gcp_bucket_name
location = "europe-west2"
}

# Sube imagen 1
resource "google_storage_bucket_object" "imagen1" {
  name   = "imagen1"
  source = "C:/Users/skip_/Desktop/git/terraform/images/el_enigma_de_la_habitacion_622.jpg"
  bucket = google_storage_bucket.bucket.name
}

# Sube imagen 2
resource "google_storage_bucket_object" "imagen2" {
  name   = "imagen2"
  source = "C:/Users/skip_/Desktop/git/terraform/images/una_historia_de_espana.jpg"
  bucket = google_storage_bucket.bucket.name
}

