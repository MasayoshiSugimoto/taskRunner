use strict;
use warnings;

package Logger;

use constant {
  ERROR    =>  0,
  WARNING  =>  1,
  INFO     =>  2,
  DEBUG    =>  3
};

my $_level = INFO;

sub new {
  my $class = shift;
  my $self = {
    _name   => shift
  };
  bless $self, $class;
  return $self;
}

sub printLine {
  my ($self, $text) = @_;
  print("[$self->{_name}] $text\n");
}

sub info {
  my ($self, $text) = @_;
  if ($_level >= INFO) { $self->printLine($text); }
}

sub debug {
  my ($self, $text) = @_;
  if ($_level >= DEBUG) { $self->printLine($text); }
}

sub error {
  my ($self, $text) = @_;
  if ($_level >= ERROR) { $self->printLine($text); }
}

1;
