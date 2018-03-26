
use strict;
use warnings;


my $gff_ver = "GFF3";

my $source = "Aragorn";

my $input_file = $ARGV[0];
my $output_file = $ARGV[1];

  print STDERR "                            \rProcessing $input_file...\r";
if ($input_file) {
    open (INFILE, "<$input_file") ||
	die "Can not open file for input at $input_file\n";
}
if ($output_file) {
    open (GFFOUT, ">$output_file") ||
	die "Can not open output file for output at $output_file";
}
else {
    open (GFFOUT, ">&STDOUT" ) ||
	die "Can not open STDOUT for output. Specify outfile with -o option\n"
}

print GFFOUT "##gff-version 3\n";

#-----------------------------+
# MAIN PROGRAM BODY           |
#-----------------------------+
my $seq_id;
my $start;
my $end;
my $score = ".";
my $strand;
my $phase = ".";
my $attribute;
my $gff_str;
my $num_result = 0;
my $aa;
my $type_aa;
my $type;

while (<INFILE>) {

    chomp;
#    print STDERR $_."\n";

    if (m/^\>(.*)/) {
#	print STDERR $_."\n";
	my $line = $1;
	my ($seq_id,$trna_type,$loc) = split(/\s+/, $line);
	if ($loc =~ m/c\[(.*)\,(.*)\]/ ){
#	    # I think this is complement strand
	    $start = $1;
	    $end = $2;
	    $strand = "-";
	}
	elsif ($loc =~ m/\[(.*)\,(.*)\]/ ){
	    $start = $1;
	    $end = $2;
	    $strand = "+";
	}
	else {
	    $strand = "+";
	    $start = "ERR";
	    $end = "ERR";
	}
	if ($trna_type =~ m/(.*)\-(.*)\((.*)\)/) {
		 	$type=$1;
	    $type_aa = $2;
	    $aa = $3;
	}
	if ($trna_type =~ m/tmRNA/) {
		 	$type="tmRNA";
	    $type_aa = "";
	    $aa = "";
	}
  
  my $attribute = "ID=".$type_aa."-".$type.";Name=".$type_aa.";anticodon=".$aa;

	# TEST GFF 3 STRING
	print GFFOUT $seq_id."\t".
	    $source."\t".
	    $type."\t".
	    $start."\t".
	    $end."\t".
	    $score."\t".
	    $strand."\t".
	    $phase."\t".
	    $attribute."\t".
	    "\n";

    }
		else{next;}
    }

exit;
