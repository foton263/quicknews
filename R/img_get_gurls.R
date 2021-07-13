#' Get links to Google images per some Google search
#'
#' @name img_get_gurls
#' @param x Search term
#' @return A data frame of URLs
#'
#' @export
#' @rdname img_get_gurls
#'
img_get_gurls <- function(x) {
  search1 <- gsub(' ', '\\+', x)
  gsearch_prefix <- 'https://www.google.com/search?q='
  gsearch_suffix <- '&sxsrf=ALeKk03SQBrbFsh26TuFJ1SnNxBbrcyBlQ:1611371709667&source=lnms&tbm=isch&sa=X&ved=2ahUKEwim8euyi7HuAhVxGTQIHRC5Aq4Q_AUoAXoECCAQAw&biw=750&bih=944'

  page <- xml2::read_html(paste0(gsearch_prefix, search1, gsearch_suffix))
  node <- rvest::html_nodes(page, xpath = '//img')
  node1 <- rvest::html_attr(node, "src")
  subset(node1, !grepl('gif$', node1))
}
