locals {
  infra_rg    = "infra-rg"
  datalake_rg = "datalake-rg"
  adf_rg      = "adf-rg"
  sql_rg      = "sql-rg"
  location    = "eastus2"
  sufix       = "jgl926"
  current_ip  = chomp(data.http.current_ip.response_body)
}