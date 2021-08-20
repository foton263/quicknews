<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/jaytimm/quicknews.svg?branch=main)](https://travis-ci.com/jaytimm/quicknews)
[![R-CMD-check](https://github.com/jaytimm/quicknews/workflows/R-CMD-check/badge.svg)](https://github.com/jaytimm/quicknews/actions)
<!-- badges: end -->

# quicknews

A simple, lightweight news article extractor, with functions for:

1.  extracting metadata for articles posted on Google News;
2.  scraping online news article content per user-specified URL; and
3.  resolving shortened URLs.

## Installation

You can download the development version from GitHub with:

``` r
devtools::install_github("jaytimm/quicknews")
```

## Usage

### § Google News metadata

The `qnews_get_newsmeta` retrieves metadata from news articles posted to
Google News based on user-specified search. Via the `term` parameter. By
default, metadata for articles included in the Headlines section are
extracted.

``` r
metas <- quicknews::qnews_get_newsmeta (term = NULL)
```

| term      | date       | source              | title                                                                                                                 |
|:----------|:-----------|:--------------------|:----------------------------------------------------------------------------------------------------------------------|
| headlines | 2021-08-20 | NPR                 | WATCH LIVE: Biden Gives An Update On Afghanistan Evacuations                                                          |
| headlines | 2021-08-20 | The Washington Post | Taliban bars female news anchors from state television, reports say                                                   |
| headlines | 2021-08-20 | CBS Boston          | Hurricane Watch For Parts Of Southern New England As Tropical Storm Henri Could Be Historic                           |
| headlines | 2021-08-20 | CNN                 | Florida Board of Education orders Broward, Alachua counties to allow mask opt-out in 48 hours or start losing funding |
| headlines | 2021-08-20 | ABC10               | Friday morning Wildfire update \| What’s burning in Northern California                                               |

### § Article content

The `qnews_extract_article` function is designed for multi-threaded text
extraction from HTML. The function scrapes web content from URLs
specified in the `url` parameter. Via `rvest` and `xml2`. A simple
approach, with no Java dependencies. HTML markups, comments, extraneous
text, etc. are removed mostly via node type, node-final punctuation,
character length, and a small dictionary of “junk” phrases.

``` r
articles <- quicknews::qnews_extract_article(url = metas$link[1:5],
                                             cores = 1)

list(title = strwrap(articles$title[1], width = 60), 
     text = strwrap(articles$text[1], width = 60)[1:5])
```

    ## $title
    ## [1] "WATCH LIVE: Biden Gives An Update On Afghanistan"
    ## [2] "Evacuations"                                     
    ## 
    ## $text
    ## [1] "President Biden will deliver his second speech on"         
    ## [2] "Afghanistan this week, with remarks Friday afternoon about"
    ## [3] "evacuation efforts in Kabul. President Biden will deliver" 
    ## [4] "another speech about Afghanistan on Friday afternoon, as"  
    ## [5] "the scramble to evacuate American citizens and vulnerable"
