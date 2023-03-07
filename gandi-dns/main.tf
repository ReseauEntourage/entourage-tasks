terraform {
  required_providers {
    gandi = {
      version = "~> 2.0.0"
      source  = "go-gandi/gandi"
    }
  }
}


###### PROVIDERS #########

provider "gandi" {
  key = var.gandi_key
}

########## DOMAINS ################

data "gandi_domain" "linkedout" {
  name = "linkedout.fr"
}


data "gandi_domain" "entourage" {
  name = "entourage.social"
}

data "gandi_domain" "simplecommebonjour" {
  name = "simplecommebonjour.org"
}

####### ENTOURAGE #######

resource "gandi_livedns_record" "entourage-a" {
  zone   = data.gandi_domain.entourage.id
  values = ["52.209.13.85"]
  type   = "A"
  ttl    = 10800
  name   = "@"
}
resource "gandi_livedns_record" "entourage-admin" {
  zone   = data.gandi_domain.entourage.id
  values = ["admin.entourage.social.herokudns.com."]
  type   = "CNAME"
  ttl    = 10800
  name   = "admin"
}
resource "gandi_livedns_record" "entourage-ambassadeurs" {
  zone   = data.gandi_domain.entourage.id
  values = ["ec2-52-209-13-85.eu-west-1.compute.amazonaws.com."]
  type   = "CNAME"
  ttl    = 600
  name   = "ambassadeurs"
}
resource "gandi_livedns_record" "entourage-api" {
  zone   = data.gandi_domain.entourage.id
  values = ["api.entourage.social.herokudns.com."]
  type   = "CNAME"
  ttl    = 300
  name   = "api"
}
resource "gandi_livedns_record" "entourage-app" {
  zone   = data.gandi_domain.entourage.id
  values = ["evening-marlin-0a5660u3x2b3jmswng7aweuk.herokudns.com."]
  type = "CNAME"
  ttl    = 600
  name   = "app"
}
resource "gandi_livedns_record" "entourage-asso" {
  zone   = data.gandi_domain.entourage.id
  values = ["ec2-52-209-13-85.eu-west-1.compute.amazonaws.com."]
  type = "CNAME"
  ttl    = 1800
  name   = "asso"
}
resource "gandi_livedns_record" "entourage-backoffice" {
  zone   = data.gandi_domain.entourage.id
  values = ["backoffice.entourage.social.herokudns.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "backoffice"
}
resource "gandi_livedns_record" "entourage-blog" {
  zone   = data.gandi_domain.entourage.id
  values = ["ec2-52-209-13-85.eu-west-1.compute.amazonaws.com."]
  type = "CNAME"
  ttl    = 300
  name   = "blog"
}
resource "gandi_livedns_record" "entourage-don" {
  zone   = data.gandi_domain.entourage.id
  values = ["ec2-52-209-13-85.eu-west-1.compute.amazonaws.com."]
  type = "CNAME"
  ttl    = 1800
  name   = "don"
}

resource "gandi_livedns_record" "entourage-lesbonnesondes" {
  zone   = data.gandi_domain.entourage.id
  values = ["comparative-ostrich-ixoltaw8f5b4y6j0mtq0cxxa.herokudns.com."]
  type = "CNAME"
  ttl    = 1800
  name   = "lesbonnesondes"
}

resource "gandi_livedns_record" "entourage-lien" {
  zone   = data.gandi_domain.entourage.id
  values = ["sendgrid.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "lien"
}

resource "gandi_livedns_record" "entourage-metabase-analytics" {
  zone   = data.gandi_domain.entourage.id
  values = ["metabase-env.eba-ahsiex7m.eu-west-1.elasticbeanstalk.com."]
  type = "CNAME"
  ttl    = 600
  name   = "metabase-analytics"
}

resource "gandi_livedns_record" "entourage-status" {
  zone   = data.gandi_domain.entourage.id
  values = ["stats.uptimerobot.com."]
  type = "CNAME"
  ttl    = 600
  name   = "status"
}

resource "gandi_livedns_record" "entourage-www" {
  zone   = data.gandi_domain.entourage.id
  values = ["ec2-52-209-13-85.eu-west-1.compute.amazonaws.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "www"
}

resource "gandi_livedns_record" "entourage-www-ambassadeurs" {
  zone   = data.gandi_domain.entourage.id
  values = ["ec2-52-209-13-85.eu-west-1.compute.amazonaws.com."]
  type = "CNAME"
  ttl    = 600
  name   = "www.ambassadeurs"
}

##### SIMPLECOMMEBONJOUR ###############

resource "gandi_livedns_record" "simplecommebonjour-a" {
  zone   = data.gandi_domain.simplecommebonjour.id
  values = ["52.209.13.85"]
  type = "A"
  ttl    = 600
  name   = "@"
}

resource "gandi_livedns_record" "simplecommebonjour-oldwww" {
  zone   = data.gandi_domain.simplecommebonjour.id
  values = ["34.242.53.3"]
  type = "A"
  ttl    = 10800
  name   = "oldwww"
}

resource "gandi_livedns_record" "simplecommebonjour-www" {
  zone   = data.gandi_domain.simplecommebonjour.id
  values = ["simplecommebonjour.org."]
  type = "CNAME"
  ttl    = 600
  name   = "www"
}

##### LINKEDOUT ######
resource "gandi_livedns_record" "linkedout-a" {
  zone   = data.gandi_domain.linkedout.id
  values = ["52.209.13.85"]
  type = "A"
  ttl    = 300
  name   = "@"
}
resource "gandi_livedns_record" "linkedout-api" {
  zone   = data.gandi_domain.linkedout.id
  values = ["parallel-falls-mgyqelu7rie5yrcaz84bngq9.herokudns.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "api"
}

resource "gandi_livedns_record" "linkedout-blog" {
  zone   = data.gandi_domain.linkedout.id
  values = ["52.209.13.85"]
  type = "A"
  ttl    = 300
  name   = "blog"
}

resource "gandi_livedns_record" "linkedout-www" {
  zone   = data.gandi_domain.linkedout.id
  values = ["avian-camellia-0ug7mqz9pab9vmpfvo8e3vtw.herokudns.com."]
  type = "CNAME"
  ttl    = 300
  name   = "www"
}

resource "gandi_livedns_record" "entourage-api-linkedout" {
  zone   = data.gandi_domain.entourage.id
  values = ["71l9vio4ba.execute-api.eu-west-1.amazonaws.com."]
  type = "CNAME"
  ttl    = 300
  name   = "api.linkedout"
}

resource "gandi_livedns_record" "entourage-linkedout-vendeeglobe" {
  zone   = data.gandi_domain.entourage.id
  values = ["dugxyemvj88k4.cloudfront.net."]
  type = "CNAME"
  ttl    = 300
  name   = "linkedout-vendeeglobe"
}