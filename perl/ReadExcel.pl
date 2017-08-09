#!/usr/bin/perl
use strict;
use warnings;

use Spreadsheet::Read;

my $workbook = ReadData ("Z:\\Project\\EJET PM-CPDLC Support\\MKII_757_flight_test\\2015_06_08_Flight_1\\Parsed_429\\VDLM2_ATN-618_wTabs.xlsx");
print $workbook->[1]{A3} . "\n";