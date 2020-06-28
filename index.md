---
layout: page
title: xwMOOC 딥러닝과 $H_2 O$
---


왜 지금 딥러닝이 각광받고 있는 이유가 뭘까? [^andrew-ng-spark-2016] 이 질문에 [앤드류 응](http://www.andrewng.org/) 박사는 마치 로켓이 강력한 엔진과 더불어 어마어마한 연료를 갖추었기 때문이라고 설명한다. 강력한 엔진이 어떤 데이터도 학습할 수 있는 유연하고 파괴력있는 표현력이 강한 신경망이고, 어마어마한 연료가 빅데이터로 회자되는 풍부한 데이터다. 이를 계산할 수 있는 병렬컴퓨팅 기술이 합쳐져 인공지능 AI 혁명을 모두 지켜보고 있다.

<img src="fig/ear-of-dl.png" width="37%" />

딥러닝을 뒷받침하고 있는 세가지 중요한 기술요소에는 **빅데이터**, **깊은 신경망 모형**, **병렬 컴퓨팅** 이 내포되어 있으며 이것중 하나도 빠지게 되면 오늘과 같은 변화와 혁신을 기대하기는 쉽지 않았을 것이다.

<img src="fig/three-pillars.png" width="57%" />

특히, 데이터 폭증과 병렬컴퓨팅을 통해 강력한 연산 능력을 갖추게 되었지만, 이를 효과적으로 활용할 모형이 마땅치 않았으나 깊은 신경망을 모형을 통해 그동안 홀대 받았던 신경망 모형이 가장 인기있는 모형으로 자리잡게 되었다.

전통 학습 모형은 작은 데이터에서 학습효과가 좋지만, 데이터가 많아져도 이를 반영한 성능은 나오지 않는다. 신경망 모형은 데이터 증가에 맞추어 표현력을 따라서 높이면 성능도 높일 수 있다. 하지만, 그에 따른 어마어마한 컴퓨팅 자원이 소요된다. 최근 클라우드와 더불어 고성능 컴퓨팅 HPC에 GPU를 도입해서 정말 상상도 못한 컴퓨팅 자원을 감당할만한 비용으로 이용가능한 세상이 되었다.

<img src="fig/dl-hpc-evolution.png" width="57%" />



> ### AI is a Superpower {.callout}
>
> "AI is a superpower!!!", 인공지능을 체득하면 슈퍼파워를 손에 쥘 것이다. [Andrew Ng](https://twitter.com/andrewyng/status/728986380638916609)
>
> 금수저, 은수저 슈퍼파워를 받은 사람과 기계학습을 통달한 흑수저들간의 무한경쟁이 드뎌 시작되었다. 물론, 
> 금수저를 입에 물고 기계학습을 통달한 사람이 가장 유리한 출발을 시작한 것도 사실이다.


## 학습목차 [^jeff-dean-spark-2016] [^andrew-ng-spark-2016]

[^jeff-dean-spark-2016]: [Large Scale Deep Learning with TensorFlow](https://www.youtube.com/watch?v=XYwIDn00PAo) 
[^andrew-ng-spark-2016]: [AI-The New Electricity](https://www.youtube.com/watch?v=4eJhcxfYR4I)

1. [딥러닝이 주목받는 이유](why-dl.html)
    - [R 개발자가 알아야 되는 보안](r-security.html)
    - **음성**: [오디오 데이터](speech-data-manip.html)
    - [R 딥러닝 환경설정: `openmp` 맥](dl-mac-openmp.html)
1. **텐서플로우(tensorflow)**
    - [텐서플로우(tensorflow) 설치](r-tensorflow.html)
    - [텐서플로우(tensorflow) 자료구조](tensorflow-data-structure.html)
    - [텐서플로우(tensorflow) 회귀분석](r-tensorflow-regression.html)
1. **[R에서 바라본 딥러닝](r-keras.html)**
    - [이미지 처리 101 - 건축학개론](http://statkclee.github.io/trilobite/cv-architecture-101.html)
    - [전통 R 신경망](r-nnet.html)
    - **전이학습(transfer learning)**
        - [비행기 vs 자동차 - 강아지 vs 고양이](r-keras-cats-and-dogs.html)
        - [비행기 vs 자동차 vs 배 - CNN](r-keras-cnn.html)
    - 케라스(keras)
        - [R 케라스(keras) - 보스톤 주택가격(Boston Housing)](r-keras-boston-housing.html)
        - [R 케라스(keras) - 붓꽃 데이터(iris)](r-keras-iris.html)
        - [R 케라스(keras) - 이미지넷(Imagenet)](r-keras-imagenet.html)
        - [R 케라스(keras) - 패션 MNIST](r-keras-fashion-mnist.html)
        - [R 케라스(keras) - 패션 MNIST (캐글 데이터)](r-keras-fashion-mnist-kaggle.html)
    - [사람 얼굴 인식](r-face-recognition.html)
    - [이미지 객체 분류 시스템 (Object Classification)](r-object-classification.html)
1. [캡챠(captcha) 깨기](r-keras-captcha.html)    
    - [R 케라스(keras) - 필기숫자 인식 데이터(MNIST)](r-keras-mnist.html)
    - [필기숫자 인식 데이터(MNIST): 파이썬 스크립트](r-mnist-python.html)
    - [확장된 필기숫자 인식 데이터(EMNIST): 확장 손글씨](r-emnist-dataset.html)
    - [이미지 주석/라벨(annotation) 달기](r-image-annotation.html)
    - [캡챠 샤이니 뷰어(Captcha Shiny Viewer)](r-captcha-shiny-viewer.html)
    - [캡챠 회전목마(carousel, merry-go-round): `slickR`](r-captcha-carousel.html)
    - [YOLO: 캡챠 깨기](r-captcha-yolo.html)
1. 클라우드 API 활용 딥러닝 앱개발
    - **[마이크로소프트 애저(Azure)](microsoft-azure.html)**
        - [텍스트와 이미지 API](ms-text-image.html)
        - [카드뉴스 (Card News) - 프로토타입](ai-card-news.html)
        - [국회의원 사진 - Computer Vision API](ms-azure-computer-vision.html)
        - [동영상 감정 분석](ms-oxford-video.html): [KBS(2016-12-07),인공지능으로 분석한 대통령의 마음…슬픔은 어디에?](http://news.kbs.co.kr/news/view.do?ncd=3390429&ref=D)
        - [사진속 나이 추정](ms-oxford-age.html)
            - [R을 이용한 인공지능 튜토리얼](ms-oxford-kcode-tutorial.html)
        - **옥스퍼드 시절** 
            - [옥스포드 - 감정 API](ms-oxford-emotion.html)
            - [인지서비스(Cognitive Service) - 텍스트 감성분석](ms-cognitive-text-sentiment.html)
    - **구글**
        - [R 구글 클라우드 비젼 API-RoogleVision](r-google-vision-rooglevision.html)
        - [R 구글 클라우드 비젼 API](r-google-vision-api.html)
        - [구글 클라우드 비젼 - 파이썬](gc-vision.html)            
        - [R 구글 url 축약-googleAuthR](r-short-url.html)
        - [R 구글 애널리틱스(GA)-RGA](r-ga.html)
        - [구글 음성 API](speech-api.html)
    - **IBM**
        - [IBM 왓슨](r-watson.html)
1. [Andrew Ng 딥러닝 코세라 강의](ng-coursera.html)
    - [기계학습과 딥러닝 (Neural Networks and Deep Learning)](ng-intro.html)
    - [Improving Deep Neural Networks: Hyperparameter tuning, Regularization and Optimization](ng-tuning.html)
    - [Structuring Machine Learning Projects](ng-product.html)
    - Convolutional Neural Networks
    - Sequence Models



