// mettre le aws_db_instance

resource "null_resource" "sciforma-official" {

  count = length(local.builds_to_cache)

  triggers = {

    value = join(";", local.builds_to_cache)

  }

  provisioner "local-exec" {

    command = <<EOF

      aws sns publish \

      --topic-arn ${module.ecr-replicator.sns_topic_arn} \

      --message '{"source_image": "${data.aws_ecr_repository.sciforma-official.repository_url}:${element(local.builds_to_cache, count.index)}", "destination_image": "${aws_ecr_repository.sciforma.repository_url}:official.${element(local.builds_to_cache, count.index)}"}' \

      --region ${var.region}

EOF

 

  }

  depends_on = [module.ecr-replicator]

}

aws_db_instance : db_t2_micro gratuit
définir un nom et mot de passe par défaut
serveur mysql dans le réseau privée

mettre en place les tenant_id (utiliser les token jwt)
deux base séparé mais sur le même serveur