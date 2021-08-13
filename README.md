<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/jaytimm/quicknews.svg?branch=main)](https://travis-ci.com/jaytimm/quicknews)
<!-- badges: end -->

quicknews
=========

A simple, lightweight news article extractor, with functions for:

1.  extracting metadata for articles posted on Google News;
2.  scraping online news article content per user-specified URL; and
3.  resolving shortened URLs.

Installation
------------

``` r
devtools::install_github("jaytimm/quicknews")
```

Usage
-----

### § Google News metadata

The `qnews_get_newsmeta` retrieves metadata from news articles posted to
Google News based on user-specified search. Via the `term` parameter. By
default, metadata for articles included in the Headlines section are
extracted.

``` r
metas <- quicknews::qnews_get_newsmeta (term = NULL)
```

<table>
<colgroup>
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 10%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">term</th>
<th style="text-align: left;">date</th>
<th style="text-align: left;">source</th>
<th style="text-align: left;">title</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">headlines</td>
<td style="text-align: left;">2021-08-13</td>
<td style="text-align: left;">ESPN</td>
<td style="text-align: left;">White Sox-Yankees Field of Dreams remake captures baseball fans everywhere</td>
</tr>
<tr class="even">
<td style="text-align: left;">headlines</td>
<td style="text-align: left;">2021-08-13</td>
<td style="text-align: left;">MLB.com</td>
<td style="text-align: left;">Wander’s unique Fenway HR: ‘That’s a first’</td>
</tr>
<tr class="odd">
<td style="text-align: left;">headlines</td>
<td style="text-align: left;">2021-08-13</td>
<td style="text-align: left;">ESPN India</td>
<td style="text-align: left;">Pittsburgh Steelers fill need at linebacker, acquire Joe Schobert from Jacksonville Jaguars, source says</td>
</tr>
<tr class="even">
<td style="text-align: left;">headlines</td>
<td style="text-align: left;">2021-08-12</td>
<td style="text-align: left;">New York Post</td>
<td style="text-align: left;">US sends troops to evacuate Afghan embassy staff amid Taliban gains</td>
</tr>
<tr class="odd">
<td style="text-align: left;">headlines</td>
<td style="text-align: left;">2021-08-12</td>
<td style="text-align: left;">The Guardian</td>
<td style="text-align: left;">US population now less than 60% white, 2020 census finds</td>
</tr>
</tbody>
</table>

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
    ## [1] "US sends troops to evacuate Afghan embassy staff amid"
    ## [2] "Taliban gains"                                        
    ## 
    ## $text
    ##  [1] "WASHINGTON — President Biden on Thursday ordered a"         
    ##  [2] "large deployment of troops to help evacuate US embassy"     
    ##  [3] "staff from Kabul amid rapid Taliban gains in Afghanistan."  
    ##  [4] "Pentagon spokesman John Kirby said that 3,000 US troops are"
    ##  [5] "going to reinforce the more than 600 US troops already"     
    ##  [6] "working at or near the embassy. He said US officials didn’t"
    ##  [7] "want to “wait until it’s too late.” “This is a US decision" 
    ##  [8] "by the commander in chief to reduce civilian personnel and" 
    ##  [9] "to have US military personnel flow in to help with that"    
    ## [10] "reduction,” Kirby said. Another 3,500 US troops will deploy"
