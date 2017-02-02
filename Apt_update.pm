###############################################################################
## OCSINVENTORY-NG
## Copyleft Simon Falicon 2016 based on Guillaume PROTET 2010
## Srouce : http://wiki.ocsinventory-ng.org/index.php?title=Plugins:Crontab/fr
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################

package Ocsinventory::Agent::Modules::Update;

use File::Find;
use Data::Dumper;

sub new {
   my $name="update";   # Name of the module
   my (undef,$context) = @_;
   my $self = {};

   #Create a special logger for the module
   $self->{logger} = new Ocsinventory::Logger ({
            config => $context->{config}
   });

   $self->{logger}->{header}="[$name]";

   $self->{context}=$context;

   $self->{structure}= {
                        name => $name,
                        start_handler => $name."_start_handler",    #or undef if don't use this hook
                        prolog_writer => undef,    #or undef if don't use this hook
                        prolog_reader => undef,    #or undef if don't use this hook
                        inventory_handler => $name."_inventory_handler",    #or undef if don't use this hook
                        end_handler => undef    #or undef if don't use this hook
   };

   bless $self;
}

######### Hook methods ############
sub update_start_handler {
   my $self = shift;
   my $logger = $self->{logger};
   my $common = $self->{context}->{common};

   $logger->debug("Calling crontab_start_handler");
}

sub update_inventory_handler {         #Use this hook to add or modify entries in the inventory XML
   my $self = shift;
   my $logger = $self->{logger};

   my $common = $self->{context}->{common};

   #I add the treatments for my new killer feature
   $logger->debug("Yeah you are in update_inventory_handler :)");

   #I am a killer, I get the update file....
   find({wanted => sub { wanted($self); } }, '/tmp/update');
}

sub wanted {
   my $self = shift;
   my $common = $self->{context}->{common};
   my $file = '/tmp/update';
   my $number;

   open my $info, $file or die "Could not open $file: $!";
   print STDERR .<$info>."\n";

   while( my $line = <$info>)  {
        $number = $number + 1;
   }
   close $info;

   open my $info, $file or die "Could not open $file: $!";
   print STDERR .<$info>."\n";

   while( my $line = <$info>)  {
        chomp($line=$line);
        ($app, $version, $update) = split(" ", $line);
        &addUpdate($common->{xmltags},{
            APP => $app,
            VERSION => $version,
            APT_UPDATE => $update,
 	          NUMBER => $number,
        });
   }
   close $info;

}

#I create my own subroutine to add my own killing XML tags !!
sub addUpdate {
   my ($xmltags,$args) = @_;
   my $ocsapp = $args->{APP};
   my $ocsversion = $args->{VERSION};
   my $ocsupdate = $args->{APT_UPDATE};
   my $ocsnumber = $args->{NUMBER};

   push @{$xmltags->{APT_UPDATE}},
   {
      APP => [$ocsapp],
      VERSION => [$ocsversion],
      APTUPDATE => [$update],
      NUMBER => [$ocsnumber],
   };
}

1;
