#' import plate-seq velocity information (from Salmon) to a SingleCellExperiment
#'
#' Automated (more or less) importation of STORM-seq and SMART-seq[123] data for
#' downstream attempts at merging with droplet data, index sort visualization, 
#' and so forth. 
#' 
#' FIXME: Add Kallisto support and Arkas style txome/repeatome/spikeome support.
#'
#' @param   quants  where the quant.sf files are
#' @param   t2g     required file with tx2gene information for TPM calcs
#' @param   type    What type of quantifications are these? ("salmon") 
#' @param   ...     additional parameters to pass to tximport, if any
#' 
#' @return          A SingleCellExperiment with 'spliced' & 'unspliced' assays.
#'
#' @import scuttle
#' @import tximeta
#' @import tximport
#' @import jsonlite
#' @import rtracklayer
#' @import SingleCellExperiment
#' 
#' @export
import_plate_txis <- function(quants, t2g=NA, type="salmon", ...) {

  if (is.na(t2g)) {
    message("No transcript to gene mapping file provided. Cannot compute TPM.")
    message("(Usually a name like mm10.ens101.annotation.expanded.tx2gene.tsv)")
    stop("This can be guessed from the index, but that is usually a poor idea.")
  } else if (!file.exists(t2g)) {
    message(t2g, " does not exist or cannot be read by this process.")
    stop("Cannot calculate per-gene TPM without tx2gene mappings.")
  } else { 
    tx2gene <- read.delim(t2g, sep="\t", head=FALSE)
  }

  if (!all(file.exists(quants))) stop("Some of your quant files don't exist.") 
  cmds <- sub("quant.*sf", "cmd_info.json", quants)
  if (!all(file.exists(cmds))) stop("Some quants don't have cmd_info.json")
  gtfs <- sapply(cmds, .getGTF) 
  if (length(unique(gtfs)) > 1) stop("Some quants use different GTF files.") 
  gtf <- unique(gtfs)  

  message("Processing ", quants[1], " through ", quants[length(quants)], "...")
  mats <- tximport(quants, type="salmon", txIn=TRUE, tx2gene=tx2gene, ...)
  asys <- mats[ c("counts", "abundance") ]
  names(asys) <- c("counts", "tpm")
  
  message("Reading annotations from ", gtf, "...")
  rr <- .rowRanges(gtf, asys)
  
  message("Constructing sample annotations...")
  cd <- DataFrame(sample=quants)
  if (!is.null(names(quants))) cd <- DataFrame(sample=names(quants))
  txi <- SingleCellExperiment(asys, rowRanges=rr, colData=cd)

  message("Splitting...")
  feats <- sub("\\.gtf", ".features.tsv", gtf)
  cg <- read.delim(feats, header=TRUE, as.is=TRUE)
  colnames(cg)[colnames(cg) == "intron"] <- "unspliced"
  txis <- tximeta::splitSE(txi, cg, assayName="counts")
  assay(txis, "counts") <- assays(txis)[[1]] + assays(txis)[[2]]
  txis2 <- tximeta::splitSE(txi, cg, assayName="tpm")
  assayNames(txis2) <- paste(assayNames(txis2), "tpm", sep="_")
  assay(txis2, "tpm") <- assays(txis2)[[1]] + assays(txis2)[[2]]
  for (an in assayNames(txis2)) assay(txis, an) <- assay(txis2, an)
  txis <- as(txis, "SingleCellExperiment") 
  rm(txis2)

  message("adding NumGenesExpressed...")
  txis$NumGenesExpressed <- colSums(counts(txis) > 0)

  message("adding logNormCounts...")
  txis <- scuttle::logNormCounts(txis)

  message("Done.")
  return(txis) 

}


# helper fn
.getGTF <- function(cmd) jsonlite::fromJSON(cmd)$geneMap


# helper fn
.rowRanges <- function(gtf, asys) { 

  gxs <- subset(rtracklayer::import(gtf), type=="gene")
  names(gxs) <- gxs$gene_id
  granges(gxs)[rownames(asys$counts)]

}