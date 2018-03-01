# 0. 환경설정 -----
library(tidyverse)
library(keras)
library(EBImage)
library(reticulate)

# 1. 이미지 불러오기 -----

imgs_lst <- readRDS("data/imgs.rds")

# 2. 이미지 데이터 케라스 모형용으로 변환 -----
## 2.1. 훈련데이터 모형설계행렬(X) 

train_x <- do.call(rbind, imgs_lst)

## 2.2. 훈련데이터 예측(Y)
train_y <- c(rep(0,20), rep(1,20))
train_label <- to_categorical(train_y)

# 3. 딥러닝 모형 -----
## 3.1. 모형 설계
car_airplane_model <- keras_model_sequential()

car_airplane_model %>%
    layer_dense(units = 256, activation = 'relu', input_shape = c(2352)) %>%
    layer_dense(units = 128, activation = 'relu') %>%
    layer_dense(units = 2, activation = 'softmax')

summary(car_airplane_model)

## 3.2. 모형 컴파일
car_airplane_model %>%
    compile(loss = 'binary_crossentropy',
            optimizer = optimizer_rmsprop(),
            metrics = c('accuracy'))

## 3.3. 모형 적합
car_airplane_history <- car_airplane_model %>%
    fit(train_x,
        train_label,
        epochs = 30,
        batch_size = 40,
        validation_split = 0.3)

plot(car_airplane_history)

## 3.4. 모형 평가 및 예측
car_airplane_model %>% evaluate(train_x, train_label)

car_airplane_pred <- car_airplane_model %>% predict_classes(train_x)
car_airplane_prob <- car_airplane_model %>% predict_proba(train_x) %>% as_tibble() %>% 
    rename(airplane = V1, car = V2)

car_airplane_df <- car_airplane_prob %>% 
    mutate(img_no = row_number()) %>% 
    mutate(pred = car_airplane_pred,
           actual = train_y) %>% 
    mutate(error = ifelse(pred == actual, 'good', 'bad')) %>% 
    arrange(error)

## 3.5. 딥러닝 결과 보고서 작성

DT::datatable(car_airplane_df)

error_img_v <- car_airplane_df %>% filter(error == "bad") %>% 
    pull(img_no)

error_img_lst <- list()

for(i in seq_along(error_img_v)) {
    error_img_lst[[i]] <- imgs_lst %>% pluck(error_img_v[i])
}

error_imgs <- combine(error_img_lst)

tile(error_imgs, length(error_img_lst)) %>% 
    display()

