#!/usr/bin/env perl
#
# Quick hack at a Perl version for generating random (repo) names.
#
# Added support for "short" names.
#

use Getopt::Long;

my $TOPDIR=".";

my $adjectives_file = "$TOPDIR/data/adjectives.txt";
my $animals_file    = "$TOPDIR/data/animals.txt";

my $opt_help  = 0;
my $opt_upper = 0;
my $opt_short = 0;
my $SHORT_LIMIT = 3;  # Max length for "short" string option

sub usage
{
    print <<EOF;
Usage: $0 [OPTIONS]

   -u|--upper      Show name as UPPERCASE.
   -s|--short      Show a short name
   -h|--help       Print this help message

EOF
    return;
}


#
# Best effort to find a random item in input list that is
# less-than-equal to $SHORT_LIMIT length.  We have a crude
# max try method of only trying N times, where N=num items in list.
# In that case, you could return value greater than $SHORT_LIMIT, but
# will always return some value.
#
sub get_short_value(@)
{
    my @input = @_;
    my $done = 0;
    my $value;
    my $num_input = scalar(@input);
    my $count = $num_input;  # Fail-safe, add try counter to avoid infinite loop

    do {
        $count--;

        my $rand  = int( rand($num_input) );

        $value = $input[ $rand ];

        my $len = length( $value );

        if ( ($len <= $SHORT_LIMIT) || ($count < 0) ) {
            $done = 1;
        }

        #print "DONE=$done, COUNT=$count, LEN=$len, VALUE=$value, RAND=$rand\n";
    } while (!$done);

    return $value;
}

sub get_value(@)
{
    my @input = @_;
    my $value;
    my $rand;
    my $num_input = scalar(@input);

    $rand  = int( rand($num_input) );
    $value = $input[ $rand ];

    return $value;
}

########
# MAIN
########

my $rc = GetOptions(
            "help"         => \$opt_help,
            "upper"        => \$opt_upper,
            "short"        => \$opt_short,
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

my $w1, $w2;

if ($opt_short) {
    $w1 = get_short_value(@list1);
    $w2 = get_short_value(@list2);
} else {
    $w1 = get_value(@list1);
    $w2 = get_value(@list2);
}

if ($opt_upper) {
    # Print codename in UPPERCASE
    print uc "$w1-$w2\n";
} else {
    # Print codename in lowercase
    print lc "$w1-$w2\n";
}

exit (0);
