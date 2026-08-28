
# ============================================================
# Project Transcriptomics - Rheumatoid Arthritis
# ============================================================
# Doel:
# Analyse van RNA-seq data van patiënten met Rheumatoid Arthritis
# (RA) en gezonde controles.
#
# Dataset:
# Platzer et al. (2019)
#
# Samples:
# - 4 gezonde controles
# - 4 RA-patiënten
#
# Referentiegenoom:
# GRCh38.p14
# NCBI accession: GCF_000001405.40
#
# Analyseworkflow:
# 1. Read mapping
# 2. BAM-bestanden verwerken
# 3. Read counting
# 4. Differential expression met DESeq2
# 5. PCA en heatmap
# 6. Volcano plot
# 7. GO enrichment
# 8. KEGG enrichment
# 9. Pathway visualisatie met Pathview
#
# ============================================================

#locatie vd bestanden ----
list.files( "c:/Users/cleop/Documents/school/Project Transcriptomics reuma/Data_RA_raw/Data_RA_raw/")
setwd("C:/Users/cleop/Documents/school/Project Transcriptomics reuma/Data_RA_raw/Data_RA_raw/")
getwd() # working direction

#inladen van alle benodigde packages----

library(BiocManager)
library(Rsubread)
library(Rsamtools)
library(DESeq2)
library(pheatmap)
library(EnhancedVolcano)
library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(pathview)
#optional (bekijken van de pathviews in R zelf)
library(png)

#////////////////////////////////////////////////////////////////////////////////////////////////////####

#indexeren ----
buildindex(
  basename = 'Casus_RA',
  reference = 'GCF_000001405.40_GRCh38.p14_genomic.fna',
  memory = 4000,
  indexSplit = TRUE)

#mapping van de reads ----
align.Fem_31_1_Norm_A <- align(index = "Casus_RA", readfile1 = "SRR4785819_1_subset40k.fastq", readfile2 = "SRR4785819_2_subset40k.fastq", output_file = "Fem_31_1_Norm.A.BAM")
align.Fem_15_1_Norm_A <- align(index = "Casus_RA", readfile1 = "SRR4785820_1_subset40k.fastq", readfile2 = "SRR4785820_2_subset40k.fastq", output_file = "Fem_15_1_Norm.A.BAM")
align.Fem_31_2_Norm_A <- align(index = "Casus_RA", readfile1 = "SRR4785828_1_subset40k.fastq", readfile2 = "SRR4785828_2_subset40k.fastq", output_file = "Fem_31_2_Norm.A.BAM")
align.Fem_42_1_Norm_A <- align(index = "Casus_RA", readfile1 = "SRR4785831_1_subset40k.fastq", readfile2 = "SRR4785831_2_subset40k.fastq", output_file = "Fem_42_1_Norm.A.BAM")
align.Fem_54_1_RA_A <- align(index = "Casus_RA", readfile1 = "SRR4785979_1_subset40k.fastq", readfile2 = "SRR4785979_2_subset40k.fastq", output_file = "Fem_54_1_RA.A.BAM")
align.Fem_66_1_RA_A <- align(index = "Casus_RA", readfile1 = "SRR4785980_1_subset40k.fastq", readfile2 = "SRR4785980_2_subset40k.fastq", output_file = "Fem_66_1_RA.A.BAM")
align.Fem_60_1_RA_A <- align(index = "Casus_RA", readfile1 = "SRR4785986_1_subset40k.fastq", readfile2 = "SRR4785986_2_subset40k.fastq", output_file = "Fem_60_1_RA.A.BAM")
align.Fem_59_1_RA_A <- align(index = "Casus_RA", readfile1 = "SRR4785988_1_subset40k.fastq", readfile2 = "SRR4785988_2_subset40k.fastq", output_file = "Fem_59_1_RA.A.BAM")

