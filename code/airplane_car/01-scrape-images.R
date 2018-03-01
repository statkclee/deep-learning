# 0. 환경설정 -----
library(tidyverse)
# http://statkclee.github.io/data-science/ds-phantomJS.html
# https://flovv.github.io/scrape_images_google/

# 1. 검색어 불러오기 -----

scrapeJSSite <- function(searchTerm){
    url <- paste0("https://www.google.de/search?q=",searchTerm, "&source=lnms&tbm=isch&sa=X")
    
    lines <- readLines("code/airplane_car/imageScrape.js")
    lines[1] <- paste0("var url ='", url ,"';")
    writeLines(lines, "code/airplane_car/imageScrape.js")
    
    ## 다운로드 웹사이트 실행
    system("phantomjs code/airplane_car/imageScrape.js")
    
    pg <- read_html("1.html")
    files <- pg %>% html_nodes("img") %>% html_attr("src")
    df <- data.frame(images=files, search=searchTerm)
    return(df)
}

# 2. 검색 이미지 다운로드 함수 -----

downloadImages <- function(files, type, outPath="data/images"){
    for(i in 1:length(files)){
        download.file(files[i], destfile = paste0(outPath, "/", type, "_", i, ".jpg"), mode = 'wb')
    }
}

# 3. 이미지 다운로드 실행 -----
## 3.1. 비행기 이미지 다운로드 
airplane_df <- scrapeJSSite(searchTerm = "airplane") %>% 
    filter(!str_detect(images, "tia.png"))

downloadImages(as.character(airplane_df$images), "airplane")

## 3.2. 자동차 이미지 다운로드 
airplane_df <- scrapeJSSite(searchTerm = "car") %>% 
    filter(!str_detect(images, "tia.png"))

downloadImages(as.character(airplane_df$images), "car")


