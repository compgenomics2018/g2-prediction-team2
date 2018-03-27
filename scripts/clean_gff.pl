use strict;
use warnings;

my $fileList = $ARGV[0];
my $path = $ARGV[1];
my $outpath = $ARGV[2];

my @list;

open(LISTFILE, $fileList) or die "Could not open $fileList\n";
while (<LISTFILE>)
{
    chomp $_; #remove end line symbol
    $_ =~ s/\r//g; #remove carriage return

    push @list, $_;
}

my $files = scalar @list;

for (my $i = 0; $i < $files; $i++)
{
    open(OUT, "+>", $outpath.$list[$i]);
    open(FILE, $path.$list[$i]) or die "Could not open $list[$i]\n";
    while (<FILE>)
    {
	chomp $_; #remove end line symbol
	$_ =~ s/\r//g; #remove carriage return

	    if ($_ =~ m/^#/)
	    {
		next;
	    }
	    elsif ($_ =~ m/^\s/)
	    {
		next;
	    }
	    else
	    {
		print OUT "$_\n";
	    }
    }
}
