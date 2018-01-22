use strict;
use warnings;

package Configuration;

use JSON;
use List;

sub new {
  my $class = shift;
  my $self = {
    _path   => shift
  };
  bless $self, $class;
  return $self;
}

sub applications {
  my ($self) = @_;

  my $fileContent = '';
  open(my $fileHandle, '<:encoding(UTF-8)', $self->{_path})
    or die "Could not open file '$self->{_path}' $!";
  while (my $row = <$fileHandle>) {
    $fileContent = $fileContent . $row;
  }

  my $json = JSON->new->allow_nonref;
  return new List($json->decode($fileContent));
}

sub applicationNames {
  my ($self) = @_;
  return $self->applications()
    ->map(sub {return ${shift(@_)}{application}});
}

1;
