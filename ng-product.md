# xwMOOC 딥러닝
`r Sys.Date()`  







## 초모수 미세조정(Hyperparameter tuning)

## 정규화(Regularization)

## 최적화(Optimization)


## 목표설정

### 단일 평가 측도 설정 {#single-number-evaluation-metric}

#### 최적화 및 희생을 고려한 측도 {#satisfing-optimizing-metric}

기계학습 성능평가 측도를 하나만 갖는 것은 때때로 불가능하다. 
이런 경우 기계학습 성능을 제약조건 아래에서 최적화해야 하는 경우도 있다.


| 분류기(Classifier) |  정확도(Accuracy)  | 실행시간(Running Time) |
|:------------------:|:------------------:|:----------------------:|
|         A          |         90 %       |          80 ms         |
|         B          |         92 %       |          95 ms         |
|         C          |         95 %       |       1,500 ms         |

선형계획법(Linear Programming)으로 문제에 접근하면 다음과 같다.

- Maximize: Accuracy
- Subject to running time < 100 ms

즉, N개 측도 중에서 최적화 1개를 최적화하고 N-1개 측도를 희생하는 것으로 생각할 수도 있고,
최적화 1개 측도가 고정되어 있다면 N-1개 측도 손실을 최소화하는 것으로 볼 수도 있다.

#### 훈련-개발-검증 데이터셋 {#train-dev-test-dataset}

확률 통계를 전공했다면 익숙한 개념일 수 있지만, 컴퓨터공학 전공자들에게는 생소한 개념일 수도 있다.
훈련-개발-검증 데이터셋은 동일한 분포에서 나와야만 의미가 있다. 
사실 훈련-개발-검증 데이터셋을 R이나 파이썬 코드로 나눠서 학습을 시키고 검증을 할 경우 
컴퓨터는 묵묵히 주어진 작업만 성실히 수행한다. 
따라서, 인공지능 알고리즘을 개발하는 개발자가 통계, 확률적인 개념을 갖추고 알고리즘 개발을 수행해야만 유의미한 결과를 쉽고 
빠르게 도출할 수 있따.

- 잘못된 사례: 서로 다른 분포에서 표집함.
    - UK, US, Other Europe, South America &rarr; 훈련/개발(train/dev) 관측점
    - India, China, Other Asia, Australia &rarr; 검증(test) 관측점
- 실제 잘못된 사례: 분포가 다른 대출 알고리즘 개발하여 실패한 사례
    - 중간 소득이 거주하는 우편번호 기준 훈련/개발(train/dev) 관측점을 바탕으로 예측모형 개발
    - 저소득 거주하는 우편번호 기준 검증(test) 관측점을 적용하여 검증시도

### 사람수준 성능을 내는 신경망 {#human-level-performance}

기계학습 알고리즘이 사람수준 성능을 넘어서 현실에 폭넓게 적용된 사례는 다음과 같다.

- 온라인 광고
- 제품 추천
- 물류: 주행시간 예측 
- 금융대출

즉, 정형화된 관계형 데이터베이스를 기반으로 데이터가 상당히 많은 분야가 우선 사람능력을 넘어섰고,
사람의 인지가 우세했던 음성인식, 이미지 인식 등 분야에서도 상당한 진보를 목도하고 있다.

