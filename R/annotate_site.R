#' Annotate site.
#'
#' @name annotate_site
#' @param site A data frame from get_site()
#' @return A data frame
#'
#'
#' @export
#' @rdname annotate_site
#'
annotate_site <- function(site) {

  junk1 <- paste0(quicknews::junk_phrases, collapse = '|')
  site$text <- trimws(site$text)

  ## -- title may be empty --
  title <- subset(site, site$type == 'h1')$text
  title <- title[length(title)]
  if(length(title) == 0) {title <- NA}
  site$title <- title

  site$place <- stats::ave(seq_len(nrow(site)),
                           site$doc_id,
                           FUN = seq_along)

  site$not_pnode <- ifelse(site$type == 'p', 0, 1)
  site$has_ellipses <- ifelse(grepl('\\.\\.\\.(.)?$',
                                    site$text), 1, 0)

  ## falsely ids quotations as no stops --
  site$no_stop <-  ifelse(grepl('(\\.|\\!|\\?)(.)?$',
                                gsub("\"|'", '', site$text)),
                          0, 1)

  site$has_latest <- ifelse(grepl('^latest( .*)? news$|^more( .*)? stories$|^related news$',
                                  site$text,
                                  ignore.case = T),
                            1, NA)
  site$has_latest[site$place == 1] <- 0
  site$has_latest <- zoo::na.locf(site$has_latest)

  site$less_10 <- ifelse(nchar(site$text) > 10, 0, 1)
  site$has_junk <- ifelse(grepl(junk1,
                                site$text,
                                ignore.case = T),
                          1, 0)

  site$discard <- rowSums(site[, c("not_pnode",
                                   "has_latest",
                                   "has_ellipses",
                                   "no_stop",
                                   "less_10",
                                   "has_junk")])

  site$discard <- ifelse(site$discard > 0, 'junk', 'keep')

  return(site)
}
