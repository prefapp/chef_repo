
node.set['java']['jdk_version'] = '7'
node.set['java']['install_flavor'] = 'openjdk'
node.set['java']['jdk']['7']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz'
node.set['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe "java::default"
