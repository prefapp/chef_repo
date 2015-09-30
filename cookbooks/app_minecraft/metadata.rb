name             "app_minecraft"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      " This cookbook installs Minecraft Servers"
version          "0.0.1"

depends "lang_java"

attribute "app/minecraft/online-mode"
    :display_name => 'Online mode',
    :description => 'Whether the server will verify usernames with minecraft.net'
    :required => false,
    :default => 'no',
    :choice => ['yes','no'],
    :advanced => false

attribute "app/minecraft/monsters"
    :display_name => 'Spawn Monsters',
    :description => 'Spawn Monsters'
    :required => false,
    :default => 'no',
    :choice => ['yes','no'],
    :advanced => false

attribute "app/minecraft/max-players"
    :display_name => 'Maximum Players',
    :description => 'Maximum Players'
    :required => false,
    :default => '20',
    :advanced => false,
    :validations => {regex: /^\d+$/}

attribute "app/minecraft/level-name"
    :display_name => 'Level Name',
    :description => 'Name for the level'
    :required => false,
    :default => '20',
    :advanced => false,

attribute "app/minecraft/server-port"
    :display_name => 'Minecraft Server listen port',
    :description => 'Minecraft Server listen port',
    :required => false,
    :default => '20',
    :advanced => false,
    



