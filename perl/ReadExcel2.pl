my $xlsFileName = "Z:\\Project\\EJET PM-CPDLC Support\\MKII_757_flight_test\\2015_06_08_Flight_1\\Parsed_429\\VDLM2_ATN-618_wTabs.xlsx";

 # Text::Iconv is not really required.
 # This can be any object with the convert method. Or nothing.

 use Spreadsheet::XLSX;
 
 my $excel = Spreadsheet::XLSX -> new ($xlsFileName);
 
 foreach my $sheet (@{$excel -> {Worksheet}}) {
 
        printf("Sheet: %s\n", $sheet->{Name});
        
        $sheet -> {MaxRow} ||= $sheet -> {MinRow};
        
         foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
         
                $sheet -> {MaxCol} ||= $sheet -> {MinCol};
                
                foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
                
                        my $cell = $sheet -> {Cells} [$row] [$col];
 
                        if ($cell) {
                            printf("( %s , %s ) => %s\n", $row, $col, $cell -> {Val});
                        }
 
                }
 
        }
 
 }