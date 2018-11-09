#open (input_file,"/Users/chinghochang/Dropbox/mel_assembly/Supplement/repeat/Type");
open (input_file,"./dmel.dict");
open (OUT,">copynumber_content.out");
#open (OUT,">dsim_euch_repeat_content.out");
while($line=<input_file>)
{
@snp=split(/\s+/,$line);
#$snp[0]=~/\#+(\S+)/;
$snp[0]=~/(\S+)/;
$name=lc($1);
$a{($name)}=1;
#print "$name\n";
}
print OUT"Contig\t";
foreach $key (keys %a)
{
print OUT"$key #\t$key base\t$key %\t";
} 
print OUT"\n";
open (input_file2,"copynumber.csv");
while($line2=<input_file2>)
{
#000026F_com	Family	Element	Length	Fragments	Copies	Solo_LTR	Total_Bp	Cover
@snp2=split(/\s+/,$line2);
if ($line2 =~ /Family/)
{
$contig=$snp2[0];
while($line2=<input_file2> )
{
@snp2=split(/\s+/,$line2);
if ($line2 =~ /Family/ || eof)
{
print OUT"$contig\t";
foreach $key (keys %a)
{
#print "$key\n";
 if ($copy{($key)})
 {
#print "$b{($key)}\t";
print OUT "$copy{($key)}\t$base{($key)}\t$percent{($key)}\t";
$copy{($key)}=0;
$base{($key)}=0;
$percent{($key)}=0;
}
else
{
print OUT "0\t0\t0\t";
}
}
print OUT"\n";
$contig=$snp2[0];
}
#=cut
if ($line2 =~ /\#/ && $snp2[6])
{
$line2 =~ s/^\#+//;
$snp2[0]=~ s/^\#+//;
$snp2[0]= lc($snp2[0]);

$copy{($snp2[0])}=$snp2[4]+$copy{($snp2[0])};
$base{($snp2[0])}=$snp2[6]+$base{($snp2[0])};
$percent{($snp2[0])}=$snp2[7]+$percent{($snp2[0])};

print "$snp2[0] $b{($snp2[0])}" if $b{($snp2[0])};
}
#=cut
if ($snp2[6])
{
$line2 =~ s/^\#+//;
$snp2[1]=~ s/^\#+//;
$snp2[1]= lc($snp2[1]);
#allow some comment
#if ($snp2[1]=~ /(\S+?)[\_\-]/)
if ($snp2[0] =~/^LTR/ && ($snp2[1]=~ /(\S+)-i$/|| $snp2[1]=~ /(\S+)-ltr$/|| $snp2[1]=~ /(\S+)_i-int$/ || $snp2[1]=~ /(\S+)_ltr$/))
{
$snp2[1]=$1;
# print "$1\n";
 
}elsif($snp2[0] =~/^LTR/ && ($snp2[1]=~ /\S+-i_d/ ||$snp2[1]=~ /\S+-ltr_d/))
{

$snp2[1] =~ s/\-i//;
$snp2[1] =~ s/\-ltr//;
#print "$snp2[1]\n";
}

$copy{($snp2[1])}=$snp2[4]+$copy{($snp2[1])};
$base{($snp2[1])}=$snp2[6]+$base{($snp2[1])};
$percent{($snp2[1])}=$snp2[7]+$percent{($snp2[1])};
#print "$1\n";

#print "$snp2[0] $line2";
}

}

}


}