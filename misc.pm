use strict;
use warnings;

package Misc;

use Logger;

my $logger = new Logger('argumentChecker');

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

1;
