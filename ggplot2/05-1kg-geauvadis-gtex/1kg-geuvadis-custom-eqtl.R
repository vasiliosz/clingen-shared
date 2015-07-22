library(data.table)
library(ggplot2)
library(ggthemes)
library(R.utils)

# Set parameters
ensid <- "ENSG00000185811.12"
chr <- 7
position <- 50470604

# File URLs
metadata <- "http://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/E-GEUV-1.sdrf.txt"
counts.url <- "http://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz"

# Use tabix to get genotypes from 1000G
gtsfile <- tempfile()
cmd <- paste("tabix -h ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp//release/20130502/ALL.chr",chr,".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz ",chr,":",position-1,"-",position," | grep -v ^## > ",gtsfile,sep="")
try(system(cmd))

dat <- read.table(gtsfile, sep="\t", 
									comment.char = "", header=T, check.names = F, colClasses = "character")
dat <- dat[,-c(1:9)]
dat <- data.frame("Genotype"=t(dat))
dat$Genotype <- ifelse(dat$Genotype=="0|0", "HOM_REF", 
								 ifelse(dat$Genotype=="0|1" | dat$Genotype=="1|0", "HET", "HOM_ALT"))

met <- read.table(metadata, header=T, sep="\t")

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

genecount <- counts[counts$Gene_Symbol==ensid,]
genecount <- t(genecount[,-c(1:4)])
colnames(genecount) <- ensid

dat <- merge(dat, genecount, by = "row.names", all.x = T)
dat <- dat[!is.na(dat[,3]),]
dat$Genotype <- factor(dat$Genotype, levels=c("HOM_REF", "HET", "HOM_ALT"))
colnames(dat)[1] <- "Sample"

# Add population info
dat$Population <- met[match(dat$Sample, met$Source.Name), "Characteristics.population."]

p <- ggplot(dat, aes_string("Genotype", ensid)) +
	geom_boxplot() +
	geom_jitter(position = position_jitter(width=.2)) +
	theme_few() +
	facet_wrap(~Population)
p