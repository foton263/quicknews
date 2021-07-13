#' Extract article content from online news sources.
#'
#' @name qnews_extract_article
#' @param url A vector of URLs
#' @return A data frame
#'
#'
#' @export
#' @rdname qnews_extract_article
#'
qnews_extract_article <- function (url) {

  x0 <- lapply(url, function(x) {
    y0 <- get_site(x)
    extract_article(y0, u = x)})

  data.table::rbindlist(x0)
}


get_site <- function(x) {

  site <- tryCatch(
    xml2::read_html(x),
    error = function(e) paste("Error"))

  if(any(site == 'Error')) {
    data.frame(doc_id = x,
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
                 data.frame(doc_id = x,
                            type = w1,
                            text = w2)
               } }


extract_article <- function(z, u) {

  junk <- c('your (email )?inbox',
            'all rights reserved',
            'free subsc',
            '^please',
            '^sign up',
            'Check out',
            '^Get',
            '^got',
            '^you must',
            '^you can',
            '^Thanks',
            '^We ',
            "^We've",
            'login',
            'log in',
            'logged in',
            'Data is a real-time snapshot',
            '^do you',
            '^subscribe to',
            'your comment')

  junk1 <- paste0(junk, collapse = '|')
  z$text <- trimws(z$text)

  z$place <- stats::ave(seq_len(nrow(z)), z$doc_id, FUN = seq_along)

  z$not_pnode <- ifelse(z$type == 'p', 0, 1)
  z$has_ellipses <- ifelse(grepl('\\.\\.\\.(.)?$',
                                 z$text), 1, 0)
  z$no_stop <-  ifelse(grepl('(\\.|\\!|\\?)(.)?$', z$text), 0, 1)

  z$has_latest <- ifelse(grepl('^latest( .*)? news$|^more( .*)? stories$',
                               z$text,
                               ignore.case = T),
                         1, NA)
  z$has_latest[z$place == 1] <- 0
  z$has_latest <- zoo::na.locf(z$has_latest)

  z$less_10 <- ifelse(nchar(z$text) > 10, 0, 1)
  z$has_junk <- ifelse(grepl(junk1,
                             z$text,
                             ignore.case = T),
                       1, 0)

  z$discard <- rowSums(z[, c("not_pnode",
                             "has_latest",
                             "has_ellipses",
                             "no_stop",
                             "less_10",
                             "has_junk")])

  z$discard <- ifelse(z$discard > 0, 'junk', 'keep')

  ## -- title may be empty --
  title <- subset(z, z$type == 'h1')$text
  title <- title[length(title)]
  if(length(title) == 0) {title <- NA}
  z1 <- subset(z, z$discard == 'keep')
  data.frame(url = u,
             title,
             text = paste0(z1$text, collapse = ' '))
}
