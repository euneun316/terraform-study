# WEEK2

## 과제3 : S3/DynamoDB 백엔드 설정 및 테스트
- 테라폼 상태 관리 : 상태 파일 공유
  
### DynamoDB 테이블 생성 
- 테라폼에서 DynamoDB 잠금을 사용하기 위해 **LockID** 라는 기본 키가 있는 테이블을 생성

<img src="https://user-images.githubusercontent.com/44595181/198854920-4c9825ad-32fb-422e-aa4c-cbe603cc1aa2.png" width="600"/>

---

### dev 환경에 백엔드 적용 TEST

```bash
terraform {
  backend "s3" {
    bucket = "imok-t101study-tfstate"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
  }
}
```

<img src="https://user-images.githubusercontent.com/44595181/198855008-fa264635-d051-442a-8d5f-05d1c3511b0d.png" width="600"/>

- S3 버킷에 파일 확인
  
<img src="https://user-images.githubusercontent.com/44595181/198855068-3775ef0f-b72f-4475-b876-e9de299355d8.png" width="400"/>

- DynamoDB에 LockID 확인

<img src="https://user-images.githubusercontent.com/44595181/198855066-e8ac23c7-3176-41c5-b409-4c42f9ca48b2.png" width="500"/>

---

### EC2 파일 변경 후 TEST

<img src="https://user-images.githubusercontent.com/44595181/198855069-692e9fe2-872e-46fc-abbd-3bb0a16fc765.png" width="400"/>

- S3 버킷에 버전 표시 확인

<img src="https://user-images.githubusercontent.com/44595181/198855127-2b6fe7c3-2a09-4f7f-8774-0e0d511d740b.png" width="800"/>

---

### `terraform.tfstate` 파일 강제 삭제 TEST

- 버저닝된 파일 확인
  
<img src="https://user-images.githubusercontent.com/44595181/198855128-b37b0606-e482-4cfa-8377-f82a3a578f9c.png" width="600"/>

- S3 버킷에 버전 표시 확인

<img src="https://user-images.githubusercontent.com/44595181/198855130-c0e0c7b4-a46c-4c01-be0a-9a7e38f767f0.png" width="800"/>

---

### stg 환경에 백엔드 적용 TEST

```bash
terraform {
  backend "s3" {
    bucket = "imok-t101study-tfstate"
    key    = "stg/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
  }
}
```

- LockID 상태 확인 : 테라폼을 통해 apply 하는 도중에 아래 정보 확인 가능
- LockID : imok-t101study-tfstate/stg/terraform.tfstate
  
<img src="https://user-images.githubusercontent.com/44595181/198855133-ad752bb9-3b4e-4784-8be8-c7baaac8f8a5.png" width="800"/>

- 배포 완료 후 S3 버킷 확인

<img src="https://user-images.githubusercontent.com/44595181/198855135-bed134a8-bab5-40aa-afbb-99fe4c83ec67.png" width="400"/>

- 배포 완료 후 DynamoDB 확인

<img src="https://user-images.githubusercontent.com/44595181/198855137-de3b8e63-649c-4d12-acc7-bb98ae68eb7d.png" width="500"/>