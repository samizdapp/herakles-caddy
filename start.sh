#!/bin/sh

while [ ! -f /yggdrasil/config.conf ]
do
echo "waiting for yggdrasil config"
sleep 1
done

echo "get public key"
PUB=$(jq '.PublicKey' /yggdrasil/config.conf | tr -d '"')
echo $PUB
P1=${PUB:0:63}
P2=${PUB:63:1}
echo $PUB
export DOMAIN="pleroma.$P1.$P2.yg"
echo $DOMAIN

CF=/etc/caddy/Caddyfile

cat Caddyfile.header > $CF
echo "$DOMAIN {" >> $CF
echo "  reverse_proxy localhost:8009" >> $CF
echo "}" >> $CF
cat Caddyfile.footer >> $CF

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile