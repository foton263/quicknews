#' Get URLs/metadata for articles aggregated on Google News per search
#'
#' @name qnews_get_newsmeta
#' @param term Search term
#' @return A data frame
#'
#'
#' @export
#' @rdname qnews_get_newsmeta
#'
qnews_get_newsmeta <- function(term = NULL) {

  clang_suffix <- 'hl=en-US&gl=US&ceid=US:en&q='
  base <- "https://news.google.com/news/rss/search?"
  tops <- "https://news.google.com/news/rss/?ned=us&hl=en&gl=us"

  if(is.null(term)) rss <- tops else {

    x <- strsplit(term, ' AND ')[[1]]
    y <- unlist(lapply(x, function(q) gsub(' ', '%20', q)))
    y1 <- lapply(y, function(q) gsub('(^.*$)', '%22\\1%22', q))
    search1 <- paste(y1, collapse = "%20AND%20")
    rss <- paste0(base, clang_suffix, search1)
  }

  doc <- xml2::read_xml(rss)

  title1 <- xml2::xml_text(xml2::xml_find_all(doc,"//item/title"))
  title <- gsub(' - .*$', '', title1)
  link <- xml2::xml_text(xml2::xml_find_all(doc,"//item/link"))
  pubDate <- xml2::xml_text(xml2::xml_find_all(doc,"//item/pubDate"))
  source <- sub('^.* - ', '', title1)
  date <- gsub("^.+, ","",pubDate)
  date <- gsub(" [0-9]*:.+$","", date)
  date <- as.Date(date, "%d %b %Y")

  if (is.null(term)) {term <- 'headlines'}
  data.frame(term = term, date, source, title, link)
}
