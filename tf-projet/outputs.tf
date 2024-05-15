# Nom du fichier: outputs.tf

# Contenu du fichier: Ce fichier déclare deux sorties (outputs) pour un module Terraform. 
#La sortie "ssh-private-key-pem" renvoie la clé privée d'une paire de clés RSA encryptée, et la sortie "public_ip" 
#renvoie l'adresse IP publique d'une instance AWS EC2.

# Sortie "ssh-private-key-pem"
# Cette sortie fournit la clé privée d'une paire de clés RSA. Notez que cette valeur est sensible et ne doit pas être exposée inutilement.
#output "ssh-private-key-pem" {
#    value = tls_private_key.rsa-4096.private_key_pem
#    sensitive = true
#}

# Sortie "public_ip"
# Cette sortie fournit l'adresse IP publique de l'instance EC2 d'AWS. 
#output "public_ip" {
#    value = aws_instance.this.public_ip
#}

output "application_address" {
    value = aws_lb.load-balancer-ui.dns_name
}