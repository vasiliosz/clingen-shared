#TODO:
# inputfolder (with csv files) as variable
# 1. Option to run circos with the data directly
# 2. Parse gene information to feed Circos: only extract those above a certain quality threshhold
# 3. Supply list of known disease-causing fusions and ”upvote" them for quality - and always highlight annotation

INPUT=$1
CIRCOSFOLDER=$2
PLOT=$3

# Set some defaults
if [[ -z $INPUT ]]; then INPUT="csvlists"; fi
if [[ -z $CIRCOSFOLDER ]]; then CIRCOSFOLDER="circos-matepair"; fi
if [[ -z $PLOT ]]; then PLOT="TRUE"; fi

mkdir -vp $CIRCOSFOLDER/data/fusion
mkdir -vp $CIRCOSFOLDER/data/annotation

# Clean before creating new data files
rm -f $CIRCOSFOLDER/data/fusion/*.fusion.circos
rm -f $CIRCOSFOLDER/data/annotation/*.genes.txt

# Loop through input lists
for f in $INPUT/*
do
 id=$(basename ${f%_int*_chr_events_annotated_vsDB.csv})
 # 1. Create fusion links
 ./transloc-to-fusion-links.sh "$f" >> $CIRCOSFOLDER/data/fusion/"$id".fusion.circos
 # 2. Create gene annotation lists
 ./transloc-to-gene-highlights.sh "$f" >> $CIRCOSFOLDER/data/annotation/"$id".genes.txt
 awk '!a[$4]++' $CIRCOSFOLDER/data/annotation/"$id".genes.txt > $CIRCOSFOLDER/data/annotation/"$id".genes.txt.tmp
 mv -f $CIRCOSFOLDER/data/annotation/"$id".genes.txt.tmp $CIRCOSFOLDER/data/annotation/"$id".genes.txt
done

# 3. Plot all samples
if [[ $PLOT -eq "TRUE" ]]
then
 for f in $INPUT/*inter*
  do
   if [[ -z $fold ]]; then fold=CASEID; fi
   # Parse sample ID from pattern: inputfolder/P901_137_*
   fnew=$(echo "${f#$INPUT/}" | cut -f1-2 -d_)
   sed -i "" s/$fold/"$fnew"/g $CIRCOSFOLDER/etc/circos-annotated-fusion_only.conf
   echo "Running Circos for case $fnew"
   circos -config $CIRCOSFOLDER/etc/circos-annotated-fusion_only.conf
   fold=$fnew
 done
 # Finish by resetting to CASEID in circos config file
 sed -i "" s/${fold}/CASEID/g $CIRCOSFOLDER/etc/circos-annotated-fusion_only.conf
 fold=
fi

# Match fusions (gene1-gene2) against database of known fusion genes
# Match indiviudal genes against COSMIC Cancer Gene Census