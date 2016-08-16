#' Create TARGET OS clinical data.frame from raw data
#'
#' Create TARGET OS clinical data.frame from raw data in the TARGETOsteoDataPackage
#'
#' @import readr
#' @import dplyr
#' @import FDb.InfiniumMethylation.hg19
#' @import SummarizedExperiment
#' @export
getmiRNA = function() {
    clinical = getClinical()
    tmp = read_tsv('ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/miRNA_pcr/L2/TARGET_OS_miRNA_level2_dCt.txt')
    tmp2 = as.matrix(tmp[,-1])
    rownames(tmp2) = make.unique(tmp %>% .[['miRNA']])
    ovl = intersect(colnames(tmp2),rownames(clinical))
    rowdata = DataFrame(miRNA=sub('[-0-9]+$','',rownames(mir)))
    rownames(rowdata) = make.unique(rownames(tmp2))
    se = SummarizedExperiment(assays=list(exprs=tmp2[,ovl]),
                              colData=clinical[ovl,],
                              rowData=rowdata)
    return(se)
}
