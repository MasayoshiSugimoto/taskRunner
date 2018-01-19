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

sub toJSON {
  my ($self) = @_;
  return "{ pid: $self->{_pid}, command: $self->{_command} }";
}

sub kill {
  my ($self) = @_;
  kill('KILL', $self->{_pid});
}

sub read {
  my @output = split(/\n/, `ps -x`);
  shift @output; #First line is the header
  my @processes = ();
  $logger->debug('Reading processes...');
  foreach my $line (@output) {
    my ($pid, $command) = ($line =~ m/([0-9]+) +[^ ]+ +[^ ]+(.*)/);
    $logger->debug($line);
    push(@processes, new Process($pid, $command));
  }
  return \@processes;
}

1;