#gemapte reads visualiseren ----
#bestandsnamen van de monsters
samples <- c('Fem_31_1_Norm.A.BAM', 'Fem_15_1_Norm.A.BAM', 'Fem_31_2_Norm.A.BAM', 'Fem_42_1_Norm.A.BAM', 'Fem_54_1_RA.A.BAM', 'Fem_66_1_RA.A.BAM', 'Fem_60_1_RA.A.BAM', 'Fem_59_1_RA.A.BAM')
#voor elk monster het indexeren en sorteren van de files
#sorteren van de BAM-bestanden
lapply(samples, function(s) {sortBam(file = paste0(s, '.BAM'), destination = paste0(s, '.sorted'))})
#indexeren van de gesorteerde BAM-file
lapply(samples, function(s) {indexBam(file = paste0(s, '.sorted.bam'))})

#count matrix maken ----
count_matrix <- featureCounts(
  files = samples,
  annot.ext = "genomic.gtf",
  isPairedEnd = TRUE,
  isGTFAnnotationFile = TRUE,
  GTF.attrType = "gene_id",
  useMetaFeatures = TRUE)
#bekijken van de count matrix ----
counts <- read.table("count_matrix_RA.txt")
str(count_matrix)
#counts eigen naam geven
counts <- "count_matrix_RA.txt"
head(counts)
#kolomnamen instellen
counts <- read.table("count_matrix_RA.txt",
                     header = TRUE,
                     row.names = 1)
colnames(counts) <- c("31_1_Norm", "15_1_Norm", "31_2_Norm", "42_1_Norm", "54_1_RA", "66_1_RA", "60_1_RA", "59_1_RA")


#////////////////////////////////////////////////////////////////////////////////////////////////////####
#analyses uitvoeren ####

#metadata tabel maken ----
treatment <- c("Normal", "Normal", "Normal", "Normal", "RA", "RA", "RA", "RA")
treatment_table <- data.frame(treatment)
rownames(treatment_table) <- colnames(counts)


#DESeq2 analyse uitvoeren + aparte genlijsten maken ----
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = treatment_table,
  design = ~ treatment)

dds <- DESeq(dds)
resultaten <- results(dds)

#aparte genlijsten maken (upregulated genes vs downregulated genes)
up_genes <- rownames(
  resultaten[
    !is.na(resultaten$padj) &
      !is.na(resultaten$log2FoldChange) &
      resultaten$padj < 0.05 &
      resultaten$log2FoldChange > 1,])

down_genes <- rownames(
  resultaten[
    !is.na(resultaten$padj) &
      !is.na(resultaten$log2FoldChange) &
      resultaten$padj < 0.05 &
      resultaten$log2FoldChange < -1,])

length(up_genes)
length(down_genes)

write.csv(as.data.frame(resultaten),
          "DESeq2_resultaten.csv")

#overzicht van de resultaten
summary(resultaten)

#PCA plot (controleert biologisch verschil tussen de groepen) ---- 
vsd <- vst(dds)
plotPCA(vsd, intgroup = "treatment")
# PC1 is 74% var, PC2 is 10% var (Dat betekent dat je PCA-plot al 84% van de verschillen tussen de monsters samenvat in twee dimensies.)
#heatmap (top 50 significante genen) ----
top50 <- head(order(resultaten$padj), 50)
mat <- assay(vsd)[top50, ]
pheatmap(
  mat,
  scale = "row",
  annotation_col = treatment_table)
#aparte clustering is niet meer nodig, want dat gebeurt automatisch al

#volcanoplot maken ----
library(EnhancedVolcano)

EnhancedVolcano(
  resultaten,
  lab = rownames(resultaten),
  x = "log2FoldChange",
  y = "padj",
    #kleuren plot aanpassen
col = c(
  "seashell3",    # niet significant
  "steelblue3",      # alleen fold change cutoff gehaald
  "palegreen",     # alleen significant in de p-waarde
  "salmon"        # zowel stat. significant als FC cutoff gehaald
  ))
#KEGG analyse (KEGG pathway enrichment analyse.) ----
sig_genes <- rownames(resultaten[
  which(resultaten$padj < 0.05 &
          abs(resultaten$log2FoldChange) > 1),])
