#!/bin/bash -l

awk -F '\t' 'NR>1 && length($2)<6 && length($5)<6{
 OFS="\t";
 gsub(/chr/,"hs",$2);
 gsub(/chr/,"hs",$5);
 if($14~/gene/ && $15~/gene/){
  genes=1
  } else if($14~/gene/ || $15~/gene/){
   genes="0,5"
  } else {
   genes=0
  };
  print $2,$3,$4,$5,$6,$7, "occurence="$1, "hitratio="($10/$9), "genes="genes
}' "$1"
