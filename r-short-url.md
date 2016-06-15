---
layout: page
title: xwMOOC 딥러닝
subtitle: R 구글 url 축약-googleAuthR
---

> ## 학습 목표 {.objectives}
>
> * 구글 인증 팩키지를 이해한다.
> * url 단축 API를 R에서 호출해서 개발한다.

### 1. `googleAuthR` 팩키지를 통한 url 축약 [^googleAuthR-vignette]

[^googleAuthR-vignette]: [googleAuthR - Google API Client Library for R](https://cran.r-project.org/web/packages/googleAuthR/vignettes/googleAuthR.html)

~~~ {.r}
##=========================================================================================
## 1. 환경설정
##=========================================================================================
# 팩키지 설치 
if("googleAuthR" %in% installed.packages() == FALSE) install.packages("googleAuthR")
library(googleAuthR)

# GA 계정 인증
client.id <- "xxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com"
client.secret <- "xxxxxxxxxxxxxxxxxxxxxx"


options("googleAuthR.client_id" = client.id)
options("googleAuthR.client_secret" = client.secret)

options("googleAuthR.scopes.selected" = 
          c("https://www.googleapis.com/auth/urlshortener"))

googleAuthR::gar_auth()

##=========================================================================================
## 2. url 축약
##=========================================================================================

#' Shortens a url using goo.gl
#'
#' @param url URl to shorten with goo.gl
#' 
#' @return a string of the short URL
#'
#' Documentation: https://developers.google.com/url-shortener/v1/getting_started

## a wrapper for the function that users pass in the URL to shorten
shorten_url <- function(url){
  
  ## turns into {'longUrl' : '<<example.com>>'} when using jsonlite::toJSON(body)
  body = list(
    longUrl = url
  )
  
  ## generate the API call function
  ## POST https://www.googleapis.com/urlshortener/v1/url
  ## response has 4 objects $kind, $id, $longUrl, and $status, but we only want $id
  f <- gar_api_generator("https://www.googleapis.com/urlshortener/v1/url",
                         "POST",
                         data_parse_function = function(x) x$id)

  ## now the function has been generated, pass in the body.
  ## this function has no need for path_arguments or pars_arguments, but that will differ for other APIs.
  f(the_body = body)
}

## to use:

gar_auth()
shorten_url("http://www.google.com")
~~~

~~~ {.r}
[1] "http://goo.gl/FpCtwi"
~~~

