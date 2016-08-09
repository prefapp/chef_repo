if node["riyic"]["inside_container"]

  include_recipe "system_package::clean"

  include_recipe "lang_perl::clean_cpanm"

end
