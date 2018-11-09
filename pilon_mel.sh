#!/bin/bash

# 
# Author: Ching-Ho Chang
# for Chang and Larracuente 2018. Heterochromatin-enriched assemblies reveal the sequence and organization of the Drosophila melanogaster Y chromosome
# -code used to run Pilon iteratively to polish the assembly
#

#genome in $1, forward reads in $2, reverse reads in $3, cpus in $4, final output in $5
mkdir -p pilon
cd pilon
cp $1 pilon0.fasta
#number of loops is hardcoded to 10 runs of pilon
for i in {1..10}; do
	if [[ $i == '1' ]]; then
		GENOME=pilon0.fasta
	else
		x=$(($i - 1))
		GENOME=pilon$x.fasta
	fi
	if [[ ! -f pilon$1.fasta ]]; then
		echo "Working on $GENOME"
		#mapping multiple Illumina files to the genome and merging bam files 
		bwa index $GENOME $GENOME
		bwa mem -t 24  $GENOME ERR701706_1_val_1.fq.gz ERR701706_2_val_2.fq.gz  |samtools view -@ 24 -bS - |samtools sort -@ 24 -o  ERR701706.bam -
		bwa mem -t $4  $GENOME ERR701707_1_val_1.fq.gz ERR701707_2_val_2.fq.gz  |samtools view -@ 24 -bS - |samtools sort -@ 24 -o  ERR701707.bam -
		bwa mem -t $4  $GENOME ERR701708_1_val_1.fq.gz ERR701708_2_val_2.fq.gz  |samtools view -@ 24 -bS - |samtools sort -@ 24 -o  ERR701708.bam -
		bwa mem -t $4  $GENOME ERR701709_1_val_1.fq.gz ERR701709_2_val_2.fq.gz  |samtools view -@ 24 -bS - |samtools sort -@ 24 -o  ERR701709.bam -
		bwa mem -t $4  $GENOME ERR701710_1_val_1.fq.gz ERR701710_2_val_2.fq.gz  |samtools view -@ 24 -bS - |samtools sort -@ 24 -o  ERR701710.bam -
		bwa mem -t $4  $GENOME ERR701711_1_val_1.fq.gz ERR701711_2_val_2.fq.gz  |samtools view -@ 24 -bS - |samtools sort -@ 24 -o  ERR701711.bam -
		samtools index ERR701706.bam
		samtools index ERR701707.bam
		samtools index ERR701708.bam
		samtools index ERR701709.bam
		samtools index ERR701710.bam
		samtools index ERR701711.bam
		samtools merge -@ 24 melm_bergman.bam ERR701706.bam ERR701707.bam ERR701708.bam ERR701709.bam ERR701710.bam ERR701711.bam
		samtools index melm_bergman.bam
		samtools flagstat melm_bergman.bam >melm_bergman.out
		rm ERR*
		bwa mem -t $4 $GENOME SRR1141106.fastq.gz |samtools view -@ $4 -bS - |samtools sort -@ $4 -o  SRR1141106.bam -
		samtools index SRR1141106.bam
		samtools flagstat SRR1141106.bam >SRR1141106.out
		bwa mem -t $4 $GENOME SRR1516222_1_val_1.fq.gz SRR1516222_2_val_2.fq.gz |samtools view -@ $4 -bS - |samtools sort -@ $4 -o  SRR1516222.bam -
		bwa mem -t $4 $GENOME SRR1515985_1_val_1.fq.gz SRR1515985_2_val_2.fq.gz |samtools view -@ $4 -bS - |samtools sort -@ $4 -o  SRR1515985.bam -
		samtools index SRR1515985.bam
		samtools flagstat SRR1515985.bam >SRR1515985.out
		samtools index SRR1516222.bam
		samtools flagstat SRR1516222.bam >SRR1516222.out
		#now run pilon
		java -Xmx120g -jar pilon-1.22.jar --genome $GENOME --frags melm_bergman.bam  --unpaired SRR1141106.bam  --frags SRR1516222.bam --frags SRR1515985.bam --changes  --threads 24 --mindepth 3 --minmq 10 --fix bases --output pilon$i
		rm *.bam *.bai *.sa *amb *ann *pac *bwt

	else
		echo "$GENOME has already been run, moving onto next iteration"
	fi
done

cp pilon10.fasta ../$5
cp pilon10.changes ../$5.changes.txt

