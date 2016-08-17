#' Create TARGET OS expression SummarizedExperiment from raw data
#'
#' Create TARGET OS expression SummarizedExperiment from raw data in the TARGETOsteoDataPackage
#'
#' @import readr
#' @import dplyr
#' @import SummarizedExperiment
#' @import huex10sttranscriptcluster.db
#' @export
getAffyExpr = function() {
    clinical = getClinical()
    sdrf     = read_tsv('ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/gene_expression_array/METADATA/TARGET_OS_GeneExpressionArray_20160812.sdrf.txt')
    # All rows duplicated, so choose only odds
    sdrf     = sdrf[seq(1,nrow(sdrf),2),]
    fullpheno = clinical %>%
                left_join(sdrf,by=c('TARGET.USI'='Source Name'))
    rownames(fullpheno) = make.unique(fullpheno$TARGET.USI)
    ## make a named vector of new colnames for tmp, with
    ## keys based on celfile names
    cnmap = rownames(fullpheno)
    names(cnmap) = fullpheno %>% .[['Array Data File']]
    tmp = read_tsv('ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/gene_expression_array/L3/gene_core_rma_summary_annot.txt')
    tmp2 = as.matrix(tmp[,-1])
    tmp2 = apply(tmp2,2,as.numeric)
    rownames(tmp2) = tmp %>% .[['probeset_id']]
    colnames(tmp2) = cnmap[colnames(tmp2)]
    ovl = as.character(intersect(colnames(tmp2),rownames(clinical)))
    se = SummarizedExperiment(assays=list(exprs=tmp2[,ovl]),
                              colData=as.data.frame(clinical[match(ovl,rownames(clinical)),]))
    rowdata = AnnotationDbi::select(huex10sttranscriptcluster.db,keys=rownames(se),
                         columns=c('SYMBOL','ACCNUM','ENTREZID','ENSEMBL'),keytype='PROBEID') %>%
              group_by(PROBEID) %>%
              summarize(ACCNUM = paste(ACCNUM,collapse="|"),
                        SYMBOL = paste(SYMBOL,collapse="|"),
                        ENSEMBL = paste(ENSEMBL,collapse="|"),
                        ENTREZID = paste(ENTREZID,collapse="|"))
    rownames(rowdata) = rowdata$PROBEID
    rowData(se) = rowdata[rownames(se),]
    return(se)
}
