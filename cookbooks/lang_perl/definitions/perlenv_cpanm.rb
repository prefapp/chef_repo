define :perlenv_cpanm, :options => '' do
  name = params[:name]
  modules = (params.has_key?(:modules)? params[:modules]: [name])


  include_recipe "lang_perl::default"

  if node["lang"]["perl"]["version"] == "system" 
    bash name do
      code "cpanm #{params[:options]} #{modules.join(' ')}"
      action :run
    end
  else
      #perlbrew
      perlbrew_cpanm name do
        options params[:options]
        perlbrew node["lang"]["perl"]["version"]
        modules modules
      end

  end

end