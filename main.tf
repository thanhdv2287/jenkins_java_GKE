provider "google" {
  project      = "feisty-dolphin-381410"
  region       = "us-central1"
  zone         = "us-central1-b"
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = "true"
}

# Create an GCP Instance to host Jenkins
resource "google_compute_instance" "vm_instance_jenkin" {
  name         = "jenkins-server"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  metadata_startup_script = file("./userdata/InstallJenkins.sh")

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    access_config {
	
    }
  }
}
# Create an GCP Instance to host Ansible Controller
resource "google_compute_instance" "vm_instance_ansible" {
  name         = "ansible-controller"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  metadata_startup_script = file("./userdata/InstallAnsibleController.sh")
  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    access_config {
	
    }
  }
}
#Create an GCP Instance to host Sonatype Nexu
resource "google_compute_instance" "vm_instance_nexus" {
  name         = "nexus-server"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  metadata_startup_script = file("./userdata/InstallNexus.sh")  
  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    access_config {
	
    }

  }
}
#Create an GCP Instance to host Docker
resource "google_compute_instance" "vm_instance_docker" {
  name         = "dockerhost"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  metadata_startup_script = file("./userdata/InstallDocker.sh")
  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    access_config {
	
    }
    
  }
}



#allow 22, 443, 80, 8081, 8080
resource "google_compute_firewall" "allow_22_443_80_8081_8080" {
  name    = "thanhdv-fw-allow-ssh"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "443", "80", "8081", "8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  # target_tags = ["allow-22-443-80-8081-8080"]
}
