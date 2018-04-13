#!/usr/bin/env perl
#
# Quick hack at a Perl version for generating random (repo) names.
#
#

use Getopt::Long;

my $TOPDIR=".";

my $adjectives_file = "$TOPDIR/data/adjectives.txt";
my $animals_file    = "$TOPDIR/data/animals.txt";

my $opt_help  = 0;
my $opt_upper = 0;

sub usage
{
    print <<EOF;
Usage: $0 [OPTIONS]

   -u|--upper      Show name as UPPERCASE.
   -h|--help       Print this help message

EOF
    return;
}


########
# MAIN
########

my $rc = GetOptions(
            "help"         => \$opt_help,
            "upper"        => \$opt_upper,
                    );

if ($opt_help) {
    usage();
    exit(0);
}


# Open data files
open (FILE1, $adjectives_file) || die "Error: $! '$adjectives_file'";
open (FILE2, $animals_file)    || die "Error: $! '$animals_file'";

# Read data into array
my @list1 = <FILE1>;
chomp(@list1);

# Read data into array
my @list2 = <FILE2>;
chomp(@list2);

# Close data files
close (FILE1);
close (FILE2);

# Get number of items in array
my $file1_max = scalar @list1;
my $file2_max = scalar @list2;

# Get random entry from each array
my $rand1 = int (rand($file1_max));
my $rand2 = int (rand($file2_max));

#print "file1_max: $file1_max  file2_max: $file2_max\n";
#print "    rand1: $rand1  rand2: $rand2\n";

my $w1 = $list1[$rand1];
my $w2 = $list2[$rand2];

if ($opt_upper) {
    # Print codename in UPPERCASE
    print uc "$w1-$w2\n";
} else {
    # Print codename in lowercase
    print lc "$w1-$w2\n";
}

exit (0);
