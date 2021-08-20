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

| term      | date       | source        | title                                                                                 |
|:----------|:-----------|:--------------|:--------------------------------------------------------------------------------------|
| headlines | 2021-08-20 | CNN           | Biden set to speak on evacuations as situation in Afghanistan grows desperate         |
| headlines | 2021-08-20 | NPR           | New England Is Facing Its First Direct Hurricane Landfall In 30 Years                 |
| headlines | 2021-08-20 | New York Post | ABC accused of cutting unflattering portions of Biden’s interview                     |
| headlines | 2021-08-20 | CNN           | Dr. Sanjay Gupta: Simple steps for coexisting with the coronavirus                    |
| headlines | 2021-08-20 | NPR           | Rain Fell On The Peak Of Greenland’s Ice Sheet For The First Time In Recorded History |

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
     text = strwrap(articles$text[1], width = 60)[1:10])
```

    ## $title
    ## [1] "Biden set to speak on evacuations as situation in"
    ## [2] "Afghanistan grows desperate"                      
    ## 
    ## $text
    ##  [1] "(CNN)President Joe Biden will deliver remarks on Friday" 
    ##  [2] "about the ongoing US military evacuations of American"   
    ##  [3] "citizens and vulnerable Afghans as chaos ensues at and"  
    ##  [4] "around Kabul's international airport. CNN's Allie Malloy"
    ##  [5] "and Jeff Zeleny contributed to this report."             
    ##  [6] NA                                                        
    ##  [7] NA                                                        
    ##  [8] NA                                                        
    ##  [9] NA                                                        
    ## [10] NA
