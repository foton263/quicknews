#' Clean, make uniform URL format -- mostly from Twitter. Identify URLs that have been shortened.
#'
#' @name qnews_clean_urls
#' @param url A vector of URLs
#' @return A data frame
#'
#' @export
#' @rdname qnews_clean_urls
qnews_clean_urls <- function(url) {

  y <- unique(unlist(url))
  y <- unlist(strsplit(y, ' '))

  x <- data.frame('urls_url' = y)
  x2 <- subset(x, nchar(x$urls_url) > 5)
  ### kill PDFs --
  x2 <- subset(x2, !grepl('\\.pdf', x2$urls_url))

  x2$source <- gsub('(http)(s)?(://)(www\\.)?', '', x2$urls_url)
  x2$source <- gsub('/.*$', '', x2$source)

  x2$is_short <- ifelse(grepl('^[a-z \\.]*\\.[a-z][a-z]$|tinyurl', x2$source), 1, 0)

  return(x2)
}

