#' Get site html.
#'
#' @name get_site
#' @param url A vector of URLs
#' @return A data frame
#'
#'
#' @export
#' @rdname get_site
#'
get_site <- function(url) {
    require(xml2)
    require(httr)

  ## non of this error business works -- and a poorly internet connection will return very few results -- ???
  site <- tryCatch(
    xml2::read_html(GET(url, timeout(60)))),
    error = function(e) paste("Error"))

  if(any(site == 'Error')) {
    data.frame(doc_id = url,
               type = '',
               text = '') } else{
                 ntype1 <- 'p,h1,h2,h3'

                 w0 <- rvest::html_nodes(site, ntype1)
                 if(length(w0) == 0) {
                   w1 <- ''
                   w2 <- '' } else{
                     w1 <- rvest::html_name(w0)
                     w2 <- rvest::html_text(w0)
                   }
                 data.frame(doc_id = url,
                            type = w1,
                            text = w2)
               }
}
