package Import::XML;
use strict;
use warnings;
use feature ':5.10';

use Exporter qw(import);
use Data::Dumper;

use XML::LibXML;
use SQL::Abstract;

our @EXPORT = qw( import_xml );

sub import_xml {
  my ($xml_file, $maps, $dbh) = @_;
  my $dom = XML::LibXML->load_xml(location => $xml_file);
  my $sql = SQL::Abstract->new(array_datatypes => 1);
  my $normalXML = process_xml_forecast($dom, $xml_file, $maps);
  
  for my $a (@$normalXML) {
    my($stmt, @bind) = $sql->insert('forecasts', $a);
    my $sth = $dbh->prepare($stmt);
    $sth->execute(@bind);
  }
}

sub process_xml_forecast {
    my ($dom, $xml_file, $maps) = @_;
    my @normalXML;
    foreach my $rec ($dom->findnodes('//countries/country/location')) {
      my @attrs= $rec->findnodes( "./@*");
      my %attributes;
      $attributes{'create_system'} = 'Test System';
      $attributes{'create_source'} = $xml_file;

      foreach my $attr (@attrs){
        $attributes{$maps->{$attr->nodeName}} = $attr->value;
      }

      foreach my $forecast ($rec->findnodes( "./forecasts/forecast")) {
        my %normalise = (%attributes);
        $normalise{'forecast_date'} = $forecast->findvalue('./date');
        $normalise{'temp_min'} = $forecast->findvalue('./temp_min_c');
        $normalise{'temp_max'} = $forecast->findvalue('./temp_max_c');
        $normalise{'weather_icon'} = $forecast->findvalue('./icon');
        push ( @normalXML, \%normalise );
      }
    }
    return \@normalXML;
}
