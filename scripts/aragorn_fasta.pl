use strict;
use warnings;

my $input_file = $ARGV[0];
my $output_file = $ARGV[1];
  print STDERR "                            \rProcessing $input_file...\r";

  if ($input_file) {
      open (INFILE, "<$input_file") ||
  	die "Can not open file for input at $input_file\n";
  }
  if ($output_file) {
      open (FAOUT, ">$output_file") ||
  	die "Can not open output file for output at $output_file";
  }
  else {
      open (FAOUT, ">&STDOUT" ) ||
  	die "Can not  open STDOUT for output. Specify outfile with -o option\n"
  }

  my $feature;
  my $location;
  while (<INFILE>) {
      chomp $_;
      if (m/^scaffold/){
      $feature=$_;
      }
      elsif (m/^\>(.*)/) {
  	    my $line = ">".$feature." ".$1;
  	    print FAOUT $line."\n";
      }
      elsif (m/^Location/) {
        my @line = split('\s');
       $location = $line[1];
      }
      elsif (m/^tmRNA/) {
  	    my @line = split('\s');
  	    print FAOUT ">".$line[3]." tmRNA ".$location."\n";
      }
      elsif(m/^[acgtATCG]+$/){
        print FAOUT $_."\n";
      }
      else {next;};
}
close INFILE;
close FAOUT;
  exit;
