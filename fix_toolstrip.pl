use strict;
use warnings;
use Data::Dumper;

my $ifh;
my $ofh;
my %hash ;  #store stuff here to extract on the second pass

open($ifh, $ARGV[0])
or die "Could not open file '$ARGV[0]' $!";
open($ofh, ">", $ARGV[1])
or die "Could not open file '$ARGV[1]' $!";

my @lines = <$ifh>;
close($ifh);
my $i = 0;
my @toolstripkeys;
my @toolstripvalues;
for $i (0 .. $#lines)
{
    my $string = $lines[$i];
    if($string =~ m/\s*this.*ToolStripMenuItem.*\-\>.*Name/)
    {
        $lines[$i] = '//' . $string;  #comment out the lines
                
    }
    elsif($string =~ m/\s*this.*ToolStripMenuItem.*\-\>.*Size/)
    {
        $lines[$i] = '//' . $string;  #comment out the lines
    }
    elsif($string =~ m/\s*this.*ToolStripMenuItem.*\-\>.*Text/)
    {
        $lines[$i] = '//' . $string;  #comment out the lines
        #split on > and get the 2nd one 
        my @substr = split('->', $string);
        my $tlstrpname = $substr[1];
        $tlstrpname =~ s/^\s+|\s+$//g ;
        @substr = split('"', $string);
        my $text = $substr[1];
        push(@toolstripkeys,$tlstrpname.'txt');
        push(@toolstripvalues,'L"'.$text.'"');
    }
    elsif($string =~ m/\s*this.*ToolStripMenuItem.*\-\>.*Click/)
    {
        $lines[$i] = '//' . $string;  #comment out the lines
        #split on > and get the 2nd one 
        my @substr = split('->', $string);
        my $tlstrpname = $substr[1];
        $tlstrpname =~ s/^\s+|\s+$//g ;
        @substr = split('=', $string);
        my $func = $substr[1];
        $func =~ s/;\s*$//g ;
        push(@toolstripkeys,$tlstrpname.'clk');
        push(@toolstripvalues,$func); 
    }
}
    
    #print Dumper(@toolstripkeys);
    #print Dumper(@toolstripvalues);
    while( my( $index, $value ) = each @toolstripkeys) {
      $hash{ $value } = $toolstripvalues[$index];
      }
    #@hash(@toolstripkeys) = @toolstripvalues;
    #print Dumper(\%hash);
    
for $i (0 .. $#lines)
{
    my $string = $lines[$i];
    if($string =~ m/\s*this.*ToolStripMenuItem\s*=\s*gcnew/)
    {   
        #print $string;
        my @temp = split('->',$string);
        my $initpart = $temp[0];
        my $nm = $temp[1];
        @temp = split('=', $nm);
        $nm = $temp[0];
        $nm =~ s/^\s+|\s+$//g  ;
        #print $nm.'blah';
        $lines[$i] = $initpart. '->' .$nm. '= gcnew ToolStripMenuItem(' .$hash{$nm.'txt'}. ', nullptr, ' . $hash{$nm.'clk'} . ');' ;
        chomp($lines[$i]);
        #this->align_Left_ToolStripMenuItem     = gcnew ToolStripMenuItem(L"Align Left", nullptr, gcnew EventHandler(this, &MainForm::align_Left_ToolStripMenuItem_Click)); 
        #print $lines[$i];
        #$lines[$i] = '//' . $string;  #comment out the lines
        # get the name out, look up keys and write the proper thing here
    }
    print $ofh $lines[$i]."\n";
}


                
  
    
#we'll do things inefficiently here, because what the heck!

#get this_>*ToolStripMenuItem = gcnew , then use the name to find a match for name, size, text and click, accumulate the stuff, clear those lines and fix the current line



# replace the corresponding lines with the correct constructor and destroy the useless lines, copy everything else as is

#this->align_Center_ToolStripMenuItem->Name = L"align_Center_ToolStripMenuItem";
#    //this->align_Center_ToolStripMenuItem->Size = System::Drawing::Size(241, 22);
#    this->align_Center_ToolStripMenuItem->Text = L"Align Center";
#    this->align_Center_ToolStripMenuItem->Click += gcnew System::EventHandler(this, &MainForm::align_Center_ToolStripMenuItem_Click);