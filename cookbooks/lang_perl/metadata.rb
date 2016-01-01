name             "lang_perl"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install perl language from package or sources"
version          "0.1.2"

depends "perlbrew"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "Installs perl",
    attributes: [/.+/],
    dependencies: []

## Atributos
attribute "lang/perl/version",
    :display_name => 'Perl version to install',
    :description => 'Perl version to install ("system" to install system package version)',
    :default => 'system',
    # :validations => {regex: /^(system|\d+\.\d+\.\d+)$/},
    :choice => %w{
        system
        stable
        blead
        perl-5.22.1
        perl-5.20.3
        perl-5.18.4
        perl-5.16.3
        perl-5.14.4
        perl-5.12.5
        perl-5.10.1
        perl-5.8.9
        perl-5.6.2
    }, 
    :advanced => false


attribute "lang/perl/perlbrew/perlbrew_root",
    :display_name => "Path to set PERLBREW_ROOT",
    :description => "Path to set perlbrew root directory",
    :default => '/opt/perlbrew',
    :validations => {:predefined => "unix_path"}

attribute "lang/perl/perlbrew/self_upgrade",
    :display_name => "Self upgrade perlbrew binary",
    :description => "Self upgrade perlbrew binary",
    :default => "yes",
    :choice => ["yes","no"]

attribute "lang/perl/modules",
    :display_name => "Perl modules to install",
    :description => "Perl modules to install (with cpanm)",
    :default => [],
    :type => "array", # probablemente mellor hash
    :advanced => false,
    :validations => {:predefined => "perl_module"}
# attributes "lang/perl/perlbrew/install_options",
#     :display_name => "Install options",
#     :description => "Install options",
#     :default => {"j" => 4},
#     :type => "hash",
#     :validations => {:predefined => "command_line_option"}
