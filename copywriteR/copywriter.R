library(CopywriteR)

preCopywriteR(output.folder = file.path("/home/bianca/glob/copywriter_files"),
                bin.size = 20000,
                ref.genome = "hg19",
                prefix = "")

preCopywriteR(output.folder = file.path("/home/bianca/glob/copywriter_files"),
                bin.size = 10000,
                ref.genome = "hg19",
                prefix = "")

bp.param <- SnowParam(workers = 8, type = "SOCK")

path <- "/proj/b2012204/nobackup/private/no_backup_area/BGI_Feb_2015/result/final_bam_march_2015"
samples <- list.files(path = path, pattern = "A797sis.recal.bam$", full.names = TRUE)
controls <- samples
sample.control <- data.frame(samples, controls)

CopywriteR(sample.control, destination.folder= file.path("/proj/b2012204/nobackup/private/no_backup_area/CLINICAL_GENOMICS/clinical_genomics_WES_June15/copywriteR"),
            reference.folder= file.path("/home/bianca/glob/copywriter_files", "hg19_10kb"),
             bp.param)

plotCNA(destination.folder = file.path("/proj/b2012204/nobackup/private/no_backup_area/CLINICAL_GENOMICS/clinical_genomics_WES_June15/copywriteR"))
