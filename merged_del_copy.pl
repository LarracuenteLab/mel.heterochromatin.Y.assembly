#!/usr/bin/perl
use warnings;
use strict;
#
# 
# Author: Ching-Ho Chang
# for Chang and Larracuente 2018. Heterochromatin-enriched assemblies reveal the sequence and organization of the Drosophila melanogaster Y chromosome
#
# Code used to merge transcripts or degenerated copies (indels).
#	-sort blast output by position based on genome region  `sort -nk9,9 blast.out | sort -s -k 2,2 > blast2.out`;

open (OUT,">merged.out");
open (input_file2,"blast2.out");
# m equal to how many fragments of each copy in the genome
my $m=1;
my $n=1; # start first line of the each copy
my $start;
my $end;
my $qstart;
my $qend;
my $copy;
my $name=0;
my $length;
while(my $line2=<input_file2>){

	my @linearray=split(/\s+/,$line2);

	#do it for each gene
	if($linearray[1] eq $name && $linearray[0] eq $copy  && $n>1) {
		if($linearray[9]-$linearray[8]>0) {
			#print OUT"$copy\t$name\t$linearray[6] $end $linearray[8] $qend\tdebug\n";
			#conditioning on no big insertion (<10kb), or small deletion (<100bp) in genome and continuous transcript sequences (distance between frag1 and frag2 is less than 50 bases on transcripts)
			if ((abs($linearray[6]-$end)>50  || abs($linearray[8] -$qend) >10000)&& (abs($linearray[8] -$qend)>100 )) {
				$length= abs($qend -$qstart)  ;
				print OUT"$copy\t$name\t1\t2\t3\t4\t$start\t$end\t$qstart\t$qend\t$length\t$m\n"  ;
				$start=$linearray[6];
				$end=$linearray[7];
				$qstart=$linearray[8];
				$qend=$linearray[9];
				$copy=$linearray[0];
				$name=$linearray[1];
				$n++;
				$m=1;
				}
			else {
				$qend=$linearray[9];
				$end=$linearray[7];
				$m++;
				}
		}
		elsif($linearray[9]-$linearray[8]<0) {
			if ((abs($linearray[7]-$start)>50 || abs($linearray[9] -$qstart) >10000)&& abs($linearray[9] -$qstart)>100) {
					$length= abs($qend -$qstart) ; 
					print OUT"$copy\t$name\t1\t2\t3\t4\t$start\t$end\t$qstart\t$qend\t$length\t$m\n" ;
					$start=$linearray[6];
					$end=$linearray[7];
					$qstart=$linearray[8];
					$qend=$linearray[9];
					$n++;
					$m=1;
				}
			else {
				$qstart=$linearray[8];
				$start=$linearray[6];
				$m++;
				}
			}

		}
		elsif ($n>1) {
			$length= abs($qend -$qstart) ;
			print OUT"$copy\t$name\t1\t2\t3\t4\t$start\t$end\t$qstart\t$qend\t$length\t$m\n";
			$start=$linearray[6];
			$end=$linearray[7];
			$qstart=$linearray[8];
			$qend=$linearray[9];
			$m=1;
		}
		#=cut
		if (eof) {
			$length= abs($qend -$qstart) ;
			print OUT"$copy\t$name\t1\t2\t3\t4\t$start\t$end\t$qstart\t$qend\t$length\t$m\n";
		}
		#=cut
		if ($n==1) {
			$start=$linearray[6];
			$end=$linearray[7];
			$start=$linearray[6];
			$end=$linearray[7];
			$qstart=$linearray[8];
			$qend=$linearray[9];
			$copy=$linearray[0];
			$name=$linearray[1];
			$n++;
		}

	$name=$linearray[1];
	$copy=$linearray[0];
}