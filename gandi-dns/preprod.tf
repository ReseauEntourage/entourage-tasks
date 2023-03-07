
#####################" ENTOURAGE #############################"

resource "gandi_livedns_record" "entourage-admin-preprod" {
  zone   = data.gandi_domain.entourage.id
  values = ["solid-bass-hslt86c10ke76o9fpaufjsq9.herokudns.com."]
  type   = "CNAME"
  ttl    = 1800
  name   = "admin-preprod"
}
resource "gandi_livedns_record" "entourage-admin-preprod-heroku" {
  zone   = data.gandi_domain.entourage.id
  values = ["admin-preprod.entourage.social.herokudns.com."]
  type   = "CNAME"
  ttl    = 1800
  name   = "admin-preprod-heroku"
}
resource "gandi_livedns_record" "entourage-api-preprod" {
  zone   = data.gandi_domain.entourage.id
  values = ["contoured-honeydew-yjkpre7rhisna16fm738ojbp.herokudns.com."]
  type = "CNAME"
  ttl    = 300
  name   = "api-preprod"
}
resource "gandi_livedns_record" "entourage-api-preprod-aws" {
  zone   = data.gandi_domain.entourage.id
  values = ["entourage-preprod-lb-253879648.eu-west-1.elb.amazonaws.com."]
  type = "CNAME"
  ttl    = 300
  name   = "api-preprod-aws"
}
resource "gandi_livedns_record" "entourage-api-preprod-heroku" {
  zone   = data.gandi_domain.entourage.id
  values = ["peaceful-squid-vyjxysor2g51cssb3v0m7azi.herokudns.com."]
  type = "CNAME"
  ttl    = 300
  name   = "api-preprod-heroku"
}
resource "gandi_livedns_record" "entourage-backoffice-preprod" {
  zone   = data.gandi_domain.entourage.id
  values = ["entourage-preprod-lb-253879648.eu-west-1.elb.amazonaws.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "backoffice-preprod"
}
resource "gandi_livedns_record" "entourage-beta" {
  zone   = data.gandi_domain.entourage.id
  values = ["ec2-52-209-13-85.eu-west-1.compute.amazonaws.com."]
  type = "CNAME"
  ttl    = 300
  name   = "beta"
}
resource "gandi_livedns_record" "entourage-beta-webapp" {
  zone   = data.gandi_domain.entourage.id
  values = ["cardiovascular-squash-k08dsed8omeoz0malul27c66.herokudns.com."]
  type = "CNAME"
  ttl    = 300
  name   = "beta.webapp"
}

resource "gandi_livedns_record" "entourage-preprod" {
  zone   = data.gandi_domain.entourage.id
  values = ["ec2-52-209-13-85.eu-west-1.compute.amazonaws.com."]
  type = "CNAME"
  ttl    = 600
  name   = "preprod"
}


#####################" SIMPLECOMMEBONJOUR #############################"

resource "gandi_livedns_record" "simplecommebonjour-beta" {
  zone   = data.gandi_domain.simplecommebonjour.id
  values = ["ec2-34-242-53-3.eu-west-1.compute.amazonaws.com."]
  type = "CNAME"
  ttl    = 600
  name   = "beta"
}


resource "gandi_livedns_record" "simplecommebonjour-betaadminscb" {
  zone   = data.gandi_domain.simplecommebonjour.id
  values = ["reticulated-yam-ti0do2mbn705asdn4qolv7bh.herokudns.com."]
  type = "CNAME"
  ttl    = 300
  name   = "betaadminscb"
}

##################### LINKEDOUT #############################"

resource "gandi_livedns_record" "entourage-beta-linkedout" {
  zone   = data.gandi_domain.entourage.id
  values = ["ec2-52-209-13-85.eu-west-1.compute.amazonaws.com."]
  type = "CNAME"
  ttl    = 1800
  name   = "beta.linkedout"
}

resource "gandi_livedns_record" "entourage-api-preprod-linkedout" {
  zone   = data.gandi_domain.entourage.id
  values = ["lyq3b1ryvk.execute-api.eu-west-1.amazonaws.com."]
  type = "CNAME"
  ttl    = 300
  name   = "api-preprod.linkedout"
}