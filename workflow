workflow used

## 1. Simulate Reads Using ART
```bash
art_illumina -ss HS25 -i reference.fasta -l 150 -f 20 -p -m 350 -s 50 -o output_prefix
### 2 Read Quality Check with FastQC + MultiQC
fastqc *.fq
multiqc .
### 3 Genome Assembly with SPAdes
spades.py -1 reads_1.fq -2 reads_2.fq -o spades_output/
### 4 Evaluate Assembly Quality with QUAST
quast.py -o quast_output spades_output/contigs.fasta
### 5 Estimate Contamination with CheckM
checkm lineage_wf -x fa spades_output/ checkm_output/
### 6 Visualise Assembly Graph with Bandage
Bandage GUI
# Or generate an image:
Bandage image spades_output/assembly_graph.gfa graph.png
### 7  Species Identity Check with FastANI
fastANI -q assembly.fasta -r reference.fasta -o ani_output.txt
### 8 Read Alignment with Bowtie2 + SAMtools
bowtie2 -x reference_index -1 reads_1.fq -2 reads_2.fq -S output.sam
samtools view -bS output.sam > output.bam
samtools sort output.bam -o output_sorted.bam
samtools index output_sorted.bam
### 9 Coverage and Insert Size with Qualimap
qualimap bamqc -bam output_sorted.bam -outdir qualimap_output
### Species Classification with Pathogenwatch (Web)
Used https://pathogen.watch