지도학습(Supervised Learning)의 두가지 기본 가정을 [편향-분산 트레이드오프(Bias-Variance Tradeoff)](https://ko.wikipedia.org/wiki/%ED%8E%B8%ED%96%A5-%EB%B6%84%EC%82%B0_%ED%8A%B8%EB%A0%88%EC%9D%B4%EB%93%9C%EC%98%A4%ED%94%84)로 설명하면 다음과 같다. 

- 지도학습의 두가지 근본 가정
    - 훈련데이터를 정말 잘 학습 &rarr; 회피가능한 편이(Avoidable Bias)
    - 훈련데이터로 학습된 성능은 개발/검증(dev/test) 데이터에도 일반화를 무리없이 수행 &rarr; 분산(Variance) 

지도학습을 통한 인공지능 알고리즘을 개발할 경우 시간이 지나면서 정확도는 상승하게 된다.
특히, 최근 신경망 알고리즘을 통한 성능이 인간을 넘어서는 경우도 심심치 않게 발견할 수 있다.
지도학습의 경우 $X \Rightarrow Y$ 로 보게 되면 음성정보($X$)가 들어가면 이를 받아쓰기한 글자(Y)가 되던가,
고양이 사진($X$)이 들어가면 고양이 사진 판별여부("0/1" 혹은 "Yes/No")로 분류되어 정확도를 따질 수 있다.

시간이 지나면서 지도학습 알고리즘 성능이 비약적으로 증가하여 사람수준 성능에 근접하는 것이 하나의 전환점이 되지만,
그후 상당한 노력과 자원을 투여해도 좀처럼 급격한 성능향상을 기대하는 것은 쉽지 않고 
인공지능 알고리즘의 상한으로 **베이즈 최적 오차(Bayes Optimal Error)**가 존재한다.



~~~{.r}
x <- seq(1:1000)
y <- log(x)

df <- data.frame(x=x, y=y)

ggplot(df, aes(x, y)) +
  geom_line(size=1.5) +
  geom_hline(yintercept=6.0, linetype="dashed", color="red") +
  geom_hline(yintercept=7.0, linetype="dashed", color="orange") +
  annotate("text", label = "인간수준", x=0.5, y=5.7, color="black") +
  annotate("text", label = "베이즈 오차(Bayes Error)", x=90.5, y=6.7, color="black") + 
  theme_bw(base_family="NanumGothic") +
  labs(x="시간", y="정확도", title="사람수준 성능과 비교",
       subtitle="베이즈 최적 오차(Bayes Optimal Error) vs. 사람수준 성능(Human-Level Performance)") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())
~~~

<img src="fig/human-level-performance-1.png" style="display: block; margin: auto;" />

지도학습 기계학습 알고리즘 성능이 기대에 못미치는 경우 다음 세가지 조치를 취할 수 있다.

- 사람으로부터 더 많은 학습데이터(labeled data) 수집
- 수작업으로 오차분석(error analysis)을 통해 깨달음 통찰(insight)을 얻음
- 편향-분산 트레이드오프 추가 분석

<img src="fig/human-level-performance.png" alt="사람수준 기계학습 알고리즘 개발" width="57%" />

#### 고양이 분류기 사례

고양이 분류기 알고리즘을 개발할 때 데이터인 고양이 사진에 잡음이 많거나 저해상도 
핸드폰 카메라로 사진을 찍을 경우 사람이 봐도 분류가 잘 안되는 경우가 많다. 
그런 경우 사람오차도 크게 되고 따라서 베이즈 오차도 크게 나게 된다.
사람오차와 훈련데이터 오차가 큰경우가 훈련오차와 개발(dev)오차가 크게 되는 경우 
주안점을 둬서 추진할 사항이 달라지게 된다.

|         구분      |    사례 1    |    사례 2    |
|:-----------------:|:------------:|:------------:|
| 사람(베이즈)오차  |     1 %      |     7.5 %    |
|  훈련 오차        |     8 %      |     8 %      |
|개발(dev) 오차     |     10 %     |     10 %     |
|    대책           | 편향오차 축소|  분산 축소   |


#### 베이즈 오차에 대한 대용측도로서 사람오차 

베이즈 오차에 대한 대용측도로 사람측도를 정의하는 사례를 살펴본다.
의료영상 이미지를 바탕으로 질병을 분류하는 사례를 예를 들면,
보통 사람이 분류하면 약 3% 오분류를 하게 되고, 보통 의사는 1%,
경험많은 숙련의는 0.7%, 숙련의로 구성된 팀의 경우 0.5% 오분류를 낸다고 가정하면 
베이즈 최적오차는 어떤 값으로 설정하는 것이 맞는가?

|      구분      |     오차율     |
|:--------------:|:--------------:|
|    보통 사람   |      3 %       | 
|    보통 의사   |      1 %       | 
|    숙련의      |      0.7 %     | 
|  숙련의 팀     |      0.5 %     | 


