#!C:/Perl64/bin/perl.exe

  use strict;
  use warnings;
  use Cwd;
  
  my $script_location = cwd();
  
  my $sqlsrv = $ARGV[0];
  
  #my $sqlFile = $sql_location . $sql_filename;
  my $outLocation = ${script_location}.'/SPLIT/';
  
    @ARGV or die "Input file required as command-line parameter\n";
    
    my $out;
    my $replace = '';
    my $array_ref;

    my $lines = '';

    #loop through file and identifil numeric '0000' with 'RAW' in string
	while (<>) {
	    
	  if ( /(\d+)\*+RAW$/ ) {
	    
	    push @{$array_ref}, $lines;
	    $lines = [];
    
	  };
	  $_ =~ s/UNION ALL/$replace/g;
    
	  #join lines to be pushed into array
	  $lines = join($lines, "\n", $_);
	
	};
    
    #push last item into string
    push @{$array_ref}, $lines;
    
    #loop through n elemnts in the array and print them out
    my $count = scalar(@{$array_ref}) - 1;

	#data cleanup remove unwanted characters
	foreach my $array_ref (@{$array_ref})
	{
		$array_ref =~ s/([ARRAY]+)\(([^)]+)\)//g;
		$array_ref =~ s/^\s+//;
	}
    
	#first 2 elemnts are not needed
	while ($count != 2) {
	    
	    $count--;
	    
	    open $out, '>', $outLocation."$count.$sqlsrv" or die $!;
	    select $out;
	    
	    #get first element in array
	    print " \n $array_ref->[1]";
	    #get current elemnt in array
	    print " \n $array_ref->[$count]";
	    #get last element in array
	    print " \n $array_ref->[-1]";
	    
	}
    
