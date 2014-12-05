# por siacaso
Encoding.default_external = Encoding::UTF_8 if RUBY_VERSION > "1.9"

node.override["locale"]["lang"] = node["riyic"]["system_locale"]

include_recipe "locale::default"

# seteamos as variables de entorno necesarias
ENV["LANG"] = node["riyic"]["system_locale"]
ENV["LC_ALL"] = node["riyic"]["system_locale"]
