#' Create TARGET OS clinical data.frame from raw data
#'
#' Create TARGET OS clinical data.frame from raw data in the TARGETOsteoDataPackage
#'
#' @import readxl
#' @export
getClinical = function() {
    tmp = read_excel(system.file('extdata/TARGET_OS_Discovery_Toronto_COG_89_FCCs_ClinicalData_7_29_2015_harmonized.xlsx',package='TARGETOsteoDataPackage'))
    colnames(tmp)=make.names(colnames(tmp))
    rownames(tmp)=tmp$TARGET.USI
    return(tmp)
}
