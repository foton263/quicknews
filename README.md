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
<col style="width: 8%" />
<col style="width: 12%" />
<col style="width: 79%" />
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
<td style="text-align: left;">New York Post</td>
<td style="text-align: left;">NYC journalist targeted by Iranian operatives in twisted kidnapping plot, feds say</td>
</tr>
<tr class="even">
<td style="text-align: left;">2021-07-14</td>
<td style="text-align: left;">CBSSports.com</td>
<td style="text-align: left;">Team USA basketball vs. Argentina score: Kevin Durant, United States bounce back with dominant win</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2021-07-14</td>
<td style="text-align: left;">CBS sports.com</td>
<td style="text-align: left;">2021 MLB All-Star Game score: Live updates as AL, NL stars meet at Coors Field</td>
</tr>
<tr class="even">
<td style="text-align: left;">2021-07-14</td>
<td style="text-align: left;">NBA</td>
<td style="text-align: left;">Kevin Durant, Bradley Beal &amp; Zach Lavine All Score DOUBLE-FIGURES In USA Victory!</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2021-07-13</td>
<td style="text-align: left;">CNBC</td>
<td style="text-align: left;">Biden condemns Trump’s ‘Big Lie’ in major voting rights speech in Philadelphia</td>
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
    ## [1] "Biden condemns Trump's 'Big Lie' in major voting rights"
    ## [2] "speech in Philadelphia"                                 
    ## 
    ## $text
    ##  [1] "President Joe Biden on Tuesday delivered a major speech on"  
    ##  [2] "voting rights in Philadelphia, slamming his predecessor's"   
    ##  [3] "\"Big Lie\" claim that the 2020 election was stolen.  \"It's"
    ##  [4] "clear, for those who challenge the results or question the"  
    ##  [5] "integrity of the election, no other election has ever been"  
    ##  [6] "held under such scrutiny or such high standards. The 'Big"   
    ##  [7] "Lie' is just that: a big lie,\" Biden said at the National"  
    ##  [8] "Constitution Center, just steps away from Independence"      
    ##  [9] "Hall. The speech comes as his administration faces growing"  
    ## [10] "pressure from civil rights activists and other Democrats to"

``` r
articles2 <- parallel::mclapply(metas$link,
                                quicknews::qnews_extract_article,
                                mc.cores = 6)
```

### § Resolve shortened urls

Shortened URLs are generally encountered in social media. So, we build a
simple demonstration Twitter corpus.

``` r
some_tweets <- rtweet::search_tweets2(q = '#Jan6', 
                                      include_rts = F,
                                      n = 1000)
```

The `qnews_clean_urls` function extracts source info from URL links and
identifies whether or not a link has been shortened. The latter is based
on common shortening practices (eg, bit.ly, goo.gl), and is imperfect.
But false positives here are mostly harmless – a non-shortened URL will
be returned as such.

``` r
clean_urls <- quicknews::qnews_clean_urls(url = some_tweets$urls_url)

head(clean_urls)
```

    ##                             urls_url             source is_short
    ## 2        twitter.com/mehdirhasan/st…        twitter.com        0
    ## 3        twitter.com/Mediaite/statu…        twitter.com        0
    ## 4        twitter.com/TheRickWilson/…        twitter.com        0
    ## 5 washingtonpost.com/opinions/2021/… washingtonpost.com        0
    ## 6       rawstory.com/capitol-riot-2…       rawstory.com        0
    ## 7        twitter.com/ryanjreilly/st…        twitter.com        0

The `qnews_unshorten_urls` can then be used to resolve shortenened URLs.

``` r
shorts <- subset(clean_urls, is_short == 1)
longs <- quicknews::qnews_unshorten_urls(x = shorts$urls_url)

head(longs)
```

    ##               short_url
    ## 1: youtu.be/YeW5sI-R1Qg
    ## 2:       flip.it/r9rAcR
    ## 3:      yhoo.it/3kbCFvW
    ## 4:      abcn.ws/3qxhbJJ
    ## 5: youtu.be/3qYleCGIZLg
    ## 6: youtu.be/JpiLJ_0zQRI
    ##                                                                                                     long_url
    ## 1:                                              https://www.youtube.com/watch?v=YeW5sI-R1Qg&feature=youtu.be
    ## 2: https://www.buzzfeednews.com/article/zoetillman/douglas-jensen-capitol-riot-chased-eugene-goodman-release
    ## 3:                               https://news.yahoo.com/federal-judge-skewered-kraken-lawyers-184750127.html
    ## 4:                https://abcnews.go.com/Politics/fbi-releases-images-dc-pipe-bomb-suspect/story?id=76341036
    ## 5:                                              https://www.youtube.com/watch?v=3qYleCGIZLg&feature=youtu.be
    ## 6:                                              https://www.youtube.com/watch?v=JpiLJ_0zQRI&feature=youtu.be
