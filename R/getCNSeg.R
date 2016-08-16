#' Create TARGET OS clinical data.frame from raw data
#'
#' Create TARGET OS clinical data.frame from raw data in the TARGETOsteoDataPackage
#'
#' @import readr
#' @import dplyr
#' @import SummarizedExperiment
#' @import GenomicRanges
#' @export
getCNSeg = function() {
    clinical = getClinical()
    tmp = read_tsv(system.file('extdata/TARGET_OS_meth_level2.txt.gz',package='TARGETOsteoDataPackage'))
    segs = read_tsv('ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/copy_number_array/L3/TARGET_OS_L3_Segmentation.txt')
    segs = GRanges(seqnames=segs$Chromosome,
                    ranges=IRanges(start=segs$Start,end=segs$End),
                    mcols = DataFrame(sample_id=substr(segs$SampleName,1,16),
                                      segs[,'Num Probes'],
                                      segs[,'Segment Mean']))
    colnames(mcols(segs))=sub('mcols\\.','',colnames(mcols(segs)))
    return(segs)
}
