#!/usr/bin/perl

use lib '.';

use strict;
use warnings;

use Process;
use Logger;
use Misc;
use List;
use Scalar::Util qw(looks_like_number);

use constant {
  FALSE => 0,
  TRUE  => 1
};

my $logger = new Logger('main');

sub onlyTestProcess {
  my $process = shift;
  return $process->{_command} =~ m/test/;
}

sub printLine {
  my $text = shift;
  print $text . "\n";
}

sub invalidCommand {
  printLine('ERROR: Invalid command');
  startScreen();
}

sub startScreen {
  clearScreen();
  displayApplications();

  my $screen = <<'END_MESSAGE';
Select an action
================

1. Start application
2. Kill application

Enter the command number and press enter.
END_MESSAGE
  print($screen);

  my $userCommand = <>;

  if (!looks_like_number($userCommand)) {
    invalidCommand();
  } elsif ($userCommand == 1) {
    startApplication();
  } elsif ($userCommand == 2) {
    killApplication();
  } else {
    invalidCommand();
  }
}

sub displayApplications {
  my $message = <<'END_MESSAGE';
Running applications
====================
END_MESSAGE
  print($message);
  my $runningApplications = new List(Process::read())
    ->filter(\&onlyTestProcess);

  $runningApplications->foreach(sub { printLine(shift(@_)->toJSON()); });
  if ($runningApplications->size() == 0) {
    printLine('No application running');
  }
  printLine('');
}

sub startApplication {
  printLine('Starting application...');
  Process::start('./testProcess.sh');
}

sub killApplication {
  printLine('Killing application...');
  new List(Process::read())
    ->filter(\&onlyTestProcess)
    ->foreach(sub{ shift(@_)->kill(); });
}

sub clearScreen {
  system("clear");
}

while (TRUE) {
  startScreen();
}
