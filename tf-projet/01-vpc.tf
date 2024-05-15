/*
 Nom du fichier: 01-vpc.tf
 Résumé du fichier: Ce fichier contient la configuration Terraform pour un réseau VPC AWS.
 Cela comprend la configuration pour le VPC principal, une passerelle Internet, deux tables de routage (publique et privée), 
 quatre sous-réseaux (deux publics et deux privés), des associations de tables de routage pour lier chaque sous-réseau à une table de routage, 
 et enfin, la configuration d'un groupe de sécurité pour permettre à tous les ports entrants et sortants.
 */

// Le bloc de ressources pour le VPC principal
resource "aws_vpc" "main"{
    cidr_block = "172.16.0.0/16"
    tags = {
        Name = "main-vpc"
    }
}

// Le bloc de ressources pour la passerelle Internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

// Le bloc de ressources pour la table de routage publique
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

// Le bloc de ressources pour la table de routage privée
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

// Le bloc de ressources pour le sous-réseau public A
resource "aws_subnet" "public-subnet-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.16.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet-a"
  }
}

// Le bloc de ressources pour le sous-réseau public B
resource "aws_subnet" "public-subnet-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.16.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-b"
  }
}

// Le bloc de ressources pour le sous-réseau privé A
resource "aws_subnet" "private-subnet-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.16.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-a"
  }
}

// Le bloc de ressources pour le sous-réseau privé B
resource "aws_subnet" "private-subnet-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.16.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-b"
  }
}

// Le bloc de ressources pour associer le sous-réseau public A à la table de routage publique
resource "aws_route_table_association" "public-association-a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public-route-table.id
}

// Le bloc de ressources pour associer le sous-réseau public B à la table de routage publique
resource "aws_route_table_association" "public-association-b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public-route-table.id
}

// Le bloc de ressources pour associer le sous-réseau privé A à la table de routage privée
resource "aws_route_table_association" "private-association-a" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.private-route-table.id
}

// Le bloc de ressources pour associer le sous-réseau privé B à la table de routage privée
resource "aws_route_table_association" "private-association-b" {
  subnet_id      = aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.private-route-table.id
}

// Le bloc de ressources pour le groupe de sécurité qui permet à tous les ports d'être ouverts
resource "aws_security_group" "main_security_group" {
 name        = "hello-ecs-sg"
 description = "Allow All Ports Inbound and Outbound"
 vpc_id = aws_vpc.main.id
}


// Le bloc de ressources pour permettre tous les ports entrants
resource "aws_security_group_rule" "open-all-ingress" {
 type = "ingress"
 from_port = 0
 to_port   = 65535
 protocol = "tcp"
 description = "Allow traffic to containers"
 cidr_blocks = ["0.0.0.0/0"]
 security_group_id = aws_security_group.main_security_group.id
}


// Le bloc de ressources pour permettre tous les ports sortants
resource "aws_security_group_rule" "open-all-egress" {
 type = "egress"
 from_port = 0
 to_port   = 65535
 protocol = "tcp"
 description = "Allow traffic from containers"
 cidr_blocks = ["0.0.0.0/0"]
 security_group_id = aws_security_group.main_security_group.id
}

resource "aws_nat_gateway" "private_nat_gateway" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public-subnet-a.id

  tags = {
    Name = "new_gw_NAT"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_eip" "lb" {
  vpc = true
}

resource "aws_route" "private_nat_gateway_route" {
  route_table_id            = aws_route_table.private-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private_nat_gateway.id
}