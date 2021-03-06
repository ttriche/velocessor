% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_velo_index.R
\name{make_velo_index}
\alias{make_velo_index}
\title{aped from https://combine-lab.github.io/alevin-tutorial/2020/alevin-velocity}
\usage{
make_velo_index(gtf, fa = NULL, flank = 90L, intron = TRUE, verbose = TRUE)
}
\arguments{
\item{gtf}{a GTF file, usually from ENSEMBL}

\item{fa}{a FASTA file, usually a genome (same as .gtf but .fa)}

\item{flank}{how many bases of intron (90)}

\item{intron}{include unspliced transcripts? (TRUE; for debugging)}

\item{verbose}{squawk? (TRUE)}
}
\value{
\preformatted{ a list with information about the index and tximeta created
}
}
\description{
Given a fasta and a gtf, make a spliced index out of it. Like duh, the idea
is to eventually be able to create linkedTxomes that are really pangenomes.
}
