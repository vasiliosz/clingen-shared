#!/bin/bash -l

#SBATCH -J RNA4_HUB_json
#SBATCH -A b2014235
#SBATCH -t 00:15:00 --qos=short
#SBATCH -p core
#SBATCH -n 1


# get the git branch/version
echo "$(basename $0) @ $(date)"
echo "Branch/version (git): $(git rev-parse --abbrev-ref HEAD) $(git rev-parse --short HEAD)"
echo ""
echo "////////////////////////////////////////////////////////////////////////"

#provide a list bigwig files (UCSC compatibles)
BWLIST=$1  #list of bigwig files (one per line)
WEBEXP=$2 #path to webexport directory where to generate the json (same as location of the bigwig files)
WEBURL=$3 #url for the webexport
OUT_PFX=$4
#read the list
inputfiles=$(for i in `cat $BWLIST`; do printf -- " $i "; done)
cd $WEBEXP

echo "# a hg19 datahub with comprehensive examples
#
# for detailed description on hub format, visit http://wiki.wubrowse.org/Datahub
#
# About color:
# please use 'rgb(255,0,0)' or '#ff0000', instead of verbal names (e.g. 'red')
# transparency is not supported at the moment



# outmost enclosure
[
" >> $OUT_PFX.RNAseq_json

for i in $inputfiles


do
  file=$(basename $i)
  sample=$(basename $i .UCSC.Unique.unstranded.bw)
  echo "# a quantitative track (bedGraph)" >> $OUT_PFX.RNAseq_json
  echo "{" >> $OUT_PFX.RNAseq_json
  echo   "type:\"bigWig\"," >> $OUT_PFX.RNAseq_json
  echo   "url:\"$WEBURL/$file\",">> $OUT_PFX.RNAseq_json
  echo   "name:\"$sample\",">> $OUT_PFX.RNAseq_json
  echo  "mode:\"show\",">> $OUT_PFX.RNAseq_json
  cell=${sample#*_}
  #my sample ID are build as DONORID_CELLID. The CELL_ID is a number from 1 to 6 (see terms below)
  echo  "metadata:[$cell],">> $OUT_PFX.RNAseq_json
  echo  "### the two colors are for below/beyond maximum threshold values">> $OUT_PFX.RNAseq_json
  echo  "colorpositive:\"#ff33cc/#B30086\",">> $OUT_PFX.RNAseq_json
  echo  "backgroundcolor:\"#ffe5ff\",">> $OUT_PFX.RNAseq_json
  echo  "height:40,">> $OUT_PFX.RNAseq_json
  echo " geo:'GSM469970',">> $OUT_PFX.RNAseq_json
  echo "}," >> $OUT_PFX.RNAseq_json

done

echo "{" >> $OUT_PFX.RNAseq_json
echo  "type:\"metadata\",vocabulary:{" >> $OUT_PFX.RNAseq_json
echo    "cell types:{" >> $OUT_PFX.RNAseq_json
echo      "\"NK cells\":[1,2,3,4]," >> $OUT_PFX.RNAseq_json
echo      "\"CD8 T cells\":[5,6]," >> $OUT_PFX.RNAseq_json
echo     "}," >> $OUT_PFX.RNAseq_json
echo  "}," >> $OUT_PFX.RNAseq_json
echo  "terms:{" >> $OUT_PFX.RNAseq_json
echo    "1:[\"CD56dimCD57+NKG2C+\"]," >> $OUT_PFX.RNAseq_json
echo    "2:[\"CD56dimCD57+NKG2C-\"]," >> $OUT_PFX.RNAseq_json
echo    "3:[\"CD56dimCD57-NKG2C+\"]," >> $OUT_PFX.RNAseq_json
echo    "4:[\"CD56dimCD57-NKG2C-\"]," >> $OUT_PFX.RNAseq_json
echo    "5:[\"CD3+CD56-CD4-CD8+CD45RA+CD57- naive\"]," >> $OUT_PFX.RNAseq_json
echo    "6:[\"CD3+CD56-CD4-CD8+CD45RA+CD57bright\"]," >> $OUT_PFX.RNAseq_json
echo  "}," >> $OUT_PFX.RNAseq_json
echo "}," >> $OUT_PFX.RNAseq_json

echo " # end of outmost enclosure">> $OUT_PFX.RNAseq_json
echo "]" >> $OUT_PFX.RNAseq_json



### Just a note ###
#
# whenever you are using a new version of track file with its old URL,
# e.g. the track has been displayed on browser before but you updated the track file,
# you must do "Refresh cache" before the updated track can be shown again"
