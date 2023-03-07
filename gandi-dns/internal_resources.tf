

####### ENTOURAGE #######

resource "gandi_livedns_record" "entourage-26834687" {
  zone   = data.gandi_domain.entourage.id
  values = ["sendgrid.net."]
  type   = "CNAME"
  ttl    = 10800
  name   = "26834687"
}

resource "gandi_livedns_record" "entourage-caa" {
  zone   = data.gandi_domain.entourage.id
  values = [
    "0 issue \"awstrust.com\"",
    "0 issue \"letsencrypt.org\""
  ]
  type   = "CAA"
  ttl    = 1800
  name   = "@"
}

resource "gandi_livedns_record" "entourage-mx" {
  zone   = data.gandi_domain.entourage.id
  values = [
    "1 aspmx.l.google.com.",
    "10 aspmx2.googlemail.com.",
    "10 aspmx3.googlemail.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com."
  ]
  type   = "MX"
  ttl    = 3600
  name   = "@"
}

resource "gandi_livedns_record" "entourage-txt" {
  zone   = data.gandi_domain.entourage.id
    values = [
    "\"MS=ms67545121\"",
    "\"facebook-domain-verification=rigmc0upn5saymfsyj0gaxms10sp8o\"",
    "\"google-site-verification=GHi-x068IxM3UKsNbLeb7dmo-LSQK8DMJzg_A5N1bLU\"",
    "\"google-site-verification=JdInQagqICr-_T2hzyyuIEveBrXg0qgQK8jymP5prug\"",
    "\"google-site-verification=kUujR_SeLhtzcwVwzaUrNjtvPNxTTZLwjMMA1aCPbH4\"",
    "\"google-site-verification=z8CEhhk1sWwuGTGSp_nnGtztuNyEKNy4u8NKUhu6WIs\"",
    "\"v=spf1 include:spf.mailjet.com include:_spf.google.com include:servers.mcsv.net include:sendgrid.net include:_spf.salesforce.com ~all\""
  ]
  type   = "TXT"
  ttl    = 1800
  name   = "@"
}
resource "gandi_livedns_record" "entourage-_0aaee4c22f96ab9b49ce64eec8683b64-backoffice-preprod" {
  zone   = data.gandi_domain.entourage.id
  values = ["_b7c6518f863f415a30cf0a8b56621bb5.wggjkglgrm.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 1800
  name   = "_0aaee4c22f96ab9b49ce64eec8683b64.backoffice-preprod"
}
resource "gandi_livedns_record" "entourage-_1348a62c0480f6a1eba261bc4d8840b3-metabase-analytics-2" {
  zone   = data.gandi_domain.entourage.id
  values = ["_3f4ddac8851fd681bc1db00492782720.nhsllhhtvj.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 10800
  name   = "_1348a62c0480f6a1eba261bc4d8840b3.metabase-analytics-2"
}
resource "gandi_livedns_record" "entourage-_32c31fe1de6c81f14b8051a9bf7bf549-admin-preprod" {
  zone   = data.gandi_domain.entourage.id
  values = ["_e1a4ce633ef256bd210a1d70d7f46072.wggjkglgrm.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 1800
  name   = "_32c31fe1de6c81f14b8051a9bf7bf549.admin-preprod"
}
resource "gandi_livedns_record" "entourage-_3e640a4e12cb5bc6b9aecffb9480e3ff" {
  zone   = data.gandi_domain.entourage.id
  values = [
    "C15E6C56FDB197485397AE27CC98221D.1F951DD2D969CF01D2BC2507096269ED.d6de3681d8f3827433a7.comodoca.com.",
    "c15e6c56fdb197485397ae27cc98221d.1f951dd2d969cf01d2bc2507096269ed.d6de3681d8f3827433a7.comodoca.com."
  ]
  type   = "CNAME"
  ttl    = 10800
  name   = "_3e640a4e12cb5bc6b9aecffb9480e3ff"
}
resource "gandi_livedns_record" "entourage-_8e8096493714410971f935db88f55817-metabase-analytics" {
  zone   = data.gandi_domain.entourage.id
  values = ["_a43dd0a7fb8720a991d5248467c51c9d.ltfvzjuylp.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 1800
  name   = "_8e8096493714410971f935db88f55817.metabase-analytics"
}
resource "gandi_livedns_record" "entourage-_90035ded220a9211d851bc3f69415cdb-api-preprod" {
  zone   = data.gandi_domain.entourage.id
  values = ["_b97ff9de3c3e05892c79ffe6e21fce31.wggjkglgrm.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 1800
  name   = "_90035ded220a9211d851bc3f69415cdb.api-preprod"
}
resource "gandi_livedns_record" "entourage-_d815816c1c6603f1791d6029aa4658e0-api-preprod-aws" {
  zone   = data.gandi_domain.entourage.id
  values = ["_1129fc695e04387697b136c6abcd8f10.bsgbmzkfwj.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 1800
  name   = "_d815816c1c6603f1791d6029aa4658e0.api-preprod-aws"
}
resource "gandi_livedns_record" "entourage-dmarc" {
  zone   = data.gandi_domain.entourage.id
  values = [
    "\"v=DMARC1; p=none; pct=100; rua=mailto:re+pxgvmicrc7q@dmarc.postmarkapp.com; sp=none; aspf=r;\""
  ]
  type = "TXT"
  ttl    = 600
  name   = "_dmarc"
}
resource "gandi_livedns_record" "entourage-em312" {
  zone   = data.gandi_domain.entourage.id
  values = ["u7979631.wl132.sendgrid.net."]
  type = "CNAME"
  ttl    = 1800
  name   = "em312"
}
resource "gandi_livedns_record" "entourage-em4877" {
  zone   = data.gandi_domain.entourage.id
  values = ["u26834687.wl188.sendgrid.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "em4877"
}

resource "gandi_livedns_record" "entourage-doublecadeau" {
  zone   = data.gandi_domain.entourage.id
  values = [
    "185.42.117.108",
    "185.42.117.109",
    "46.252.181.103",
    "46.252.181.104"
  ]
  type = "A"
  ttl    = 10800
  name   = "doublecadeau"
}
resource "gandi_livedns_record" "entourage-doublecadeau_cname" {
  zone   = data.gandi_domain.entourage.id
  values = ["domain.par.clever-cloud.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "doublecadeau"
}
resource "gandi_livedns_record" "entourage-entourage-alt_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = ["entourage-alt.4yoele.custdkim.salesforce.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "entourage-alt._domainkey"
}
resource "gandi_livedns_record" "entourage-entourage_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = ["entourage.v8889t.custdkim.salesforce.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "entourage._domainkey"
}
resource "gandi_livedns_record" "entourage-f1cdd767760b8e790c16e3f85af3b080" {
  zone   = data.gandi_domain.entourage.id
  values = ["c0052e0be46efe5f2343713725f3eff1ec4a03af.comodoca.com."]
  type = "CNAME"
  ttl    = 10800
  name   = "f1cdd767760b8e790c16e3f85af3b080"
}
resource "gandi_livedns_record" "entourage-google_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = ["\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAllsDv66z9MMx7rmVF3Ppq/7TFQ17bFzukNxpm02J18SQZn/a1sXxtRJaYAMXTfM8IqRscvUGjSxlpSNzvU9I1I8u\" \"3YvjU3G+we8WfGcjZQQK2yxMwErGtk3e7NJnMpRy0jQ1BrSSWvmWyPqdPoNlM4yihsQF23xaBX0Fa0ReaN77ijGTdL22jqQXMwK6a0Cz+nl/HRWROsFlKgT3VUYVkAcUCXWc0MZ65PkuNL0ZzxFOh2\" \"TfUC4+6z9MSxqQJE6ZJrIhsUrcE0C6OgJqyNgRWq73KM+sv2TYdsxKfmzlvgVM9Txm8sm4/3KS3wd7mbpQqXuQ8+4jVIzkzenRF37NJwIDAQAB\""]
  type = "TXT"
  ttl    = 1800
  name   = "google._domainkey"
}

resource "gandi_livedns_record" "entourage-imap" {
  zone   = data.gandi_domain.entourage.id
  values = ["access.mail.gandi.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "imap"
}

resource "gandi_livedns_record" "entourage-k1_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = ["dkim.mcsv.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "k1._domainkey"
}

resource "gandi_livedns_record" "entourage-lafrancesengage" {
  zone   = data.gandi_domain.entourage.id
  values = ["webredir.vip.gandi.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "lafrancesengage"
}

resource "gandi_livedns_record" "entourage-mailjet_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = ["\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrtZuQzrpsJAvyZ4DucA7QYVfShioY7KoQhPsfpSFLwZ9gm+RcZ2unyNCEKr2vSsMVDAT2Yfg5RESbb3FGMpk8rH3EK97bz11w334lNF494R4sTQ11bW44XTk8SaNyW2ZnJmQ9KuiewcKcDwILbn9gntRS8Yk1G+3mGA45ztg9aQIDAQAB\""]
  type = "TXT"
  ttl    = 3600
  name   = "mailjet._domainkey"
}

resource "gandi_livedns_record" "entourage-mandrill_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = ["\"v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrLHiExVd55zd/IQ/J/mRwSRMAocV/hMB3jXwaHH36d9NaVynQFYV8NaWi69c1veUtRzGt7yAioXqLj7Z4TeEUoOLgrKsn8YnckGs9i3B3tVFB+Ch/4mPhXWiNfNdynHWBcPcbJ8kjEQ2U8y78dHZj1YeRXXVvWob2OaKynO8/lQIDAQAB;\""]
  type = "TXT"
  ttl    = 1800
  name   = "mandrill._domainkey"
}

resource "gandi_livedns_record" "entourage-p_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = ["p.domainkey.u26834687.wl188.sendgrid.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "p._domainkey"
}

