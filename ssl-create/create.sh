#!/bin/bash

read -p "Enter domain or server name: [localhost]" name
if [ -z "$name" ]; then
	name=localhost
fi

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -out ${name}.crt \
  -keyout ${name}.key \
  -subj "/CN=${name}" -extensions EXT -config <( \
    printf "[dn]\nCN=${name}\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:${name}\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

exit 0
