locals {
  name        = "redis"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  create_namespace                 = true
  namespace                        = "redis"
  store_password_to_secret_manager = false
  custom_credentials_enabled       = true
  custom_credentials_config = {
    password = "aajdhgduy3873683dh"
  }
}

module "aws" {
  source                           = "squareops/redis/kubernetes//modules/resources/aws"
  environment                      = local.environment
  name                             = local.name
  store_password_to_secret_manager = local.store_password_to_secret_manager
  custom_credentials_enabled       = local.custom_credentials_enabled
  custom_credentials_config        = local.custom_credentials_config
}

module "redis" {
  source           = "squareops/redis/kubernetes"
  create_namespace = local.create_namespace
  namespace        = local.namespace
  redis_config = {
    name                             = local.name
    values_yaml                      = file("./helm/values.yaml")
    environment                      = local.environment
    app_version                      = "7.2.5-debian-12-r2"
    architecture                     = "replication"
    slave_volume_size                = "10Gi"
    master_volume_size               = "10Gi"
    storage_class_name               = "gp2"
    slave_replica_count              = 2
    store_password_to_secret_manager = local.store_password_to_secret_manager
    secret_provider_type             = "aws"
  }
  grafana_monitoring_enabled = true
  custom_credentials_enabled = local.custom_credentials_enabled
  custom_credentials_config  = local.custom_credentials_config
  redis_password             = local.custom_credentials_enabled ? "" : module.aws.redis_password
}
