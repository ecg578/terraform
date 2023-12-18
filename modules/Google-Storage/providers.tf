terraform {
    required_providers{
        google = {
            source = "hashicorp/google"
        }
    }
}

provider "google" {
    version = "3.5.0"

    credentials = file("C:/Users/skip_/Desktop/git/terraform/gcp-identity.json")

    project = var.gcp_project
    region  = "us-central1"
    zone    = "us-central1-c"
}