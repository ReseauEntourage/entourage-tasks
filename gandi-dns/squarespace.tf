
resource "gandi_livedns_record" "entourage-3jb4jlxckym6nx79bd37" {
  zone   = data.gandi_domain.entourage.id
  values = ["verify.squarespace.com."]
  type   = "CNAME"
  ttl    = 10800
  name   = "3jb4jlxckym6nx79bd37"
}
resource "gandi_livedns_record" "entourage-allumonslefeudelasolidarite" {
  zone   = data.gandi_domain.entourage.id
  values = ["ext-cust.squarespace.com."]
  type   = "CNAME"
  ttl    = 10800
  name   = "allumonslefeudelasolidarite"
}
resource "gandi_livedns_record" "entourage-bonjour" {
  zone   = data.gandi_domain.entourage.id
  values = ["ext-cust.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "bonjour"
}
resource "gandi_livedns_record" "entourage-bonjour-bonjour" {
  zone   = data.gandi_domain.entourage.id
  values = ["ext-cust.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "bonjour-bonjour"
}
resource "gandi_livedns_record" "entourage-c2c3hltg2nzlt8ykcnbf" {
  zone   = data.gandi_domain.entourage.id
  values = ["verify.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "c2c3hltg2nzlt8ykcnbf"
}

resource "gandi_livedns_record" "entourage-lefeudelasolidarite" {
  zone   = data.gandi_domain.entourage.id
  values = ["ext-cust.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "lefeudelasolidarite"
}


resource "gandi_livedns_record" "entourage-rzbb499fy643rdntmas2" {
  zone   = data.gandi_domain.entourage.id
  values = ["verify.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "rzbb499fy643rdntmas2"
}


resource "gandi_livedns_record" "entourage-sna4ds2k85d23lg3r53p" {
  zone   = data.gandi_domain.entourage.id
  values = ["verify.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "sna4ds2k85d23lg3r53p"
}
resource "gandi_livedns_record" "entourage-taxe-apprentissage" {
  zone   = data.gandi_domain.entourage.id
  values = ["ext-cust.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "taxe-apprentissage"
}

resource "gandi_livedns_record" "entourage-ws7c6mj5zgy2dy5zcyef" {
  zone   = data.gandi_domain.entourage.id
  values = ["verify.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "ws7c6mj5zgy2dy5zcyef"
}

resource "gandi_livedns_record" "entourage-www-taxe-apprentissage" {
  zone   = data.gandi_domain.entourage.id
  values = ["ext-cust.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "www.taxe-apprentissage"
}

resource "gandi_livedns_record" "linkedout-lx3f29s6b2s55j2mpdpw" {
  zone   = data.gandi_domain.linkedout.id
  values = ["verify.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "lx3f29s6b2s55j2mpdpw"
}

resource "gandi_livedns_record" "linkedout-taxe-apprentissage" {
  zone   = data.gandi_domain.linkedout.id
  values = ["ext-cust.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "taxe-apprentissage"
}

resource "gandi_livedns_record" "linkedout-www-taxe-apprentissage" {
  zone   = data.gandi_domain.linkedout.id
  values = ["ext-cust.squarespace.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "www.taxe-apprentissage"
}

resource "gandi_livedns_record" "entourage-contenu" {
  zone   = data.gandi_domain.entourage.id
  values = ["proxy.plezi.co."]
  type = "CNAME"
  ttl    = 10800
  name   = "contenu"
}

resource "gandi_livedns_record" "entourage-ovyi5sujczyp-contenu" {
  zone   = data.gandi_domain.entourage.id
  values = ["gv-m5n4pbczhx6dc4.dv.googlehosted.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "ovyi5sujczyp.contenu"
}