#' Unshorten urls -- mostly from Twitter.
#'
#' @name twt_unshorten_urls
#' @param x A vector of shortened URLs
#' @return A data frame
#'
#'
#' @export
#' @rdname twt_unshorten_urls
#'
twt_unshorten_urls <- function(x) {

  x2 <- data.table::data.table(short_url = x)
  x2$long_url <- url_get_v1(url = x2$short_url)
  return(x2)
}


url_get_v1 <- function(url) {
  
  s_HEAD <- purrr::safely(httr::HEAD)
  
  unlist(lapply(url, function(x) {
    res <- s_HEAD(x,
                  httr::user_agent('qnews-r-package'),
                  httr::timeout(5))
    
    if(length(grepl('Timeout was reached', res$error)) > 0) {
      y <- 'timeout' } else{
        y <- res$result$url
        if(is.null(y)) {y <- httr::GET(x)}
      }
    y})
  )
}

