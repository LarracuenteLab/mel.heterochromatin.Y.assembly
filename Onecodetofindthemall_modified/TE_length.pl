open (OUT,">/Users/chinghochang/Desktop/dd.txt");
open (input_file2,"/Users/chinghochang/Desktop/tmp/tmp/dmel_scaffold2.fasta.out.length");
while($line2=<input_file2>)
{
@te=split(/\s+/,$line2);
$length{$te[0]}=$te[1];
}
@files = <*Y*.fasta>;
foreach $file (@files) {
#print "$file\n";
open (input_file2,"$file");
while($line2=<input_file2>)
{

if ($line2 =~/\>/)
{
# DNA/CMC-Transib
next if $line2 !~/LINE\/(\S+)\|(\S+)/;
#print "$line2";
print OUT "$1\t";
$te=$2;
$total=$length{$te};
if ($te =~/\:/)
{
$total=0;
@te=split(/\:/,$te);
foreach $te_f (@te)
{
$total=$length{$te_f}+$total;
}

}
print "$te $total\n" if $total ==0;
$line2=<input_file2>;
$long=length($line2);
$total=$long/$total;
print OUT "$long $total\n";
}
}
}