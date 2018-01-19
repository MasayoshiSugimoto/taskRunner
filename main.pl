#!/usr/bin/perl

use strict;
use warnings;

use Process;
use Logger;
use Misc;
use List;

my $logger = new Logger('main');

sub onlyTestProcess {
  my $process = shift;
  return $process->{_command} =~ m/test/;
}

new List(Process::read())
  ->filter(\&onlyTestProcess)
  ->foreach(sub{ shift(@_)->kill(); });

new List(Process::read())
  ->filter(\&onlyTestProcess)
  ->foreach(sub { $logger->info(shift(@_)->toJSON()); });
