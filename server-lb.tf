resource "digitalocean_loadbalancer" "server-lb" {
  name = "server-lb"
  region = "fra1"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }

  droplet_ids = [digitalocean_droplet.server-1.id, digitalocean_droplet.server-2.id ]
}