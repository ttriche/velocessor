#' velocity wrapper, modularizes pipelined loading
#' 
#' FIXME: add CellRank inference of directions
#'
#' @param txis    A SingleCellExperiment with assays 'spliced' and 'unspliced'
#' @param embed   Into which reducedDims() element shall scVelo project? (UMAP)
#' @param scvmode scVelo mode (default "stochastic"; "dynamical" also available)
#' @param cleanup clean up size factors (rather than droppping cells)? (FALSE)
#' @param ...     Additional arguments passed to velociraptor::scvelo 
#'
#' @return        A SingleCellExperiment with scVelo output in metadata() 
#' 
#' @import scran
#' @import velociraptor
#' @import BiocGenerics
#' @import SingleCellExperiment
#' 
#' @export
compute_velocity <- function(txis, embed="UMAP", scvmode="stochastic", cleanup=FALSE, ...) { 

  message("Removing dead cells and low-variance genes for velocity")
  mt <- names(subset(rowRanges(txis), seqnames %in% c("chrM", "chrMT", "MT")))
  txis$mtPercent <- (colSums(counts(txis[mt,])) / colSums(counts(txis))) * 100
  mtCut <- max(quantile(txis$mtPercent, 0.95), 10, na.rm=TRUE)
  live <- colnames(txis)[txis$mtPercent < mtCut]

  dimred <- ifelse("HARMONY" %in% reducedDimNames(txis), "HARMONY", "PCA")
  if (!dimred %in% reducedDimNames(txis)) txis <- runPCA(txis)
  
  dec <- modelGeneVar(txis[, live])
  HVGs <- scran::getTopHVGs(dec, n=1000)
  txis <- fix_cells(txis, clean=cleanup)
  
  message("Adding velocity...") 
  metadata(txis)$scVelo <- velociraptor::scvelo(txis,
                                                subset.row=HVGs, 
                                                use.dimred=dimred, 
                                                assay.X="spliced", 
                                                sf.X=txis$sf.spl,
                                                sf.spliced=txis$sf.spl,
                                                sf.unspliced=txis$sf.unspl,
                                                mode=scvmode, 
                                                ...) 
  message("Added scVelo (", scvmode, " mode) output to metadata(txis)$scVelo")

  message("Adding velocity_pseudotime...")
  txis$velocity_pseudotime <- metadata(txis)$scVelo$velocity_pseudotime
  message("Added pseudotime output to metadata(txis)$velocity_pseudotime")
 
  # need to 1) fix this and 2) add cellrank support pronto 
  if (scvmode == "dynamical") {
    message("Adding latent_time...")
    txis$latent_time <- metadata(txis)$scVelo$latent_time
    message("Added latent time output to metadata(txis)$latent_time")
  }
    
  message("Embedding velocity onto ", embed, " coordinates...")
  if (!embed %in% reducedDimNames(txis) | ncol(reducedDim(txis, embed) < 3)) {
    if (embed == "UMAP") {  # fixme: generalize
      if ("HARMONY" %in% reducedDimNames(txis)) {
        txis <- scater::runUMAP(txis, ncomponents=3, dimred="HARMONY")
      } else { 
        # PCA -- generate via izar_transform if plate-seq? (FIXME)
        txis <- scater::runUMAP(txis, ncomponents=3)
      } 
    }
  } 

  if (embed %in% reducedDimNames(txis)) { 
    embedded <- 
      velociraptor::embedVelocity(reducedDim(txis,embed), metadata(txis)$scVelo)
    metadata(txis)$embedded <- embedded
    message("Added scVelo embedding to metadata(txis)$embedded")
  } else { 
    message("Requested embedding was not found and cannot be autogenerated.")
    message("Skipping velocity embedding.")
  }

  message("Done.")
  return(txis) 

}
