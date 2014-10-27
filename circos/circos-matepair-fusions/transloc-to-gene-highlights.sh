#!/bin/bash -l

UCSCLOOKUP="UCSCtoHGNCsymbols-hg19.txt"
FILTER="abParts"
# For now, only highlight gene names that are involved in gene to gene links
# Example from manifest - matching probe ids on SNP array:
# awk -F$'\t' 'FNR==NR{a[$1]=$2;b[$1]=$3;next}a[$2]!="M" && a[$2]!=0 && a[$2]!="XY"{OFS="\t"; print "chr"a[$2],b[$2],b[$2],$20}' $MANIFEST_EXOME $INFOLDER/$file
# a[$1]=$2 // In array A; with probe ID as key - save chr number
# b[$1]=$3 // In array B; again with probe ID as key - save position

awk -F '\t' 'NR>1 && FNR==NR{
 gsub(/chr/, "hs", $3);
 a[$1]=$2;
 b[$1]=$3;
 c[$1]=$4;
 d[$1]=$5;
 next;
};
NR>1 && length($2)<6 && length($5)<6{
 OFS="\t";
 if($14~/gene/ && $15~/gene/){
   gsub(/gene_/, "", $14);
   gsub(/gene_/, "", $15);
   print b[$14], c[$14], d[$14], a[$14];
   print b[$15], c[$15], d[$15], a[$15];
  };
}' $UCSCLOOKUP "$1" | awk '!a[$0]++' | grep -v $FILTER
