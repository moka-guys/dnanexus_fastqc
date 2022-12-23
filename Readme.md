# FastQC Reads Quality Control  v1.4.0
## What does this app do?
This app generates a QC report on reads data.

## What are typical use cases for this app?

This app is typically used after sequencing, to generate a QC report on the reads. As the FastQC manual says, "before analysing
reads to draw biological conclusions, you should always perform some simple quality control checks to ensure
that the raw data looks good and there are no problems or biases in your data which may affect how you can usefully use it."

## What data are required for this app to run?
This can take one or more sets of compatible reads data, in any of the following formats:
- Gzipped FASTQ files (`*.fq.gz` or `*.fastq.gz`)
- BAM files (`*.bam`)

It also can take a number of files and settings that are used by fastqc including:
- Custom contaminants - optional - A file containing custom contaminant sequences to screen overrepresented sequences against. If left empty, a default set of contaminants will be used. 
- Custom adapters - optional - Custom adapter sequences which will be explicity searched against the library. If left empty, a default set of adapters will be used. 
- Custom limits - optional - Criteria used to determine the warn/error limits for the various modules, or selectively remove some modules from the output altogether.
-Input format - default = auto - String describing the format of the input file. By default FastQC will try to automatically detect the format based on the input filename. You can override this by choosing a specific format (fastq, bam, or bam_mapped). 
- kmer_size - The kmer size that the kmer analysis module will use. This module reports overrepresented k-mers (sequences of size 'k'). This size must be between 2 and 10
- Disable grouping of bases past 50bp? - default = true -  Disable grouping of bases for reads >50bp. All reports will show data for every base in the read. - extra_options - Extra command-line options that will be passed directly to the fastqc invocation. Example: --nofilter


## What does this app output?
This app outputs an HTML report and a machine-readable text file for each sample.
Results are output to a subfolder `QC` 


## How does this app work?
This app runs a dockerised version of fastqc, release [v0.11.9](https://github.com/moka-guys/fastqc/releases/tag/v0.11.9)

