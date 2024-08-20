## Redis

![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
This module allows users to customize the deployment by providing various input variables. Users can specify the name and environment of the Redis deployment, the chart and app version, the namespace in which the Redis deployment will be created, and whether to enable Grafana monitoring. This module provides options to create a new namespace, and to configure recovery windows for AWS Secrets Manager, Azure key vault & GCP secrets manager. With this module, users can easily deploy a highly available redis on AWS EKS, Azure AKS & GCP GKE Kubernetes clusters with the flexibility to customize their configurations according to their needs.
<br><br>
This module creates a Redis master and one or more Redis slaves, depending on the specified architecture. The module creates Kubernetes services for the Redis master and slave deployments, and exposes these services as endpoints that can be used to connect to the Redis database. Users can retrieve these endpoints using the module's outputs.

## Supported Versions :

|  Redis Helm Chart Version    |     K8s supported version (EKS, AKS & GKE)  |  
| :-----:                       |         :---                |
| **19.6.1**                     |    **1.23,1.24,1.25,1.26,1.27,1.28,1.29**           |

## Usage Example

```hcl
locals {
  name        = "redis"
  region      = "eastus"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  create_namespace                 = true
  namespace                        = "redis"
  store_password_to_secret_manager = true
  custom_credentials_enabled       = true
  custom_credentials_config = {
    password = "aajdhgduy3873683dh"
  }
}

module "azure" {
  source                           = "squareops/redis/kubernetes//modules/resources/azure"
  resource_group_name              = "prod-skaf-rg"
  resource_group_location          = local.region
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
    values_yaml                      = ""
    environment                      = local.environment
    app_version                      = "6.2.7-debian-11-r11"
    architecture                     = "replication"
    slave_volume_size                = "10Gi"
    master_volume_size               = "10Gi"
    storage_class_name               = "infra-service-sc"
    slave_replica_count              = 2
    store_password_to_secret_manager = local.store_password_to_secret_manager
    secret_provider_type             = "azure"
  }
  grafana_monitoring_enabled = true
  custom_credentials_enabled = local.custom_credentials_enabled
  custom_credentials_config  = local.custom_credentials_config
  redis_password             = local.custom_credentials_enabled ? "" : module.azure.redis_password
}



```
- Refer [AWS examples](https://github.com/squareops/terraform-kubernetes-redis/tree/main/examples/complete/aws) for more details.
- Refer [Azure examples](https://github.com/squareops/terraform-kubernetes-redis/tree/main/examples/complete/azure) for more details.
- Refer [GCP examples](https://github.com/squareops/terraform-kubernetes-redis/tree/main/examples/complete/gcp) for more details.

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/squareops/terraform-kubernetes-redis/blob/main/IAM.md)

## Important Notes
  1. In order to enable the exporter, it is required to deploy Prometheus/Grafana first.
  2. The exporter is a tool that extracts metrics data from an application or system and makes it available to be scraped by Prometheus.
  3. Prometheus is a monitoring system that collects metrics data from various sources, including exporters, and stores it in a time-series database.
  4. Grafana is a data visualization and dashboard tool that works with Prometheus and other data sources to display the collected metrics in a user-friendly way.
  5. To deploy Prometheus/Grafana, please follow the installation instructions for each tool in their respective documentation.
  6. Once Prometheus and Grafana are deployed, the exporter can be configured to scrape metrics data from your application or system and send it to Prometheus.
  7. Finally, you can use Grafana to create custom dashboards and visualize the metrics data collected by Prometheus.
  8. This module is compatible with EKS, AKS & GKE which is great news for users deploying the module on an AWS, Azure & GCP cloud. Review the module's documentation, meet specific configuration requirements, and test thoroughly after deployment to ensure everything works as expected.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.redis](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.redis](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of the chart for the Redis application that will be deployed. | `string` | `"19.6.1"` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace. | `string` | `true` | no |
| <a name="input_custom_credentials_config"></a> [custom\_credentials\_config](#input\_custom\_credentials\_config) | Specify the configuration settings for Redis to pass custom credentials during creation. | `any` | <pre>{<br>  "password": ""<br>}</pre> | no |
| <a name="input_custom_credentials_enabled"></a> [custom\_credentials\_enabled](#input\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for Redis. | `bool` | `false` | no |
| <a name="input_grafana_monitoring_enabled"></a> [grafana\_monitoring\_enabled](#input\_grafana\_monitoring\_enabled) | Specify whether or not to deploy Redis exporter to collect Redis metrics for monitoring in Grafana. | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where the Redis resources will be deployed. | `string` | `"redis"` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager will wait before it can delete the secret. The value can be 0 to force deletion without recovery, or a range from 7 to 30 days. | `number` | `0` | no |
| <a name="input_redis_config"></a> [redis\_config](#input\_redis\_config) | Specify the configuration settings for Redis, including the name, environment, storage options, replication settings, store password to secret manager and custom YAML values. | `any` | <pre>{<br>  "app_version": "7.2.5-debian-12-r2",<br>  "architecture": "replication",<br>  "environment": "",<br>  "master_volume_size": "",<br>  "name": "",<br>  "slave_replica_count": 1,<br>  "slave_volume_size": "",<br>  "storage_class_name": "",<br>  "store_password_to_secret_manager": true,<br>  "values_yaml": ""<br>}</pre> | no |
| <a name="input_redis_password"></a> [redis\_password](#input\_redis\_password) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_redis_credential"></a> [redis\_credential](#output\_redis\_credential) | Redis credentials used for accessing the database. |
| <a name="output_redis_endpoints"></a> [redis\_endpoints](#output\_redis\_endpoints) | Redis endpoints in the Kubernetes cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contribution & Issue Reporting

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/squareops/terraform-kubernetes-redis/issues) on GitHub
  2. Search to see if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Be sure to provide enough context and details so others can understand your problem.

## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/).

## Support Us

To support a GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/squareops/terraform-kubernetes-redis).

  2. Click the "Star" button: On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Starring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 5 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

To find more information about our company, visit [squareops.com](https://squareops.com/), follow us on [Linkedin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).