length(sig_genes)

#GeneID type controleren (Gene Symbols)
head(rownames(resultaten))

#omzetten van de genes van symbols naar de entrez IDS
gene_df <- bitr(
  sig_genes,
  fromType = "SYMBOL",
  toType = "ENTREZID",
  OrgDb = org.Hs.eg.db)

#controleren van de omzetting
head(gene_df)

#KEGG-analyse uitvoeren
kegg_results <- enrichKEGG(
  gene = gene_df$ENTREZID,
  organism = "hsa",
  pvalueCutoff = 0.05)
#resultaten bekijken
head(as.data.frame(kegg_results))
#visualisatie
barplot(kegg_results, showCategory = 15)  #laat absolute getallen zien

dotplot(kegg_results, showCategory = 15)  #laat verhoudingen zien

#controleren omzetten van de genen
length(sig_genes)
nrow(gene_df)

#GO-analyse ----

#selecteer significante genen
sig <- resultaten[which(resultaten$padj < 0.05 & abs(resultaten$log2FoldChange) > 1), ]
genes <- rownames(sig)
library(enrichplot)

#GO analyse Biological process
go_bp <- enrichGO(
  gene = gene_df$ENTREZID,
  OrgDb = org.Hs.eg.db,
  keyType = "ENTREZID",
  ont = "BP",
  pAdjustMethod = "BH",
  pvalueCutoff = 0.05,
  qvalueCutoff = 0.05,
  readable = TRUE)
head(as.data.frame(go_bp))

go_df <- as.data.frame(go_bp)

dim(go_df)
head(go_df, 20)

#visualisatie plots
barplot(go_bp, showCategory = 15)  #laat absolute getallen zien
dotplot(go_bp, showCategory = 15)  #laat verhoudingen zien

#opslaan in excel
write.csv(
  as.data.frame(go_bp),
  "GO_BP_results.csv",
  row.names = FALSE)
#20 meest belangrijke biologische processen
go_df <- as.data.frame(go_bp)
go_df[order(go_df$p.adjust), ][1:20, ]
#pathview gene pathway analysis ----
library(pathview)

#vector maken van de log2foldchanges (resultsdds)
gene_fc <- resultaten$log2FoldChange
names(gene_fc) <- rownames(resultaten)

#weer omzetten naar entrez IDS
gene_df <- bitr(
  rownames(resultaten),
  fromType = "SYMBOL",
  toType = "ENTREZID",
  OrgDb = org.Hs.eg.db)

#fold changes toevoegen
gene_df$logFC <- resultaten$log2FoldChange[
  match(gene_df$SYMBOL,
        rownames(resultaten))]

#maken van de pathview vector
fc_vector <- gene_df$logFC
names(fc_vector) <- gene_df$ENTREZID

#kiezen/bekijken van de beste KEGG pathways
head(as.data.frame(kegg_results))

#top 5 pathways uit de KEGG-analyse in de analysis opslaan in de working directory
kegg_df <- as.data.frame(kegg_results)

top_pathways <- kegg_df$ID[1:5]

for(pid in top_pathways){
    pathview(
    gene.data = fc_vector,
    pathway.id = gsub("hsa", "", pid),
    species = "hsa",
    gene.idtype = "entrez")}
#beste pathway (rheumatoid artritis)= 
pathview(
  gene.data = fc_vector,
  pathway.id = "hsa05323",
  species = "hsa",
  gene.idtype = "entrez")
#visualisatie van de pathway/bekijken van de png van de beste pathways

#pathway reumatoid artritis
img <- readPNG("hsa05323.pathview.png")
plot.new()
rasterImage(img, 0, 0, 1, 1)
#pathway IL-17 signaling
img <- readPNG("hsa04657.pathview.png")
plot.new()
rasterImage(img, 0, 0, 1, 1)
#Pathway TNF signaling
img <- readPNG("hsa04668.pathview.png")
plot.new()
rasterImage(img, 0, 0, 1, 1)
