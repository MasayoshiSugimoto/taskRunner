use strict;
use warnings;

package Process;

require Misc;
require Logger;

my $logger = new Logger('Process');

sub new {
  my $class = shift;
  my $self = Misc::checkArguments({
    _pid      => shift,
    _command  => shift
  });
  bless $self, $class;
  return $self;
}

sub pid {
  my ($self) = @_;
  return $self->{_pid};
}

sub command {
  my ($self) = @_;
  return $self->{_command};
}

sub toJSON {
  my ($self) = @_;
  return "{ pid: $self->{_pid}, command: $self->{_command} }";
}

sub kill {
  my ($self) = @_;
  kill('KILL', $self->{_pid});
}

sub pidFilter {
  my ($pid) = @_;
  return sub {return shift(@_)->pid() == $pid;};
}

sub read {
  my @output = split(/\n/, `ps -x`);
  shift @output; #First line is the header
  my @processes = ();
  $logger->debug('Reading processes...');
  foreach my $line (@output) {
    my ($pid, $command) = ($line =~ m/([0-9]+) +[^ ]+ +[^ ]+ +[^ ]+ +(.*)/);
    $logger->debug($line);
    push(@processes, new Process($pid, $command));
  }
  return \@processes;
}

sub start {
  my ($cmd) = @_;
  #Launch the process in background
  if (system("$cmd") != 0) {
    $logger->error("Failed to launch process with command: $cmd");
  }
}

1;
