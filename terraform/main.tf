

provider "digitalocean" {
  token = var.do_token
}


resource "digitalocean_ssh_key" "default" {
  name       = "Terraform Example"
  public_key = var.ssh_public_key
}

# Create a new Droplet using the SSH key
resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name     = "web-1"
  region   = "nyc2"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  user_data = <<-EOF
              #cloud-config
              disable_root: true
              ssh_pwauth: false
              users:
                - name: ansible
                  primary_group: ansible
                  groups: sudo
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  shell: /bin/bash
                  ssh_authorized_keys:
                    - ${var.ssh_public_key}
              EOF

}

data "digitalocean_droplet" "example" {
  name = digitalocean_droplet.web.name
}

output "droplet_output" {
  value = data.digitalocean_droplet.example.ipv4_address
}