## Init Env variables

You need the Gandi secret key in terraform.tfvars to have this command to work:

``gandi_key= "YOUR_TOKEN"``

## File structure
**main.tf**: all dns entries for **PRODUCTION** sites

**preprod.tf**: all dns entries for dev sites

**squarespace.tf**: all dns entries to CMS or other tools to generate websites

**internal_resources**: all other dns entries

## Before deploy 

``terraform init``

``terraform plan``

``terraform show``

## Deploy

``terraform apply``


## New entry to import

``terraform import gandi_livedns_record.XXX-YYY AAA/BBB/CCC``

where 
- XXX is simplified domain (entourage/linkedout/simplecommebonjour)
- YYY is resource name (should look like AAA)
- AAA is domain name (linkedout.fr/entourage.social/simplecommebonjour.org)
- BBB is name (www/...)
- CCC is type (CNAME/A/...)

