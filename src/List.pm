use strict;
use warnings;

package List;

use Data::Dumper;
use Misc;

sub new {
  my $class = shift;
  my $self = { _array => Misc::checkEmpty(shift) };
  bless $self, $class;
  return $self;
}

sub get {
  my ($self, $index) = @_;
  my $result = ${$self->{_array}}[$index] or die "Index out of bound";
  return $result;
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

sub map {
  my ($self, $f) = @_;
  my @result = ();
  foreach my $element (@{$self->{_array}}) {
    push(@result, $f->($element));
  }
  return new List(\@result);
}

sub size {
  my ($self) = @_;
  return scalar(@{$self->{_array}});
}

sub toArray {
  my ($self) = @_;
  my @copy = @{$self->{_array}};
  return \@copy;
}

sub toString {
  my ($self) = @_;
  return Dumper($self->{_array});
}

1;
