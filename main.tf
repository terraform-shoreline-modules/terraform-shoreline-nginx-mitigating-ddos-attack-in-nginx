terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "mitigating_ddos_attacks_with_nginx" {
  source    = "./modules/mitigating_ddos_attacks_with_nginx"

  providers = {
    shoreline = shoreline
  }
}