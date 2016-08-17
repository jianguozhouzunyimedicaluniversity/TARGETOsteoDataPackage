#' Create TARGET OS clinical data.frame from raw data
#'
#' Create TARGET OS clinical data.frame from raw data in the TARGETOsteoDataPackage
#'
#' @import readr
#' @import dplyr
#' @import FDb.InfiniumMethylation.hg19
#' @import SummarizedExperiment
#' @export
getMethylation = function() {
    clinical = getClinical()
    tmp = read_tsv('ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/methylation_array/L2/TARGET_OS_meth_level2.txt')
    tmp2 = as.matrix(tmp[,-1])
    rownames(tmp2) = tmp %>% .[['ReporterID']]
    colnames(tmp2) = substr(colnames(tmp2),1,16)
    ovl = intersect(colnames(tmp2),rownames(clinical))
    se = SummarizedExperiment(assays=list(betas=tmp2[,ovl]),colData=clinical[ovl,])
    rowData(se) = FDb.InfiniumMethylation.hg19::get450k()[rownames(se)]
    return(se)
}
