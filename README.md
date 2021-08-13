<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/jaytimm/quicknews.svg?branch=main)](https://travis-ci.com/jaytimm/quicknews)
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

| term      | date       | source           | title                                                                                                                                 |
|:----------|:-----------|:-----------------|:--------------------------------------------------------------------------------------------------------------------------------------|
| headlines | 2021-08-13 | The Guardian     | First Thing: Afghanistan likened to fall of Saigon amid advance by Taliban                                                            |
| headlines | 2021-08-13 | Associated Press | Census data: US is diversifying, white population shrinking                                                                           |
| headlines | 2021-08-13 | CNN              | These 8 states make up half of US Covid-19 hospitalizations. And the surge among the unvaccinated is overwhelming health care workers |
| headlines | 2021-08-13 | POLITICO         | 9 Dems threaten mutiny over Pelosi’s budget plan                                                                                      |
| headlines | 2021-08-13 | New York Post    | President Biden urges voters to vote ‘no’ in Newsom’s recall vote                                                                     |

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
    ## [1] "First Thing: Afghanistan likened to fall of Saigon amid"
    ## [2] "advance by Taliban"                                     
    ## 
    ## $text
    ##  [1] "Good morning. The situation in Afghanistan has been likened"
    ##  [2] "to the fall of Saigon, as officials confirmed on Friday"    
    ##  [3] "that the Taliban had captured the country’s second-biggest" 
    ##  [4] "city, Kandahar, as well as Lashkar Gah in the south. The"   
    ##  [5] "Pentagon announced on Thursday it would send three"         
    ##  [6] "battalions, about 3,000 soldiers, to Kabul’s international" 
    ##  [7] "airport within 24 to 48 hours. The defence department"      
    ##  [8] "spokesman, John Kirby, said the reinforcements would help"  
    ##  [9] "the “safe and orderly reduction” of US nationals and"       
    ## [10] "Afghans who worked with Americans and had been granted"
