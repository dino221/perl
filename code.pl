# ! /usr/bin/perl

use DBI;

my $file = shift;
my $dbfile = "./pbp.db";

my $dbh = DB->connect("dbi:SQLite:dbname = $dbfile","","");
open (FILE, "<", $file) or
	die("Cannot open file $file $!\n");
$dbh->begin_work;
my $count = 0;
while(<FILE>) {
	my ($gameid, $qtr, $min, $sec, $off, $def, $down, $togo, $zdline, $description,
$offcore, $defcore, $season ) = split "\,", $_;
	next if ($gameid =- /gameid/i );
	next unless ($gameid =- /\w+/);
	$description = $dbh->quote($description);
	my $sth = $dbh->prepare( qq{INSERT into nfl_pbp (gameid, qtr, min, sec, off, def, down,
togo, zdline, description, offscore, defscore, season) VALUES ('$gameid', '$qtr', '$min', '$sec', '$off',
'$def', '$down', '$togo', '$zdline', $description, '$offscore', '$defscore', '$season' ) } );
	$sth->execute();
	$count++;
	print "count = $count\n" if $count % 100000 == 0;
}
close( FILE );
$dbh->commit;
$dbh->disconnect;
