#!/usr/bin/perl
use strict;

my @PARAMS_NEEDED = qw(cookbook);

my $OPTIONS = {
    cookbook => undef,
    cookbook_path=> 'cookbooks',
    action => 'converge',
    suite => 'default'
};

my @VALID_CONFIGURABLE_OPTIONS = qw(cookbook action suite);

my $DEFAULT_BASE_IMAGE = '4eixos/cookbooks_dev';

&load_cli_options;

&check_options;

&run_kitchen;


sub check_options {
    foreach my $p (@PARAMS_NEEDED){
        die("Param needed $p") unless($OPTIONS->{$p})
    }

    die("Cookbook ".$OPTIONS->{cookbook}." not exists") unless(-d $OPTIONS->{cookbook_path}.'/'.$OPTIONS->{cookbook});

    return 1;
}

sub run_kitchen{

    my $cmd = 'cd '.$OPTIONS->{cookbook_path}.'/'. $OPTIONS->{cookbook}.' && '.
'docker run -ti --rm \
-v ${PWD}/../..:/home/chef_repo \
-v ${PWD}:/home/kitchen \
-e LOCAL_COOKBOOKS_PATH=${PWD}/../.. \
-e DOCKER_HOST=tcp://172.17.0.1:4243 \
'.$DEFAULT_BASE_IMAGE.' bash -c \'cd /home/kitchen && kitchen '.$OPTIONS->{action}.' '.
(($OPTIONS->{action} =~ /version|list/)? '' : $OPTIONS->{suite}).
'\'';

    print $cmd."\n";
    system $cmd;
}


sub load_cli_options{
    help() unless(@ARGV);

    foreach my $arg (@ARGV){

        my ($option, $value) = split /\=/, $arg;
    
        next unless (grep {$_ eq $option} @VALID_CONFIGURABLE_OPTIONS);

        $OPTIONS->{$option} = $value;
    }
}

sub help{
    my $usage = "Usage: $0 ";

    while(my ($key,$value) =  each(%$OPTIONS)){

        next unless(grep {$_ eq $key} @VALID_CONFIGURABLE_OPTIONS);

        $usage .= "$key=$key";
        $usage .= " (default:$value)" if($value);
        $usage .= " ";
    }

    print $usage."\n";

}
