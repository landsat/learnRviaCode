#' Wrap R source Codes to Emacs Org-mode Babel file
#' @export
#' @title Wrap R source Codes to Emacs Org-mode Babel file
#' @name catR2org
#' @param pkgRepo The folder normally with package name
#' @param pkgWD   The folder hole the packages
#' @details Wrap R source Codes in a package to Emacs Org-mode Babel file
#' @return A .org file - the product of a and b
#' @author Bingwei Tian
#' @example catR2org("landsat")
catR2org  <- function(pkgRepo, pkgWD){
                pkgWD <- getwd()
                pkgDir <- file.path(pkgWD,pkgRepo)
                des1  <- readLines(file.path(pkgDir,"DESCRIPTION"))
                des2  <- gsub(pattern="(^[^:]+):(.+$)",
                                  replacement="\\1%\\2",
                                  x=des1)
                des3  <- paste0("+ ", des1)
                des3
                des  <- as.data.frame(do.call(rbind,strsplit(des2, split = "%")))
                pkgVer  <-des[des[,1] == "Version",][,2]
                pkgVer  <-gsub("(^ *)|( *$)", "", pkgVer)
                pkgName  <- des[des[,1] == "Package",][,2]
                pkgName  <-gsub("(^ *)|( *$)", "", pkgName)
                pkgDate  <- des[des[,1] == "Date",][,2]
                pkgDate  <-gsub("(^ *)|( *$)", "", pkgDate)
                pkgAuthor  <- des[des[,1] == "Author",][,2]
                pkgAuthor  <-gsub("(^ *)|( *$)", "", pkgAuthor)
                pkgAuthor  <-gsub("\\s", "-", pkgAuthor)
                orgName  <- paste0(pkgName, "_", pkgVer, "_(", pkgDate, "_by_",pkgAuthor,").org")
                write.table(des3, orgName, sep = ":",  append = T,quote = F, row.names = F, col.names = F)
                rPath  <- file.path(pkgDir, "/R")
                rFiles  <- list.files(path = rPath, pattern = "[rR]$")
                for (i in c(rFiles)){
                        heading  <- paste0("* ", i)
                        header  <- "#+BEGIN_SRC R "
                        rfile  <- read.table(file = file.path(rPath,i), sep = "\n")
                        ender  <- "#+END_SRC"
                        write.table(rbind(heading, header,rfile, ender), orgName, sep = "\n",  append = T,quote = F, row.names = F, col.names = F)
                }
                message("Wrap R code files to Emacs Org-mode babel file Finished")
}