resource "gandi_livedns_record" "entourage-p2_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = ["p2.domainkey.u26834687.wl188.sendgrid.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "p2._domainkey"
}

resource "gandi_livedns_record" "entourage-pop" {
  zone   = data.gandi_domain.entourage.id
  values = ["access.mail.gandi.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "pop"
}

resource "gandi_livedns_record" "entourage-s1_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = [
    "s1.domainkey.u26834687.wl188.sendgrid.net.",
    "s1.domainkey.u7979631.wl132.sendgrid.net."
  ]
  type = "CNAME"
  ttl    = 10800
  name   = "s1._domainkey"
}

resource "gandi_livedns_record" "entourage-s2_domainkey" {
  zone   = data.gandi_domain.entourage.id
  values = [
    "s2.domainkey.u26834687.wl188.sendgrid.net.",
    "s2.domainkey.u7979631.wl132.sendgrid.net."
  ]
  type = "CNAME"
  ttl    = 10800
  name   = "s2._domainkey"
}

resource "gandi_livedns_record" "entourage-smtp" {
  zone   = data.gandi_domain.entourage.id
  values = ["relay.mail.gandi.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "smtp"
}

resource "gandi_livedns_record" "entourage-webmail" {
  zone   = data.gandi_domain.entourage.id
  values = ["webmail.gandi.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "webmail"
}

##### SIMPLECOMMEBONJOUR ###############


resource "gandi_livedns_record" "simplecommebonjour-mx" {
  zone   = data.gandi_domain.simplecommebonjour.id
  values = [
    "10 spool.mail.gandi.net.",
    "50 fb.mail.gandi.net."
  ]
  type = "MX"
  ttl    = 10800
  name   = "@"
}

resource "gandi_livedns_record" "simplecommebonjour-txt" {
  zone   = data.gandi_domain.simplecommebonjour.id
  values = [
    "\"4|http://www.simplecommebonjour.org\"",
    "\"facebook-domain-verification=a4k3p8ro972nljxu7e691re7v7a7gm\"",
    "\"google-site-verification=uW1yi-4xIJGzCedwK7-crc2fYF6fEoWf1_prjwek5A0\"",
    "\"v=spf1 include:_mailcust.gandi.net ?all\""
  ]
  type = "TXT"
  ttl    = 1800
  name   = "@"
}

resource "gandi_livedns_record" "simplecommebonjour-webmail" {
  zone   = data.gandi_domain.simplecommebonjour.id
  values = ["webmail.gandi.net."]
  type = "CNAME"
  ttl    = 10800
  name   = "webmail"
}


##### LINKEDOUT ######

resource "gandi_livedns_record" "entourage-_3205c9699021609662d10cb00a137d91-linkedout-vendeeglobe" {
  zone   = data.gandi_domain.entourage.id
  values = ["_4a692665b7442e6dd5aa87033b74790d.auiqqraehs.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 300
  name   = "_3205c9699021609662d10cb00a137d91.linkedout-vendeeglobe"
}

resource "gandi_livedns_record" "entourage-_4b1bfb6d139a8406348990d921a53d3c-linkedout" {
  zone   = data.gandi_domain.entourage.id
  values = ["_31e078d25bec0bbf26950015cec4a520.auiqqraehs.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 300
  name   = "_4b1bfb6d139a8406348990d921a53d3c.linkedout"
}

resource "gandi_livedns_record" "entourage-_ae89e093cd81844e4981fe853bf55765-api-preprod-linkedout" {
  zone   = data.gandi_domain.entourage.id
  values = ["_3bbe2a4b3b9b2ea44070bd39057715a5.auiqqraehs.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 300
  name   = "_ae89e093cd81844e4981fe853bf55765.api-preprod.linkedout"
}

resource "gandi_livedns_record" "entourage-_b4709f1935e8c76cec47949dbcdced9f-api-linkedout" {
  zone   = data.gandi_domain.entourage.id
  values = ["_28463db0368c469ec2e0f98721a68c77.auiqqraehs.acm-validations.aws."]
  type   = "CNAME"
  ttl    = 300
  name   = "_b4709f1935e8c76cec47949dbcdced9f.api.linkedout"
}

resource "gandi_livedns_record" "linkedout-mx" {
  zone   = data.gandi_domain.linkedout.id
  values = [
    "1 ASPMX.L.GOOGLE.COM.",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "5 ALT2.ASPMX.L.GOOGLE.COM."
  ]
  type = "MX"
  ttl    = 1800
  name   = "@"
}

resource "gandi_livedns_record" "linkedout-txt" {
  zone   = data.gandi_domain.linkedout.id
  values = [
    "\"google-site-verification=m4DVGcnfB7BRsN_Irxpb9yoyWoV_1SyEz8tMS4EaE0s\"",
    "\"google-site-verification=zNJJjm4_FlH7TsDSG6SOYiPLerDSmxNjZKMsQpjki2g\"",
    "\"v=spf1 -all\""
  ]
  type = "TXT"
  ttl    = 1800
  name   = "@"
}