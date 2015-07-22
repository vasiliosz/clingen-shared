# Plot and calculate genotype vs expression in 1000G individuals
Bianca Tesi and Vasilios Zachariadis  
22 Jul 2015  


```r
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(ggthemes))
suppressPackageStartupMessages(library(R.utils))
```

Set parameters: 

* GeneID from Ensembl
* Your SNP position (chr and position)


```r
ensid <- "ENSG00000185811.12"
chr <- 7
position <- 50470604
```

Set public data URLs and read metadata


```r
# File URLs
metadata <- "http://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/E-GEUV-1.sdrf.txt"
counts.url <- "http://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz"
met <- read.table(metadata, header=T, sep="\t")
```

Use tabix to get genotypes from 1000G (you need`tabix` in your PATH to be able to run this)


```r
gtsfile <- tempfile()
cmd <- paste("tabix -h ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp//release/20130502/ALL.chr",chr,".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz ",chr,":",position-1,"-",position," | grep -v ^## > ",gtsfile,sep="")
try(system(cmd))
```

Load the table and convert genotypes to text


```r
dat <- read.table(gtsfile, sep="\t", 
									comment.char = "", header=T, check.names = F, colClasses = "character")
dat <- dat[,-c(1:9)]
dat <- data.frame("Genotype"=t(dat))
dat$Genotype <- ifelse(dat$Genotype=="0|0", "HOM_REF", 
								 ifelse(dat$Genotype=="0|1" | dat$Genotype=="1|0", "HET", "HOM_ALT"))
```

Download and read Geuvadis gene quantification table (or load from Rds file if run before)


```r
if(!file.exists("GD462.GeneQuantRPKM.Rds")) {
	counts.file <- tempfile(fileext = ".txt.gz")
	download.file(url=counts.url, destfile=counts.file)
	gunzip(counts.file)
	counts <- fread(sub(".gz", "", counts.file),
									header=TRUE, check.names=F, data.table=F)
	saveRDS(counts, "GD462.GeneQuantRPKM.Rds")	
} else {
	counts <- readRDS("GD462.GeneQuantRPKM.Rds")
}
```

Subset for gene of interest 


```r
genecount <- counts[grepl(ensid, counts$Gene_Symbol),]
genecount <- t(genecount[,-c(1:4)])
colnames(genecount) <- ensid
```

Merge genotype and expression tables


```r
dat <- merge(dat, genecount, by = "row.names", all.x = T)
dat <- dat[!is.na(dat[,3]),]
dat$Genotype <- factor(dat$Genotype, levels=c("HOM_REF", "HET", "HOM_ALT"))
colnames(dat)[1] <- "Sample"
```

Add population info


```r
dat$Population <- met[match(dat$Sample, met$Source.Name), "Characteristics.population."]
```

Finally, plot the genotype vs expression


```r
p <- ggplot(dat, aes_string("Genotype", ensid)) +
	geom_boxplot() +
	geom_jitter(position = position_jitter(width=.2)) +
	ggtitle(paste(chr,":",position," vs expression of ",ensid,sep="")) +
	ylab("Expression (RPKM)") +
	theme_few()
p
```

![](1kg-geuvadis-custom-eqtl_files/figure-html/unnamed-chunk-9-1.png) 

You can also plot by population

```r
p + facet_wrap(~Population)
```

![](1kg-geuvadis-custom-eqtl_files/figure-html/unnamed-chunk-10-1.png) 
