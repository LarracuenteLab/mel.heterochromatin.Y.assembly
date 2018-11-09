#!/usr/bin/perl
use warnings;
use strict;
#
# 
# Author: Ching-Ho Chang
# for Chang and Larracuente 2018. Heterochromatin-enriched assemblies reveal the sequence and organization of the Drosophila melanogaster Y chromosome
# -parses blast output file
#
open (input_file,"dmel_scaffold2_V5_0117_2018.fasta"); #Input file (reference): no newlines--sequences should be on one line
my @file2 =<input_file> ;
my $length2 = $#file2;
my $start;
my $end;
my $s;
my $len;
my $seq;
my @sorted_numbers;
my $name='';
close input_file;
open (input_file,"blast.out"); #Blast_output file where -outfmt 6
open (OUT,">output.fa"); #output fasta file
my $n=0;
while(my $line=<input_file>) {
	my @linearray=split(/\s+/,$line);
	$n++ if($linearray[1] =~ /$name/);
	$n=1 if($linearray[1] !~ /$name/);
	$linearray[1]=~/^(\S+)/;
	$name=$1;
	print "$name\n";
	for my $j(0...$length2) {
		next if ($file2[$j]!~/\>(\S+)/);
		$file2[$j]=~/\>(\S+)/;
		
		if($1 eq $name ) {
			$start=$linearray[8];
			$end=$linearray[9];
			$s=1 if ($start>$end);
			$s=0 if ($start<$end);
			@sorted_numbers = sort { $a <=> $b }($start,$end);
			$len=length($file2[$j+1]);
			
			print "$name $len $start $end\n";
			
			$seq = substr ($file2[$j+1],$sorted_numbers[0]-1,$sorted_numbers[1]-$sorted_numbers[0]+1);
			$seq =  reverse($seq) if $s==1;
			$seq =~ tr/atcgATCGRYKMSWrykmsw/tagcTAGCYRMKWSyrmkws/  if $s==1;
			print OUT">$linearray[0].$linearray[1].$n\n";
			print OUT"$seq\n";
			last;
		}
	}
}