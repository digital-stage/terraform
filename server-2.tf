resource "digitalocean_droplet" "server-2" {
  image = "ubuntu-20-04-x64"
  name = "server-2"
  region = "fra1"
  size = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.DigitalStage.id
  ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = var.pvt_key
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install node
      "sudo apt-get update",
      "curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -",
      "sudo apt-get -y install nodejs",
      # install pm2 to daemonize the process
      "npm install pm2@latest -g",
      # clone and build server
      "git clone https://github.com/digital-stage/server.git",
      "cd server",
      "npm run install && npm run build",
      "pm2 start dist/index.js"
    ]
  }
}
