#!/bin/bash
openssl genrsa -out trac_ssl.key 2048
#chmod 400 trac_ssl.key
openssl req -new -x509 -days 365 -key trac_ssl.key -out trac_ssl.crt -subj "/C=IR/ST=Dublin/L=Dublin/O=personal/CN=www.my-personal-trac.com"
#chmod 400 trac_ssl.key.org
#openssl rsa -in trac_ssl.key.org -out trac_ssl.key
