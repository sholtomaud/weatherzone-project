package Import::CSV;
use strict;
use warnings;

use Exporter qw(import);
use Data::Dumper;
use Text::CSV_XS qw( csv );

our @EXPORT = qw( import_csv );

sub import_csv {
  my ($csv_file, $maps, $dbh) = @_;

  my $sql = SQL::Abstract->new(array_datatypes => 1);
  my $csvForecast = csv (in => $csv_file, headers => "auto");

  my @normalCSV = map { process_csv_forecast($_, $csv_file, $maps)  } @$csvForecast;
  foreach $a (@normalCSV) {
    my($stmt, @bind) = $sql->insert('forecasts', $a);
    my $sth = $dbh->prepare($stmt);
    $sth->execute(@bind);
  }
}

sub process_csv_forecast {
  my ($vals, $csv_file, $maps) = @_;
  my %normalCSV;
  $normalCSV{'loc_type'} = 'TWCID';
  $normalCSV{'create_system'} = 'Test System';
  $normalCSV{'create_source'} = $csv_file;
  while(  my($k, $v) = each $vals  ) {
    $normalCSV{$maps->{$k}} = $v;
  }
  return \%normalCSV;
}
