# xwMOOC 딥러닝




## 1. 전이 학습(transfer learning)과 학습된 모형(Pretrained Model) [^transfer-learning-pretrained] [^tim-urban-language] [^r-python-keras-tensorflow]

[^transfer-learning-pretrained]: [Transfer learning & The art of using Pre-trained Models in Deep Learning](https://www.analyticsvidhya.com/blog/2017/06/transfer-learning-the-art-of-fine-tuning-a-pre-trained-model/)

[^tim-urban-language]: [Neuralink and the Brain’s Magical Future](https://waitbutwhy.com/2017/04/neuralink.html)

[^r-python-keras-tensorflow]: [Keras on tensorflow in R & Python](https://www.slideshare.net/LonghowLam/keras-on-tensorflow-in-r-python)

어떻게 학습(learning)을 전이(transfer)시킬 수 있을까? 오래전부터 인류가 고민해온 숙제다.
언어가 존재하지 않던 시절에는 지식의 축적이 매우 한정될 수 밖에 없었다. 하지만, 언어를 사용함에 따라
한 세대가 학습할 수 있는 지식의 양이 비약적으로 늘어나게 되었다.

<img src="fig/tim-urban-language.png" alt="팀 어번 언어" width="77%" />

컴퓨터의 발전과 함께 기존에 개발된 코드를 재사용할 수 있게 진화한 것도 유사한 맥락이다.
기존 서브루틴(subroutine)에서 객체(object), 컴포넌트(component), 플랫폼(platform)으로 진화하여 
훨씬 다양한 작업을 많이 수행할 수 있게 되었다.

이와 함께 딥러닝을 통해 학습시킨 모형은 GPU를 많이 사용했기 때문에 CPU 대비 상대적으로 소중한 자원인 
GPU를 활용하여 개발된 학습모형은 현재 어떻게 보면 소중한 자원이라고 할 수 있다.

## 2. 이미지넷(ImageNet) 딥러닝 모형 

R 케라스 팩키지에 5개 사전학습된 딥러닝 모형이 제공되고 있다.
이를 활용하려면 사전훈련된 딥러닝 모형에 맞게 이미지를 전처리해서 준비한다.
그리고 나서 각 사전훈련된 딥러닝 모형에 넣어주면 예측 결과를 뿜어낸다.

각 사전훈련된 딥러닝 모형에 대해 성능을 파악하고 추후 이를 각자 갖고 있는 문제에 맞춰 적절히 활용한다.

<img src="fig/keras_pretrained_model.png" alt="케라스 사전학습된 모형" width="77%" />

### 2.1. 환경설정 및 데이터 가져오기

[`elephant.jpg` 이미지](https://cran.r-project.org/web/packages/kerasR/vignettes/introduction.html)를 가져온다. 
어떤 이미지인지 확인해보자. 그리고 데이터의 차원정보가 중요하니 `dim` 함수로 살펴본다.


~~~{.r}
# 0. 환경설치 -------------------------------------
# library(keras)
# library(tidyverse)
# library(ggplot2)
# library(jpeg)

# options(scipen = 999)

# 1. 데이터 불러오기 -------------------------------------
img <- readJPEG("data/elephant.jpg")
plot(0:1, 0:1, type="n", ann=FALSE, axes=FALSE)
rasterImage(img, 0,0,1,1)
~~~

<img src="fig/imagenet-transfer-learning-setup-1.png" style="display: block; margin: auto;" />

~~~{.r}
dim(img)
~~~



~~~{.output}
[1] 639 969   3

~~~

### 2.2. 전이학습(transfer learning)

파이썬 Pillow 객체를 전이학습을 통한 딥러닝에 사용한다. 
`image_load` 함수가 그 역할을 수행하고 `imagenet_preprocess_input`에 넣기 전에 전처리 작업을 수한다.
그리고 나서 사전 학습된 딥러닝 모형 `application_vgg19` 모형에 넣어 `elephant.jpg` 파일에 담긴 
객체를 식별한다. `imagenet_decode_predictions` 함수를 실행시키면 
`elephant.jpg` 파일에 담긴 객체에 대한 라벨을 붙여 상위 10개를 반환한다.


~~~{.r}
# 2. 사전 훈련된 신경망 모형 -------------------------------------
## 2.1. 이미지 데이터 준비 ---------------------------------------
img2keras <- image_load("data/elephant.jpg", target_size = c(224, 224))
img2array <- image_to_array(img2keras)

dim(img2array) <- c(1, dim(img2array))
img2array <- imagenet_preprocess_input(img2array)

## 2.2. 사전 훈련된 모형 적합 ------------------------------------
model_vgg19 <- application_vgg19(weights="imagenet")
model_vgg16 <- application_vgg16(weights="imagenet")
model_resnet50 <- application_resnet50(weights="imagenet")

pred_vgg19 <- model_vgg19 %>% predict(img2array)
pred_vgg16 <- model_vgg16 %>% predict(img2array)
pred_resnet50 <- model_resnet50 %>% predict(img2array)


## 2.3. 모형 평가 ------------------------------------------------
vgg19_df <- imagenet_decode_predictions(pred_vgg19, top = 10)[[1]]
vgg16_df <- imagenet_decode_predictions(pred_vgg16, top = 10)[[1]]
resnet50_df <- imagenet_decode_predictions(pred_resnet50, top = 10)[[1]]

vgg19_df <- vgg19_df %>% mutate(pre_model = "vgg19") %>% 
    select(pre_model_vgg19 = pre_model, class_vgg19 = class_description, score_vgg19=score)

vgg16_df <- vgg16_df %>% mutate(pre_model = "vgg16") %>% 
    select(pre_model_vgg16 = pre_model, class_vgg16=class_description, score_vgg16=score)

resnet50_df <- resnet50_df %>% mutate(pre_model = "resnet50") %>% 
    select(pre_model_resnet50=pre_model, class_resnet50 = class_description, score_resnet50=score)

pretrain_df <- bind_cols(vgg19_df, vgg16_df, resnet50_df)

DT::datatable(pretrain_df)
~~~

<!--html_preserve--><div id="htmlwidget-d23692d02519411cf303" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-d23692d02519411cf303">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10"],["vgg19","vgg19","vgg19","vgg19","vgg19","vgg19","vgg19","vgg19","vgg19","vgg19"],["Indian_elephant","tusker","African_elephant","Arabian_camel","triceratops","warthog","lion","Komodo_dragon","water_buffalo","hippopotamus"],[0.389254182577133,0.364613264799118,0.246002480387688,0.0001198433819809,5.98906126469956e-006,1.96317864720186e-006,1.0881332173085e-006,3.95982823420127e-007,2.13460111808672e-007,1.56458170863516e-007],["vgg16","vgg16","vgg16","vgg16","vgg16","vgg16","vgg16","vgg16","vgg16","vgg16"],["tusker","African_elephant","Indian_elephant","warthog","triceratops","Arabian_camel","Komodo_dragon","lion","ram","bighorn"],[0.6380974650383,0.191901743412018,0.169553399085999,0.000138765579322353,9.23363986657932e-005,8.67744529386982e-005,2.63651072600624e-005,2.02037081180606e-005,1.58142738655442e-005,9.81449466053164e-006],["resnet50","resnet50","resnet50","resnet50","resnet50","resnet50","resnet50","resnet50","resnet50","resnet50"],["West_Highland_white_terrier","toilet_tissue","sea_urchin","zebra","sorrel","guinea_pig","beaver","marmot","fox_squirrel","porcupine"],[1,0,0,0,0,0,0,0,0,0]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>pre_model_vgg19<\/th>\n      <th>class_vgg19<\/th>\n      <th>score_vgg19<\/th>\n      <th>pre_model_vgg16<\/th>\n      <th>class_vgg16<\/th>\n      <th>score_vgg16<\/th>\n      <th>pre_model_resnet50<\/th>\n      <th>class_resnet50<\/th>\n      <th>score_resnet50<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"crosstalkOptions":{"key":null,"group":null},"columnDefs":[{"className":"dt-right","targets":[3,6,9]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false},"selection":{"mode":"multiple","selected":null,"target":"row"}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
