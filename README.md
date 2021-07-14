<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/jaytimm/quicknews.svg?branch=master)](https://travis-ci.com/jaytimm/quicknews)
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
<td style="text-align: left;">2021-07-13</td>
<td style="text-align: left;">NBC News</td>
<td style="text-align: left;">Biden condemns ‘selfishness’ of stolen election lie pushed by Trump</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2021-07-13</td>
<td style="text-align: left;">CNN</td>
<td style="text-align: left;">A new poll shows why some vaccine-hesitant Americans decided to get the Covid-19 shot</td>
</tr>
<tr class="even">
<td style="text-align: left;">2021-07-13</td>
<td style="text-align: left;">New York Post</td>
<td style="text-align: left;">American suspect in Haiti president’s assassination was ‘confidential’ DEA source</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2021-07-13</td>
<td style="text-align: left;">CNN</td>
<td style="text-align: left;">Handgun sale ban to under 21-year-olds is unconstitutional, appeals court says</td>
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

``` r
clean_urls <- quicknews::qnews_clean_urls(url = tweets_df1$urls_url)
shorts <- clean_urls %>% filter(is_short == 1)
quicknews::qnews_unshorten_urls(x = shorts$urls_url)
```
