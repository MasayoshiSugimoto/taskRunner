use strict;
use warnings;

package Misc;

use Logger;
use Process;
use List;

my $logger = new Logger('Misc');

sub checkArguments {
  my ($argumentsRef) = @_;
  my %arguments = %$argumentsRef;
  my @names = keys %arguments;
  foreach my $name (@names) {
    if (!defined($arguments{$name})) {
      $logger->error("name: $name");
      die "Argument not defined: $name";
    }
  }
  return $argumentsRef;
}

sub checkEmpty {
  my $value = shift;
  $value or die "Empty parameter";
}

sub startApp {
  my ($applications, $appName) = @_;
  foreach my $app ($applications) {
    if ($app->{application} == $appName) {
      Process::start($app->{cmd});
    }
  }
}

1;
