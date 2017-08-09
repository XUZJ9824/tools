#use strict;
use warnings;

sub test {
    my %comments_of_url = ();

    open FILE, "<C:/Users/e427632/Desktop/CR/CR15390/EPIC-CMF-LC-WITH15267-.txt" or die $!;
    while (<FILE>) {

        # Skip empty lines
        next if /^\s*$/;

        # Use url as key and #xxx as value for each line
        # Merge all the #xxx for a url
        if (/amscript_cd\("(.*?)"\)\){__amscript_wc\('(.*?)\s+\{/) {
            $comments_of_url{ $1 } .= ( $2 . ',' );
        }            
    }

    foreach my $key (keys %comments_of_url) {
        chomp (my $value = $comments_of_url{$key});
        print q{Lif(__amscript_cd("};
        print $key;
        print q#")){__amscript_wc('#;
        print $value;
        print q#{display:none;}');};#;
        print "\n";
    }
}

sub test2{
    my $logName = "<Z:/Project/EJET PM-CPDLC Support/MKII_757_flight_test/2015_06_08_Flight_1/CMU_Logs/CMU_2015_06_08/CMU_2015_06_08.log";
    my $xls429 = "Z:\\Project\\EJET PM-CPDLC Support\\MKII_757_flight_test\\2015_06_08_Flight_1\\Parsed_429\\VDLM2_ATN-618_wTabs.xlsx"; 
    
    print "\n$logName\n$xls429\n";
    
    #Get log buffer array @allBuffers
        open (fileOpen, $logName) or die $!;
        
        #print $% , "\n";
        #print $= , "\n";;
        #print $- , "\n";;
        #print $~ , "\n";;
        #print $^ , "\n";;
        
        #my $cwd = system("dir"); 
        #print $cwd;
        
        #$cwd = `dir`;
        #print $cwd;
        
        my $aflag = 0;
        my $tmpline;
        my $tmpCombinedBuf;
        my @allBuffers;
        
        while (<fileOpen>) {
            #print "before next";
            #print $_;
            # Skip empty lines
            #next if /^\s*$/;       
            
            if (/IP>3: U\/L/) {
                #printf "\nStart Pattern\n";
                $aflag = 1; #Start pattern
                next;
            }
            elsif (/:IP>msg_size =/){
                #print "\nEnd Pattern \n";
                $aflag = 0; #End Pattern
                #print "\n$tmpCombinedBuf\n";
                @allBuffers[++$#allBuffers] = $tmpCombinedBuf;
                $tmpline = "";
                $tmpCombinedBuf ="";
            }
            
            if( $aflag == 1 )
            {
                $tmpline = $_;
                #print "Origin :$tmpline\n";                     
                $tmpline =~ s/^.*IP>//; #remove leading string till IP>
                $tmpline =~ s/ //g; #remove space char
                $tmpline =~ s/[\r\n]*//g;   #remove trailing \r or \n
                #print "New :$tmpline\n";            
                $tmpCombinedBuf = $tmpCombinedBuf.$tmpline;
            }             
        }
        #print STDOUT $_;
        
    #Parse XLS against @allBuffers
        use Win32::OLE qw(in with);
        use Win32::OLE::Const 'Microsoft Excel';        
        
        # get already active Excel application or open new
        my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
            || Win32::OLE->new('Excel.Application', 'Quit');

        # open Excel file
        my $Book = $Excel->Workbooks->Open($xls429);
        my $Sheet = $Book->Worksheets(1);
        my $Tot_Rows= $Sheet->UsedRange->Rows->{'Count'}; 

        foreach my $row (1..$Tot_Rows)
        {
                # skip empty cells
                my $cellType = $Sheet->Cells($row,5);
                my $cell429Buf = $Sheet->Cells($row,57);
                
                next unless defined $cellType ->{'Value'};
                
                my $tmpMsgType = $cellType -> {'Formula'};
                my $tmp429Msg = $cell429Buf ->{'Formula'};
                
                #replace 0 or more whitespaces at the beginning
                #     or 0 or more whitespaces at the end
                #     with nothing
                $tmpMsgType =~ s/^\s+|\s+$//g;               

                next unless $tmpMsgType eq "U INFO FRAME";
                                
                # print out the contents of a cell  
                # printf "At ($row, 5) %s\n", $cellType ->{'Value'}; 
                # printf "At ($row, 57) %s\n", $cell429Buf ->{'Value'}; 
        
                my $findbuf = 0;                
                #print $tmp429Msg;
                
                foreach my $buf (@allBuffers)
                {
                    #printf "Check $buf\n";                    
                    if ( $tmp429Msg eq $buf  )
                    {          
                        $findbuf = 1;
                        printf "Find Row $row\n";
                        last;                        
                    }
                }
                
                if( $findbuf == 0 ){
                    printf "Not Find Row: $row - %s\n", $tmp429Msg;
                }

        }
}

sub test3{
  open(GRADES, "grades.txt") or die "Can't open grades: $!\n";
  
  $cnt = 0;
  while (my $line = <GRADES>) {
      $cnt += 1;
      
      print 'cnt = ' . $cnt . " : " . $line. "\n";
  
      (my $student, my $grade) = split(" ", $line);
      $grades{$student} .= $grade . " ";
      
      print $student. "\n";
      print $grades{$student}. "\n";
  }
 

 
  foreach $student (sort keys %grades) {
      $scores = 0;
      $total = 0;    
      @grades = split(" ", $grades{$student});
      foreach $grade (@grades) {
         $total += $grade;
          $scores++;
      }
      $average = $total / $scores;
      print "$student: $grades{$student}\tAverage: $average\n";
  }
  
}

sub test4{
    use Spreadsheet::XLSX;

    my $xlsFileName = "Z:\\Project\\EJET PM-CPDLC Support\\MKII_757_flight_test\\2015_06_08_Flight_1\\Parsed_429\\VDLM2_ATN-618_wTabs.xlsx"; 
    my $excel = Spreadsheet::XLSX -> new ($xlsFileName);
    my $targetSheet = "VDLM2_ATN-618_wTabs";
    
    foreach my $Sheet (@{$excel -> {Worksheet}}) {
     
            #printf("Sheet: %s\n", $Sheet->{Name});
            
            if (lc $targetSheet eq lc $Sheet->{Name} ) #case insensitive compare.
            {
                $Sheet -> {MaxRow} ||= $Sheet -> {MinRow};
                
                foreach my $row ($Sheet -> {MinRow} .. $Sheet -> {MaxRow}) {
                    my $cellType = $Sheet -> {Cells} [$row] [5];
                    my $cellBuf = $Sheet -> {Cells} [$row] [57];
                    printf "\n$row:$cellType -> {Val}:$cellBuf -> {Val}\n";
                }
            }
            else
            {
                printf "Skip Sheet$Sheet->{Name}";
                next;
            }
            
            
            
             #foreach my $row ($Sheet -> {MinRow} .. $Sheet -> {MaxRow}) {
             
              #      $Sheet -> {MaxCol} ||= $Sheet -> {MinCol};
                    
              #      foreach my $col ($Sheet -> {MinCol} ..  $Sheet -> {MaxCol}) {
                    
               #             my $cell = $Sheet -> {Cells} [$row] [$col];
     
                #            if ($cell) {
               #                 printf("( %s , %s ) => %s\n", $row, $col, $cell -> {Val});
               #             }
     
               #     }
     
            #}
     
     }

}

sub test5{
    #use strict;
    use Win32::OLE qw(in with);
    use Win32::OLE::Const 'Microsoft Excel';

    my $xlsFileName = "Z:\\Project\\EJET PM-CPDLC Support\\MKII_757_flight_test\\2015_06_08_Flight_1\\Parsed_429\\VDLM2_ATN-618_wTabs.xlsx"; 
    
    # get already active Excel application or open new
    my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
        || Win32::OLE->new('Excel.Application', 'Quit');

    # open Excel file
    my $Book = $Excel->Workbooks->Open($xlsFileName);
    my $Sheet = $Book->Worksheets(1);

    my $Tot_Rows= $Sheet->UsedRange->Rows->{'Count'}; 
    #my $Tot_Cols= $Sheet->UsedRange->Columns->{'Count'}; 
    #print"Number of Rows=> $Tot_Rows\n";
    #print"Number of Cols=> $Tot_Cols\n";

    foreach my $row (1..$Tot_Rows)
    {
         #foreach my $col (1..10)
         #{  
            # skip empty cells
            my $cellType = $Sheet->Cells($row,5);
            next unless defined $cellType ->{'Value'};

            my $cell429Buf = $Sheet->Cells($row,57);
            
            # print out the contents of a cell  
            printf "At ($row, 5) %s\n", $cellType ->{'Value'}; 
            printf "At ($row, 57) %s\n", $cell429Buf ->{'Value'}; 
                
            #my $newval = $Sheet->Cells($row,$col)->{'Value'}; 
            #printf "Row two val = $Sheet->{'value'}";
         #}
    }
}

sub main {

   print STDOUT "Enter a number: ";     
   $number = <STDIN>;           
   print STDOUT "The number is $number.\n";   
   
   if( $number == 1 ){
    &test();
   }
   elsif( $number == 2){
    &test2();
   }
   elsif( $number == 3){
    &test3();
   }
   elsif( $number == 4){
    &test4();
   }
   elsif( $number == 5){
    &test5();
   }
}



&main();

1