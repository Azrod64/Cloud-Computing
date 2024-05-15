# Fichier : varaibles.tf

# Résumé : Ce fichier déclare deux variables qui sont utilisées dans le script Terraform. Ces variables sont 'lab_role' et 'lab_instance_profile', représentant respectivement le rôle IAM AWS et le profil d'instance IAM AWS utilisé dans le déploiement.

# La variable 'lab_role'
# Elle détient l'ARN (Amazon Resource Name) du rôle IAM AWS utilisé pour le déploiement.
variable "lab_role" {
    default = "arn:aws:iam::780170311873:role/LabRole"
}

# La variable 'lab_instance_profile'
# Elle détient l'ARN du profil d'instance IAM AWS utilisé pour le déploiement.
variable "lab_instance_profile" {
    default = "arn:aws:iam::780170311873:instance-profile/LabInstanceProfile"
}