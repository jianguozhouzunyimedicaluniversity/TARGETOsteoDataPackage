#' Create TARGET OS clinical data.frame from raw data
#'
#' Create TARGET OS clinical data.frame from raw data in the TARGETOsteoDataPackage
#'
#' @import readr
#' @import SummarizedExperiment
#' @export
getMethylation = function() {
    clinical = getClinical()
    tmp = read_tsv(system.file('extdata/TARGET_OS_meth_level2.txt.gz',package='TARGETOsteoDataPackage'))
    tmp2 = as.matrix(tmp[,-1])
    rownames(tmp2) = tmp[,1]
    colnames(tmp2) = substr(colnames(tmp2),1,16)
    ovl = intersect(colnames(tmp2),rownames(clinical))
    se = SummarizedExperiment(assays=list(betas=tmp2[,ovl]),colData=clinical[ovl,])
    return(se)
}
