# 
# agregamos o ppa de certbot
#
apt_repository 'certbot' do
  uri          'ppa:certbot/certbot'
  distribution node['lsb']['codename']
end

package 'certbot'


#
# creamos o script que vamos a usar para alta/renovacion 
# de certificados
#
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
sv restart nginx
  EOF

  mode '0755'
  owner 'root'
  group 'root'

end


# nos aseguramos que exista /etc/letsencrypt/live/default
# en que teña uns certificados generados
# de esta forma o nginx cando tire deles non casca

default_certs_path = '/etc/letsencrypt/live/default'

directory default_certs_path do
  recursive true
end


%w(fullchain.pem privkey.pem).each do |cert_file|

  cookbook_file "#{default_certs_path}/#{cert_file}" do
    source cert_file
    owner 'root'
    group 'root'
    mode '0600'
    action :create_if_missing
  end

end


