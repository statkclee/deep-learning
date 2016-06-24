---
layout: page
title: xwMOOC 딥러닝
subtitle: $H_2 O$ GBM 모형 세부조정
---

> ## 학습 목표 {.objectives}
>
> * $H_2 O$ 활용 최적 예측모형을 개발한다.
> * 타이타닉 생존 데이터로 동일한 방법론을 갈음한다.
> * GBM 기본 모형을 바탕으로 모수 세부조정을 통해 성능을 높인다.

### 1. 타이타닉 생존 데이터 GBM 기본 모형구축 [^h2o-gbm-tuning]

[^h2o-gbm-tuning]: [H2O GBM Tuning Tutorial for R](http://blog.h2o.ai/2016/06/h2o-gbm-tuning-tutorial-for-r/)

1. $H_2 O$ 팩키지를 설치하고, $H_2 O$ 클러스터를 생성한다.
1. [타이타닉 생존 데이터](http://s3.amazonaws.com/h2o-public-test-data/smalldata/gbm_test/titanic.csv)를 다운로드 한다.
1. `h2o.splitFrame` 명령어를 통해 훈련, 타당도검증, 검증 데이터로 구분하고 GBM 모형을 적합시킨다.

~~~ {.r}
##=========================================================================
## 01. H2O 설치: http://blog.h2o.ai/2016/06/h2o-gbm-tuning-tutorial-for-r/
##=========================================================================
# 1. 기존 H2O 제거
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# 2. H2O 의존성 설치
pkgs <- c("methods","statmod","stats","graphics","RCurl","jsonlite","tools","utils")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# 3. H2O 설치
install.packages("h2o", repos=(c("http://s3.amazonaws.com/h2o-release/h2o/master/1497/R", getOption("repos"))))

#-------------------------------------------------------------------------
# 01.1. H2O 클러스터 환경설정
#-------------------------------------------------------------------------

library(h2o)
h2o.init(nthreads=-1)

##=========================================================================
## 02. H2O 데이터 가져오기
##=========================================================================

df <- h2o.importFile(path = "http://s3.amazonaws.com/h2o-public-test-data/smalldata/gbm_test/titanic.csv")
summary(df, exact_quantiles=TRUE)

##=========================================================================
## 03. H2O 데이터 정제 과정
##=========================================================================

# 데이터 정제 및 변환과정 생략

##=========================================================================
## 04. GBM 모형
##=========================================================================
# 1. 종속변수 선정
response <- "survived"
# 2. 종속변수가 숫자형이라 요인(Factor)으로 자료형 변환
df[[response]] <- as.factor(df[[response]])           

# 3. 종속변수를 제외한 모든 변수를 설명변수
predictors <- setdiff(names(df), c(response, "name")) 

# 4. 훈련, 타당성검증, 검증 데이터로 분리
splits <- h2o.splitFrame(
  data = df, 
  ratios = c(0.6,0.2),   ## 60% 훈련, 20% 타당도검증, 나머지 20% 자동 검증데이터 생성
  destination_frames = c("train.hex", "valid.hex", "test.hex"), seed = 1234
)
train <- splits[[1]]
valid <- splits[[2]]
test  <- splits[[3]]

#--------------------------------------------------------------------------
# 4.1. GBM 초기 모형
#--------------------------------------------------------------------------
# 1. 기본 모형 생성
gbm <- h2o.gbm(x = predictors, y = response, training_frame = train)
gbm

# 타당성검증 데이터 AUC 성능
h2o.auc(h2o.performance(gbm, newdata = valid)) 

# 2. 타당성 검증 데이터 활용 GBM 모형 개발 
gbm <- h2o.gbm(x = predictors, y = response, training_frame = h2o.rbind(train, valid), nfolds = 4, seed = 0xDECAF)

gbm@model$cross_validation_metrics_summary
h2o.auc(h2o.performance(gbm, xval = TRUE))
~~~


### 2. GBM 모수로 설정한 값이 운좋게 최적일 수 있다.

`h2o.gbm` 모형에 설정한 값이 운좋게도 가장 최적일 수도 있다. 하지만, 그런 경우는 거의 없다.


~~~ {.r}
#--------------------------------------------------------------------------
# 4.2. GBM 정말 운좋은 모형 개발
#--------------------------------------------------------------------------
gbm <- h2o.gbm(
  ## 표준 모형 모수 설정
  x = predictors, 
  y = response, 
  training_frame = train, 
  validation_frame = valid,
  
  ntrees = 10000,                                                            
  
  learn_rate=0.01,                                                         

  stopping_rounds = 5, stopping_tolerance = 1e-4, stopping_metric = "AUC", 

  sample_rate = 0.8,                                                       
  col_sample_rate = 0.8,                                                   

  seed = 1234,                                                             
  score_tree_interval = 10                                                 
)

h2o.auc(h2o.performance(gbm, valid = TRUE))
~~~

### 3. 초모수(Hyper-parameter) 설정을 통한 GBM 최적 모형 개발

최적의 GBM 모형 구축을 위해 초모수를 최적화하는 기계적인 방법은 존재하지 않으며, 
경험에 비추어 다음 모수가 최적 GBM 구축에 도움이 되는 것으로 알려져 있다.

1. `ntrees`: 타당도 검증 오차가 증가할 때까지 가능함 많은 나무모형을 생성시킨다.
1. `learn_rate`: 가능하면 낮은 학습율을 지정한다. 하지만 댓가로 더 많은 나무모형이 필요하다. `learn_rate=0.02`와 `learn_rate_annealing=0.995` 모수로 설정한다.
1. `max_depth`: 나무 깊이는 데이터에 따라 최적 깊이가 달라진다. 더 깊은 나무를 생성시키려면 더 많은 시간이 소요된다. 특히 10보다 큰 경우 깊은 나무모형으로 알려져 있다.
1. `sample_rate`, `col_sample_rate` : 행과 열을 표집추출하는 것으로 보통 0.7 -- 0.8 이 무난하다.
1. `sample_rate_per_class`: 심각한 불균형 데이터(예를 들어, 연체고객과 정상고객, 이상거래와 정상거래 등)의 경우 층화추출법을 통해 모형 정확도를 높일 수 있다.
1. 기타 나머지 모수는 상대적으로 적은 기여도를 보이는데, 필요한 경우 임의 초모수 검색법을 도모할 수 있다.

`max_depth`를 먼저 상정할 수 있고, 데카르트 좌표계(Cartesian Grid) 검색으로 이를 구현한다.


~~~ {.r}
#--------------------------------------------------------------------------
# 4.3. GBM 모수 미세조정
#--------------------------------------------------------------------------
hyper_params = list( max_depth = seq(1,29,2) )
#hyper_params = list( max_depth = c(4,6,8,12,16,20) ) ## 빅데이터의 경우 사용

grid <- h2o.grid(

  hyper_params = hyper_params,
  search_criteria = list(strategy = "Cartesian"),

  algorithm="gbm",
  grid_id="depth_grid",
  
  x = predictors, 
  y = response, 
  training_frame = train, 
  validation_frame = valid,
  

  ntrees = 10000,                                                            
  learn_rate = 0.05,                                                         
  learn_rate_annealing = 0.99,                                               
  
  sample_rate = 0.8,                                                       
  col_sample_rate = 0.8, 
  
  seed = 1234,                                                             
  
  stopping_rounds = 5,
  stopping_tolerance = 1e-4,
  stopping_metric = "AUC", 
  
  score_tree_interval = 10                                                
)

grid                                                                       

sortedGrid <- h2o.getGrid("depth_grid", sort_by="auc", decreasing = TRUE)    
sortedGrid


topDepths = sortedGrid@summary_table$max_depth[1:5]                       
minDepth = min(as.numeric(topDepths))
maxDepth = max(as.numeric(topDepths))
~~~

### 4. GBM 초모수 격자탐색

`hyper_params` 리스트에 격자 탐색할 모수를 설정하고, `search_criteria`에 탐색기준을 적시하고 나서
`h2o.grid`를 통해 최적 GBM 초모수를 탐색한다.

~~~ {.r}
#--------------------------------------------------------------------------
# 4.4. GBM 초모수 격자 탐색
#--------------------------------------------------------------------------

hyper_params = list( 

  max_depth = seq(minDepth,maxDepth,1),                                      
  
  sample_rate = seq(0.2,1,0.01),                                             
  
  col_sample_rate = seq(0.2,1,0.01),                                         
  
  col_sample_rate_per_tree = seq(0.2,1,0.01),                                
  
  col_sample_rate_change_per_level = seq(0.9,1.1,0.01),                      
  
  min_rows = 2^seq(0,log2(nrow(train))-1,1),                                 
  
  nbins = 2^seq(4,10,1),                                                     
  
  nbins_cats = 2^seq(4,12,1),                                                
  
  min_split_improvement = c(0,1e-8,1e-6,1e-4),                               
  
  histogram_type = c("UniformAdaptive","QuantilesGlobal","RoundRobin")       
)

search_criteria = list(
  strategy = "RandomDiscrete",      
  
  max_runtime_secs = 3600,         
  
  max_models = 100,                  
  
  seed = 1234,                        
  
  stopping_rounds = 5,                
  stopping_metric = "AUC",
  stopping_tolerance = 1e-3
)

grid <- h2o.grid(

  hyper_params = hyper_params,
  search_criteria = search_criteria,
  
  algorithm = "gbm",
  
  grid_id = "final_grid", 
  
  x = predictors, 
  y = response, 
  training_frame = train, 
  validation_frame = valid,

  ntrees = 10000,                                                            
  
  learn_rate = 0.05,                                                         
  
  learn_rate_annealing = 0.99,                                               
  
  max_runtime_secs = 3600,                                                 
  
  stopping_rounds = 5, stopping_tolerance = 1e-4, stopping_metric = "AUC", 
  
  score_tree_interval = 10,                                                
  
  seed = 1234                                                             
)

## AUC 기준 격자모형 정렬
sortedGrid <- h2o.getGrid("final_grid", sort_by = "auc", decreasing = TRUE)    
sortedGrid

for (i in 1:5) {
  gbm <- h2o.getModel(sortedGrid@model_ids[[i]])
  print(h2o.auc(h2o.performance(gbm, valid = TRUE)))
}
~~~


### 5. 최종모형 정리

AUC 기준 가장 좋은 모형을 하나 선정하고, 이를 기준으로 검증데이터 혹은 예측이 필요한 데이터에 예측확률을 붙여 저장한다.

~~~ {.r}
##=========================================================================
## 05. 최종 모형 정리
##=========================================================================

gbm <- h2o.getModel(sortedGrid@model_ids[[1]])
print(h2o.auc(h2o.performance(gbm, newdata = test)))

gbm@parameters

model <- do.call(h2o.gbm,
                 ## update parameters in place
                 {
                   p <- gbm@parameters
                   p$model_id = NULL          ## do not overwrite the original grid model
                   p$training_frame = df      ## use the full dataset
                   p$validation_frame = NULL  ## no validation frame
                   p$nfolds = 5               ## cross-validation
                   p
                 }
)
model@model$cross_validation_metrics_summary

for (i in 1:5) {
  gbm <- h2o.getModel(sortedGrid@model_ids[[i]])
  cvgbm <- do.call(h2o.gbm,
                   ## update parameters in place
                   {
                     p <- gbm@parameters
                     p$model_id = NULL          ## do not overwrite the original grid model
                     p$training_frame = df      ## use the full dataset
                     p$validation_frame = NULL  ## no validation frame
                     p$nfolds = 5               ## cross-validation
                     p
                   }
  )
  print(gbm@model_id)
  print(cvgbm@model$cross_validation_metrics_summary[5,]) ## Pick out the "AUC" row
}

gbm <- h2o.getModel(sortedGrid@model_ids[[1]])
preds <- h2o.predict(gbm, test)
head(preds)
gbm@model$validation_metrics@metrics$max_criteria_and_metric_scores


h2o.saveModel(gbm, "~/30-neural-network/bestModel.csv", force=TRUE)
h2o.exportFile(preds, "~/30-neural-network/bestPreds.csv", force=TRUE)
~~~

초모수 미세조정을 통해 최적화된 GBM 모형 하나보다 경우에 따라서는 앙상블 기법을 사용한 방법이 더 좋은 성능을 보여주기도 한다.

~~~ {.r}
#--------------------------------------------------------------------------
# 5.1. 앙상블 기법
#--------------------------------------------------------------------------

prob = NULL
k=10
for (i in 1:k) {
  gbm <- h2o.getModel(sortedGrid@model_ids[[i]])
  if (is.null(prob)) prob = h2o.predict(gbm, test)$p1
  else prob = prob + h2o.predict(gbm, test)$p1
}
prob <- prob/k
head(prob)

probInR  <- as.vector(prob)
labelInR <- as.vector(as.numeric(test[[response]]))
if (! ("cvAUC" %in% rownames(installed.packages()))) { install.packages("cvAUC") }
library(cvAUC)
cvAUC::AUC(probInR, labelInR)
~~~