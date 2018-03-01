# 0. 환경설정 -----
library(tidyverse)
library(keras) # install_keras(method="auto")
library(EBImage)
library(reticulate)

# install_keras(method="conda")

# https://github.com/rstudio/keras/issues/218
# py_available()
# py_config()
# py_discover_config("keras")


# 1. 이미지 불러오기 -----

img_lst <- list.files("data/images/")
img_lst <- map(img_lst, function(x) paste0("data/images/", x))

imgs_lst <- map(img_lst, readImage)

## 1.1. 이미지 살펴보기 -----

par(mfrow = c(8,5))
for (i in 1:40) plot(imgs_lst[[i]])

# 2. 이미지 시각화 -----

imgs_resize_lst <- map(imgs_lst, resize, w =28, h=28)

# imgs_resize_lst <- map(imgs_resize_lst, array_reshape, c(28, 28, 3))

imgs_resize_combined <- combine(imgs_resize_lst)

tile(imgs_resize_combined, 8) %>% 
    display()

# 3. 이미지 내보내기 -----

imgs_resize_lst %>% saveRDS("data/imgs.rds")
