# WEEK2


## 과제1 : VPC, EC2 리소스 배포

- 리소스의 유형과 리소스의 이름이 차이를 알고, 리소스의 속성(예. ID)를 참조하는 방법에 대해서 익숙해지자

### EC2
- Curl 접속 확인

<img src="https://user-images.githubusercontent.com/44595181/198847699-6dfb4e61-444e-4dcd-ade8-9d5c66966a07.png" width="600"/>

### Route Table
<img src="https://user-images.githubusercontent.com/44595181/198847546-48522f47-3c86-410b-a1c4-7278d89c183f.png" width="600"/>

## 과제2 : ASG, ALB 리소스 배포

### ASG
- EC2 생성 모니터링

<img src="https://user-images.githubusercontent.com/44595181/198849128-f60de03d-3bc4-48c2-ab40-af0af26bbb62.png" width="300"/><br>

- Curl 접속 확인
  
<img src="https://user-images.githubusercontent.com/44595181/198849130-ab21bb2f-0197-4456-a742-1cf8c07b8987.png" width="600"/><br>

- ASG 그룹 확인

<img src="https://user-images.githubusercontent.com/44595181/198853319-252d85a6-e7c7-4c1c-aff6-1ea18591ea40.png" width="600"/><br>

### ALB
- ALB 정보 확인

<img src="https://user-images.githubusercontent.com/44595181/198853317-5b3c2be5-8e02-4ca3-bfbc-1239e953a1de.png" width="600"/><br>

- ALB DNS주소로 curl 접속 확인 

<img src="https://user-images.githubusercontent.com/44595181/198851542-465e6c84-38de-44dd-b049-7a9ef9b4df5c.png" width="600"/><br>

- Auto Scaling 확인

<img src="https://user-images.githubusercontent.com/44595181/198851545-b300e554-0c23-4611-85d1-6a050d91b15b.png" width="600"/><br>

- EC2 최소 2대 => 3대로 증가 수정
  
<img src="https://user-images.githubusercontent.com/44595181/198851546-8c265f39-b365-4b77-9162-8cbf5774d6e4.png" width="400"/><br>

- Auto Scaling 확인

<img src="https://user-images.githubusercontent.com/44595181/198851547-ef20f683-ea36-464e-8b32-ca3c6b16badb.png" width="600"/>

### SSL Offload(HTTPS → HTTP로 타켓 대상 연결)

<img src="https://user-images.githubusercontent.com/44595181/198851758-8b831ad8-94e2-48aa-a780-bcf451277251.png" width="600"/>