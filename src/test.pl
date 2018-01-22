#!/usr/bin/perl

use lib '.';

use strict;
use warnings;

use Configuration;
use Data::Dumper;

my $config = new Configuration('../config/applications.json');

print $config->applicationNames()->toString();
