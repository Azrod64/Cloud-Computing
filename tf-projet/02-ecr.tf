resource "aws_ecr_repository" "hello-ui" {
  name                 = "hello-ui"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "hello-ms" {
  name                 = "hello-ms"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "push_hello_ms" {
  triggers = {
    value = "test" // a chaque fois qu'elle est changé, cela renvoie l'image (mettre un random pout push auto)
  }
  provisioner "local-exec" {
    command = <<EOF
      docker build &&\
      docker build/ \
      // placer les commande aws et pas oublier && et \

EOF

  }
}

resource "null_resource" "push_hello_ui" {
  triggers = {
    value = "test" // a chaque fois qu'elle est changé, cela renvoie l'image (mettre un random pout push auto)
  }
  provisioner "local-exec" {
    command = <<EOF
      docker build &&\
      docker build/ \
      // placer les commande aws et pas oublier && et \

EOF

  }
}