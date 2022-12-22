#!/bin/bash
#

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

mkdir -p ~/out/report_html/QC/ ~/out/stats_txt/QC/
mark-section "download inputs"
dx-download-all-inputs --parallel
		
# The fastqc docker image from 001
Docker_file_ID=project-ByfFPz00jy1fk6PjpZ95F27J:file-GKQkG5006xgkK6vgP4X1vY2P
dx download ${Docker_file_ID}
Docker_image_file=$(dx describe ${Docker_file_ID} --name)
Docker_image_name=$(echo $Docker_image_file | sed s'/.tar//' | sed s'/.gz//')
docker load < /home/dnanexus/"${Docker_image_file}"
echo "Using fastqc docker image ${Docker_image_name}"

#
# Set up some options
#
mark-section "building FastQC arguments"
opts="$extra_options --extract -k $kmer_size "
if [ "$contaminants_txt" != "" ]; then
  opts="$opts -c $contaminants_txt_path"
fi
if [ "$adapters_txt" != "" ]; then
  opts="$opts -a $adapters_txt_path"
fi
if [ "$limits_txt" != "" ]; then
  opts="$opts -l $limits_txt_path"
fi
if [ "$format" != "auto" ]; then
  opts="$opts -f $format"
fi
if [ "$nogroup" == "true" ]; then
  opts="$opts --nogroup"
fi

mark-section "Running FastQC"
for (( i=0; i<${#reads[@]}; i++ ))
do 
  echo ${reads_prefix[i]}
  docker run -v /home/dnanexus:/home/dnanexus --rm ${Docker_image_name} $opts -o /home/dnanexus ${reads_path[i]}
  # move outputs used for multiqc (fastqc_data.txt), and the html file to output specific folders, where needed, renaming with sample specific names
  mv ~/"${reads_prefix[i]}"_fastqc/fastqc_data.txt ~/out/stats_txt/QC/"${reads_prefix[i]}".stats-fastqc.txt
  mv ~/*fastqc.html ~/out/report_html/QC/
done


mark-section "uploading results"
dx-upload-all-outputs
mark-success
