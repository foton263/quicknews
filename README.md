<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/jaytimm/quicknews.svg?branch=main)](https://travis-ci.com/jaytimm/quicknews)
<!-- badges: end -->

quicknews
=========

Some R-based tools for working with digital media, including functions
for:

1.  extracting metadata for articles posted on Google News;
2.  resolving shortened URLs; and
3.  scraping online news article content per user-specified URL.

Installation
------------

``` r
devtools::install_github("jaytimm/quicknews")
```

Usage
-----

### § Google News metadata

The `qnews_get_newsmeta` retrieves metadata from news articles posted to
Google News. There are two search parameters: `term` & `since`. By
default, metadata for articles included in the Headlines section are
extracted. Options for the `since` parameter include `1y`, `1d`, and
`7d`.

``` r
metas <- quicknews::qnews_get_newsmeta (term = NULL, since = NULL)
```

<table>
<colgroup>
<col style="width: 7%" />
<col style="width: 9%" />
<col style="width: 83%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">date</th>
<th style="text-align: left;">source</th>
<th style="text-align: left;">title</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">2021-07-14</td>
<td style="text-align: left;">CNN</td>
<td style="text-align: left;">More unmarked graves discovered in British Columbia at a former indigenous residential school known as ‘Canada’s Alcatraz’</td>
</tr>
<tr class="even">
<td style="text-align: left;">2021-07-14</td>
<td style="text-align: left;">CBSSports.com</td>
<td style="text-align: left;">Team USA basketball vs. Argentina score: Kevin Durant, United States bounce back with dominant win</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2021-07-14</td>
<td style="text-align: left;">Yahoo Sports</td>
<td style="text-align: left;">Kevin Durant leads Team USA romp over Argentina after stunning 0-2 exhibition start</td>
</tr>
<tr class="even">
<td style="text-align: left;">2021-07-13</td>
<td style="text-align: left;">NBC News</td>
<td style="text-align: left;">Biden condemns ‘selfishness’ of stolen election lie pushed by Trump</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2021-07-13</td>
<td style="text-align: left;">CNBC</td>
<td style="text-align: left;">Harris, Manchin to meet Texas Democrats who left state in effort to block GOP election bill</td>
</tr>
</tbody>
</table>

### § Article content

The `qnews_extract_article` functions scrapes web content from URLs
specified in the `links` parameter. Via `rvest` and `xml2`. The function
contains a simple filter for culling html nodes not relevant to article
content. It is not perfect – no article extractor is – but no Java
dependencies.

``` r
articles <- quicknews::qnews_extract_article(metas$link[1:5])

list(title = strwrap(articles$title[1], width = 60), 
     text = strwrap(articles$text[1], width = 60)[1:10])
```

    ## $title
    ## [1] "Biden condemns 'selfishness' of stolen election lie pushed"
    ## [2] "by Trump"                                                  
    ## 
    ## $text
    ##  [1] "WASHINGTON — President Joe Biden on Tuesday warned that the" 
    ##  [2] "country was facing a choice between \"democracy or"          
    ##  [3] "autocracy\" following the passage of restrictive voting laws"
    ##  [4] "by nearly two dozen states and took direct aim at former"    
    ##  [5] "President Donald Trump's role in spreading misinformation"   
    ##  [6] "about the 2020 election. \"In America, if you lose, you"     
    ##  [7] "accept the results,\" Biden said in a speech on voting"      
    ##  [8] "rights at the National Constitution Center in Philadelphia." 
    ##  [9] "\"You don’t call facts 'fake' and then try to bring down the"
    ## [10] "American experiment just because you're unhappy. That's not"

``` r
articles2 <- parallel::mclapply(metas$link,
                                quicknews::qnews_extract_article,
                                mc.cores = 6)
```

### § Resolve shortened urls

Shortened URLs are generally encountered in social media. So, we build a
simple demonstration Twitter corpus.

``` r
some_tweets <- rtweet::search_tweets2(q = '#elections2022', 
                                      include_rts = F,
                                      n = 1000)
```

The `qnews_clean_urls` function extracts source info from URL links and
identifies whether or not link has been shortened. The latter is
accomplish using a simple dictionary of common shortening services (eg,
*bitly.com* & *tinyurl.com*)

``` r
clean_urls <- quicknews::qnews_clean_urls(url = some_tweets$urls_url)

head(clean_urls)
```

    ##                         urls_url           source is_short
    ## 1       wjhg.com/2021/07/12/rep…         wjhg.com        0
    ## 2  bloomberg.com/opinion/articl…    bloomberg.com        0
    ## 3               staceyabrams.com staceyabrams.com        0
    ## 4      wsbtv.com/news/politics/…        wsbtv.com        0
    ## 5 vanityfair.com/news/2021/07/t…   vanityfair.com        0
    ## 6           wpr.org/node/1820691          wpr.org        0

The `qnews_unshorten_urls` can then be used to resolve shortenened URLs.

``` r
shorts <- subset(clean_urls, is_short == 1)
longs <- quicknews::qnews_unshorten_urls(x = shorts$urls_url)

head(longs)
```

    ##                            short_url
    ## 1:              youtu.be/w1yDACYyjmM
    ## 2:        lemonde.fr/economie/artic…
    ## 3:                         abattu.es
    ## 4:              youtu.be/B8y6Bm_XDzk
    ## 5: huffingtonpost.fr/entry/en-vue-d…
    ## 6:                   lnkd.in/dM27cx2
    ##                                                                                     long_url
    ## 1:                              https://www.youtube.com/watch?v=w1yDACYyjmM&feature=youtu.be
    ## 2:                                            https://www.lemonde.fr/economie/artic%e2%80%a6
    ## 3:                                                                                   timeout
    ## 4:                              https://www.youtube.com/watch?v=B8y6Bm_XDzk&feature=youtu.be
    ## 5: https://www.huffingtonpost.fr/404/?error=not_found&url=%2Fentry%2Fen-vue-d%25E2%2580%25A6
    ## 6:                                     https://pcinq.org/gilles-le-candidat-dextreme-centre/
