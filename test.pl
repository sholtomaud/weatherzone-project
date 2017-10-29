#/usr/lib/perl
use strict;
use warnings;
use feature ':5.10';

use JSON::Parse qw( parse_json );
use Data::Dumper;
use DBI;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Import::CSV;
use Import::XML;
use Export::TSV;

my $dbh = DBI->connect("DBI:mysql:database=test;host=localhost", "root", "", { PrintError => 1,  RaiseError => 0,  AutoCommit => 1 })
      or die "Can't connect to database: $DBI::errstr!";

my $mappings;
{
  local $/;
  open my $fh, "<", "mappings.json";
  $mappings = <$fh>;
  close $fh;
}
my $maps = parse_json ($mappings);

import_csv( 'twc_fcast_4day_capcity.csv', $maps, $dbh );
import_xml( 'twc_fcast_4day_capcity.xml', $maps, $dbh );
export_tsv( 'output.tsv', $dbh )
