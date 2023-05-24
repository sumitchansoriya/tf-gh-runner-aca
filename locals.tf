locals {
  location = {
    eastus  = "eus1",
    eastus2 = "eus2",
    westus1 = "wus1",
    westus2 = "wus2",
  }
  prefix = format("%s-%s-%s-%s",
    var.org,
    var.project,
    var.environment,
    local.location[var.location]
  )
}