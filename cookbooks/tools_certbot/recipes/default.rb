apt_repository 'certbot' do
  uri          'ppa:certbot/certbot'
  distribution node['lsb']['codename']
end

package 'certbot'

file '/root/renovar_cert.sh' do
  content <<-'EOF'
#!/bin/bash

sleep 6 && \
certbot certonly --webroot --webroot-path /usr/share/nginx/html \
--cert-name $LETSENCRYPT_PRINCIPAL \
--domains $LETSENCRYPT_DOMAINS \
--text --agree-tos --email $LETSENCRYPT_EMAIL \
--server https://acme-v01.api.letsencrypt.org/directory \
--rsa-key-size 4096 --verbose --keep \
--standalone-supported-challenges http-01 && \
rm -rf /etc/letsencrypt/live/default && \
ln -sf /etc/letsencrypt/live/$LETSENCRYPT_PRINCIPAL /etc/letsencrypt/live/default && \
sv nginx restart
  EOF

  mode '0755'
  owner 'root'
  group 'root'

end
