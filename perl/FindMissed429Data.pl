#use strict;
use warnings;
    
    my $logName = "Z:\\Project\\EJET PM-CPDLC Support\\MKII_757_flight_test\\2015_06_08_Flight_1\\CMU_Logs\\CMU_2015_06_08\\CMU_2015_06_08.log";
    my $xls429 = "Z:\\Project\\EJET PM-CPDLC Support\\MKII_757_flight_test\\2015_06_08_Flight_1\\Parsed_429\\VDLM2_ATN-618_wTabs.xlsx"; 
    
    print "\nStart Check: \n$logName\n$xls429\n";
    
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
                        #printf "Find Row $row\n";
                        last;                        
                    }
                }
                
                if( $findbuf == 0 ){
                    printf "Not Find Row: $row - %s\n", $tmp429Msg;
                }

        }
        
        printf "Finished!\n";
        $Excel->Workbooks->Close();