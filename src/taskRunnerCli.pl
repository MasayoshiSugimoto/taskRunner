#!/usr/bin/perl

use lib '.';

use strict;
use warnings;

package taskRunnerCli;

use Scalar::Util qw(looks_like_number);

use Process;
use Logger;
use Misc;
use List;
use Configuration;

use constant {
  FALSE => 0,
  TRUE  => 1
};

my $logger = new Logger('main');
my $config = new Configuration('../config/applications.json');

sub onlyTestProcess {
  my $process = shift;
  return $process->{_command} =~ m/test/;
}

sub printLine {
  my $text = shift;
  print $text . "\n";
}

sub invalidComponent {
  my $component = <<'END_MESSAGE';
ERROR
=====
Invalid command

END_MESSAGE
  return $component;
}

sub refresh {
  my ($input) = @_;
  clearScreen();
  displayApplications();
  print($input->{error});
  return $input->{mainComponent}->();
}

my $processFormat = '%6s%50s';

sub processToString {
  my ($process) = @_;
  return sprintf($processFormat, $process->pid(), $process->command());
}

sub displayApplications {
  my $message = <<'END_MESSAGE';
Running applications
====================
END_MESSAGE
  print($message);

  my $runningApplications = new List(Process::read())
    ->filter(\&onlyTestProcess);
  if ($runningApplications->size() == 0) {
    printLine('No application running');
  } else {
    printf("$processFormat\n", 'PID', 'Command');
    $runningApplications->foreach(sub { printLine(processToString(shift(@_))); });
  }
  printLine('');
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

sub commandSelector {
  my $component = <<'END';
Select a command
================
1. Start an application
2. Kill an application

Enter a command number and press enter:
END
  print $component;

  my $userCommand = <>;
  if (!looks_like_number($userCommand)) {
    return invalidCommandInput();
  }

  if ($userCommand == 1) {
    return buildScreenInput(\&startApplicationComponent);
  } elsif ($userCommand == 2) {
    return buildScreenInput(\&killApplicationComponent);
  } else {
    return invalidCommandInput();
  }
}

sub startApplicationComponent {
  my $component = <<'END';
Start an application
====================
END
  print $component;
  my $applications = $config->applicationNames();

  for (my $index = 0; $index < $applications->size(); $index++) {
    printLine($index . ". " . $applications->get($index));
  }
  printLine('');
  printLine('Enter the application to start and press Enter:');

  my $userCommand = <>;
  if (!looks_like_number($userCommand)) {
    return invalidCommand();
  }

  if ($userCommand >= $applications->size()) {
    return errorInput('Wrong application number');
  }

  Process::start($config->applications()->get($userCommand)->{cmd});
  return defaultScreenInput();
}

sub error {
  my ($text) = @_;
  my $component = <<'END';
ERROR
=====
END
  return $component . "$text\n\n";
}

sub errorInput {
  my ($text) = @_;
  return {
    error => error($text),
    mainComponent => \&commandSelector
  };
}

sub invalidCommandInput {
  return errorInput('Invalid command');
}

sub killApplicationComponent {
  my $component = <<'END';
Kill an application
===================

Enter the PID of the application you want to kill and press enter:
END
  print $component;

  my $pid = <>;
  if (!looks_like_number($pid)) {
    return invalidCommand();
  }

  my $process = new List(Process::read())
    ->filter(Process::pidFilter($pid));

  if ($process->size() == 0) { return errorInput('Wrong pid'); }

  if ($process->size() != 1) {
    die 'Impossible to have more than one process with the same pid';
  }

  kill('KILL', $pid);
  return defaultScreenInput();
}

sub defaultScreenInput { return buildScreenInput(\&commandSelector); }

sub buildScreenInput {
  my $component = shift;
  return {
    error          =>  '',
    mainComponent  =>  $component
  };
}

my $screenInput = defaultScreenInput();
while (TRUE) {
  $screenInput = refresh($screenInput);
}
