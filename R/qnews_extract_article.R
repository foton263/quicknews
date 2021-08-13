#' Extract article content from online news sources.
#'
#' @name qnews_extract_article
#' @param url A vector of URLs
#' @param cores An integer value specifying n threads
#' @return A data frame
#'
#'
#' @export
#' @rdname qnews_extract_article
#'
#'
qnews_extract_article <- function(url,
                                  cores) {

  #batches <- split(url, ceiling(seq_along(url)/(length(url)/cores)))
  batches <- split(url, ceiling(seq_along(url)/20))
  # n <- cores

  build_table <- function (url0) {

    x0 <- lapply(url0, function(x) {
      y0 <- get_site(x)
      y1 <- annotate_site(site = y0)

      y2 <- subset(y1, y1$discard == 'keep')
      data.table::setDT(y2)
      y2[, list(text = paste(text, collapse = " ")),
         by = list(doc_id, title)]
    })

    data.table::rbindlist(x0)
  }


  clust <- parallel::makeCluster(cores)
  parallel::clusterExport(cl = clust,
                          varlist = c('batches'),
                          envir = environment())

  docs <- pbapply::pblapply(cl = clust,
                            X = batches,
                            FUN = build_table
                            # X = 1:n,
                            # FUN = function(i){
                            #   build_table(url0 = batches[[i]]) }
                            )

  parallel::stopCluster(clust)

  data.table::rbindlist(docs)
}
