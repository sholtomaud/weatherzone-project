package Export::TSV;
use strict;
use warnings;

use Exporter qw(import);
use Data::Dumper;

our @EXPORT = qw( export_tsv );

my $sql = qq/SELECT loc_code, loc_name, forecast_date, weather_icon, temp_min, temp_max  FROM forecasts ORDER BY loc_code, forecast_date;/;

sub export_tsv {
  my ( $export_filename, $dbh ) = @_;
  open(my $fh, '>', $export_filename);
  print $fh "loc_code|name|date|icon|min_temp|max_temp\n";
  my $sth = $dbh->prepare($sql);
  $sth->execute();
  my @row;
  while (@row = $sth->fetchrow_array) {
      print $fh join("|", @row), "\n";
  }
  close $fh;
  print "done\n";
}
