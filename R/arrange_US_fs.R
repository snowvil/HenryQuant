#' Arrange all listed firm's financial statement data in US Markets.
#'
#' You should be execute get_US_fs function first to download financial statement data.
#' It will arrange fs data by account for list type, and save csv file.
#' @return arranged financial statement data by account
#' @importFrom utils read.csv write.csv
#' @importFrom magrittr "%>%" set_colnames set_rownames
#' @importFrom tibble column_to_rownames
#' @importFrom dplyr bind_rows
#' @examples
#' \dontrun{
#'  US_fs = arrange_US_fs()
#'  }
#' @export
arrange_US_fs = function() {

  fs_name = "US_fs"
  if (dir.exists(fs_name) == FALSE) {
    stop("You Need Download Financial Statement Data. Please execute get_US_fs() first")
  }

  ticker = get_US_ticker()

  test = read.csv(paste0(getwd(),"/",fs_name,"/",ticker[1,1],"_fs.csv"))
  m = nrow(test) - 1
  n = ncol(test) - 1
  fs_colnames = paste0("Past ",seq(n)," Yr")
  fs_account = unique(test[,1]) %>% as.character

  fs_list = rep( list(list()), m )

  for (i in 1 : nrow(ticker)) {
    tryCatch({
      temp = matrix(NA, m, n) %>% as.data.frame %>% set_colnames(fs_colnames)
      temp = read.csv(paste0(getwd(),"/",fs_name,"/",ticker[i,1],"_fs.csv"))
      temp = temp[!duplicated(temp[,1]),] %>% set_rownames(NULL) %>%
        column_to_rownames(var = "X")
      if (ncol(temp) != 4) {
        temp = cbind(temp, matrix(NA, nrow(temp), (n-ncol(temp)) ))
      }
      colnames(temp) = fs_colnames
    }, error = function(e){})

    for (j in 1 : m) {
      if (i == 1) {
        fs_list[[j]] = temp[j, ]
      } else {
        fs_list[[j]] = bind_rows(fs_list[[j]], temp[j, ])
      }
    }

    if ((i %% 50) == 0) { print(paste0(round((i / nrow(ticker)) * 100,2)," %")) }
  }

  fs_list = lapply(fs_list, function(x) {row.names(x) = ticker[,1]; x})
  names(fs_list) = fs_account
  write.csv(fs_list, "US_fs_list.csv")
  return(fs_list)

}
