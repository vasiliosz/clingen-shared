Created 141026

# Auto-create Circos plots from translocation candidate lists in csvlists

*Usage*
```
./parse-folder.sh [csv-lists-folder] [circos-folder] [plot: default is TRUE]
```

`parse-folder.sh` calls two scripts underneath:
* `transloc-to-fusion-links.sh`
* `transloc-to-gene-highlights.sh`

*Dependencies*
1. Circos needs to be in path (see main level readme in this repository for instructions)
2. UCSCtoHGNCsymbols-hg19.txt (included)

***

The input csv-lists are in format: `[SAMPLE_ID]_[inter|intra]*.csv`
```
# Example CSV input list (SAMPLE_ID_inter_*.csv)
#Occ	chrA	startOnA	endOnA	chrB	startOnB	endOnB	LinksFromWindow	LinksToChrB	LinksToEvent	CoverageOnChrA	OrientationA	OrientationB	FeatureA	FeatureB
1	chr12	12026027	12030043	chr21	36263639	36267964	31	11	11	1.5295	- (100%)	- (100%)	gene_uc001qzz.3	gene_uc010gmu.3
2	chr12	43896870	43901676	chr21	36268332	36271647	19	9	9	2.03599	- (100%)	+ (100%)	gene_uc010skx.2	gene_uc010gmu.3
3	chr7	158387895	158390564	chr14	100394259	100394493	32	13	11	9.00487	- (54%)	+ (54%)	rmsk_LTR	gene_uc010tww.2
4	chr3	34249621	34250699	chr15	45080160	45091563	19	11	11	2.95551	+ (63%)	+ (63%)	rmsk_LTR	rmsk_LINE
```

Only one example csv is included in the repo, the rest are available via Uppmax.
