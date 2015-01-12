# choose how install ruby

if node['lang']['ruby']['use_rvm']
    include_recipe "lang_ruby::rvm"
else
    include_recipe "lang_ruby::ruby-ng"
end
