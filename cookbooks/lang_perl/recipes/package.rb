# use system perl

package "perl"


#install cpanm
bash "perlbrew-install" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOC
  curl -kL http://cpanmin.us | perl - App::cpanminus
  EOC
end