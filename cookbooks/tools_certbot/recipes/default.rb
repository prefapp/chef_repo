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
renovar_cert_script = <<-'EOF'.gsub(/\n$/,'')
sleep 6 && \
certbot certonly -n --webroot --webroot-path /usr/share/nginx/html \
--cert-name ${LETSENCRYPT_PRINCIPAL//\"/} \
--domains ${LETSENCRYPT_DOMAINS//\"/} \
--text --agree-tos --email ${LETSENCRYPT_EMAIL//\"/} \
--server https://acme-v01.api.letsencrypt.org/directory \
--rsa-key-size 4096 --verbose --keep \
--standalone-supported-challenges http-01 && \
rm -rf /etc/letsencrypt/live/default && \
ln -sf /etc/letsencrypt/live/${LETSENCRYPT_PRINCIPAL//\"/} /etc/letsencrypt/live/default
EOF

file '/root/renovar_cert.sh' do
  content <<"EOF"
#!/bin/bash

#{renovar_cert_script} && \\
sv restart nginx
EOF

  mode '0755'
  owner 'root'
  group 'root'

end


# nos aseguramos que exista /usr/share/nginx/html/.well-known/
certbot_challenge_path = '/usr/share/nginx/html/.well-known'
directory certbot_challenge_path do
  recursive true
  mode '0755'
end

#
# script para crear o certificado no arranque do container
# se parece ao de renovacion, pero necesita arrancar por separado o nginx
#

if node["riyic"]["inside_container"]

  file "#{node['riyic']['extra_tasks_dir']}/99_generate_certs.sh" do
  
    content <<"EOF"
cp /etc/nginx/nginx.conf /tmp && \\
sed -i 's/daemon\soff/daemon on/' /tmp/nginx.conf && \\
nginx -c /tmp/nginx.conf && \\
#{renovar_cert_script} && \\
nginx -s stop && \\
rm -f /tmp/nginx.conf
EOF
  
    mode '0755'
    owner 'root'
    group 'root'
  
  end
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

