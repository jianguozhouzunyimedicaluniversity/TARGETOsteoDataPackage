## This file simply downloads and drops into the correct
## locations. The script should be run from the top level
## package directory (same as DESCRIPTION).
dir.create('inst/extdata',recursive=TRUE)

## Gene Expression Data
gene_expression_url='ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/gene_expression_array/L3/gene_core_rma_summary_annot.txt'
gene_expression_file='inst/extdata/gene_core_rma_summary_annot.txt'
download.file(gene_expression_url,gene_expression_file)
system(paste('gzip -f',gene_expression_file))


## Methylation Data
meth_url = 'ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/methylation_array/L2/TARGET_OS_meth_level2.txt'
meth_file = 'inst/extdata/TARGET_OS_meth_level2.txt'
download.file(meth_url,meth_file)
system(paste('gzip -f',meth_file))

## Copy number

## SNP6
cgh_url = 'ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/copy_number_array/L3/TARGET_OS_L3_Segmentation.txt'
cgh_file = 'inst/extdata/TARGET_OS_L3_Segmentation.txt'
download.file(cgh_url,cgh_file)
system(paste('gzip -f',cgh_file))

## CGI
library(httr)
cgi_url = 'ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/WGS/L3/copy_number/CGI/'
fnames=do.call(rbind,sapply(as.character(read.delim(text=content(GET(cgi_url),type='text'))[,1]),strsplit,'\\s'))[,21]
dir.create('inst/extdata/copy_number_cgi',recursive=TRUE)
sapply(fnames,function(x) {
  download.file(file.path(cgi_url,x),file.path('inst/extdata/copy_number_cgi',x))
  system(paste('gzip -f',file.path('inst/extdata/copy_number_cgi',x)))
})

## miRNA
mirna_url = 'ftp://caftpd.nci.nih.gov/pub/dcc_target/OS/miRNA_pcr/L2/TARGET_OS_miRNA_level2_dCt.txt'
mirna_file = 'TARGET_OS_miRNA_level2_dCt.txt'
download.file(mirna_url,mirna_file)
system(paste('gzip -f',mirna_file))


