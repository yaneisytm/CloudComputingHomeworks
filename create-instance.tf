resource "google_compute_instance" "default" {
  name         = "webserver-terraform"
  machine_type = "f1-micro"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
       image = "ubuntu-1804-bionic-v20200129a"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
	metadata_startup_script = "sudo apt-get update; sudo apt-get install apache2 -y; sudo apt install php7.2-cli -y; echo '<!doctype html><html><body><h1>Terraform Homework!</h1></body></html>' | sudo tee /var/www/html/index.html"

    metadata = {
	sshKeys = file("~/.ssh/id_rsa.pub")
	}
    // Apply the firewall rule to allow external IPs to access this instance
    tags = ["http-server","ssh"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
resource "google_compute_firewall" "ssh" {
  name    = "default-allow-ssh-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}


output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}