use strict;
use warnings;

package List;

sub new {
  my $class = shift;
  my $self = { _array => Misc::checkEmpty(shift) };
  bless $self, $class;
  return $self;
}

sub tail {
  my ($self) = @_;
  my @newArray = @$self->{_array};
  shift @newArray;
  return $self;
}

sub filter {
  my ($self, $f) = @_;
  my @filtered = ();
  foreach my $element (@{$self->{_array}}) {
    if ($f->($element)) { push(@filtered, $element); }
  }
  return new List(\@filtered);
}

sub foreach {
  my ($self, $f) = @_;
  foreach my $element (@{$self->{_array}}) {
    $f->($element);
  }
}

sub size {
  my ($self) = @_;
  return scalar(@{$self->{_array}});
}

1;
