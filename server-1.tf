resource "digitalocean_droplet" "server-1" {
  image = "ubuntu-20-04-x64"
  name = "server-1"
  region = "fra1"
  size = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      "sudo apt-get update",
      "sudo apt-get -y install node"
      "git clone https://github.com/digital-stage/server.git"
      "cd server"
      "npm run install && npm run build"
    ]
  }
}