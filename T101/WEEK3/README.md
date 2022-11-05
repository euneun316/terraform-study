# WEEK3


## 작업 공간을 통한 격리 Workspaces

- Terraform Workspace(=작업 공간) 을 통해 테라폼 상태를 **별도의 이름을 가진 여러 개의 작업 공간에 저장**할 수 있다.
- 테라폼은 기본 **‘default’** 작업 공간을 사용한다. 새 작업 공간을 만들거나 전환하려면 terraform workspace 명령을 사용한다.
- 작업 공간은 코드 리팩터링(code refactoring) 을 시도하는 것 같이 **이미 배포되어 있는 인프라에 영향을 주지 않고 테라폼 모듈을 테스트** 할 때 유용하다.

### 백엔드 리소스 생성 : tfstate-backend/backend.tf

```bash
# workspace 정보 확인
$terraform workspace show
default

# 새 작업 공간 workspace 생성 : imokwork1
$terraform workspace new imokwork1

# workspace list
$terraform workspace list
  default
  imokwork1
* imokwork2

# 작업 공간 전환
$terraform workspace select imokwork1
Switched to workspace "imokwork1".
```

- S3 버킷 모니터링
  - "env: 폴더" 아래 각 작업 공간이름의 아래 tfstate 파일이 존재
  
<img src="https://user-images.githubusercontent.com/44595181/200135379-8bae0025-4a2e-4a36-9bb0-b20a544dd333.png" width="700"/>

- EC2 모니터링
  
<img src="https://user-images.githubusercontent.com/44595181/200135424-44debc3d-1260-4cb4-bee6-5835a130ce9e.png" width="360"/>


## 파일 레이아웃을 이용한 격리 file layout


`최상위 폴더`

- **stage** : 테스트 환경과 같은 사전 프로덕션 워크로드 workload 환경
- **prod** : 사용자용 맵 같은 프로덕션 워크로드 환경
- **mgmt** : 베스천 호스트 Bastion Host, 젠킨스 Jenkins 와 같은 데브옵스 도구 환경
- **global** : S3, IAM과 같이 모든 환경에서 사용되는 리소스를 배치

`각 환경별 구성 요소`

- **vpc** : 해당 환경을 위한 네트워크 토폴로지
- **services** : 해당 환경에서 서비스되는 애플리케이션, 각 앱은 자체 폴더에 위치하여 다른 앱과 분리
- **data-storage** : 해당 환경 별 데이터 저장소. 각 데이터 저장소 역시 자체 폴더에 위치하여 다른 데이터 저장소와 분리

`명명 규칙 naming conventions` (예시)

- **variables.tf** : 입력 변수
- **outputs.tf** : 출력 변수
- **main-xxx.tf** : 리소스 → 개별 테라폼 파일 규모가 커지면 특정 기능을 기준으로 **별도 파일**로 분리 (ex. main-iam.tf, main-s3.tf 등) 혹은 **모듈** 단위로 나눔
- **dependencies.tf** : 데이터 소스
- **providers.tf** : 공급자

### 백엔드 리소스 생성 : /global/s3/main.tf
### RDS 생성 : /stage/data-stores/mysql/main.tf

```bash
├── global
│   └── s3
│       ├── main.tf
│       └──outputs.tf
├── stage
│   ├── data-stores
│   │   └── mysql
│   │       ├── main-vpgsg.tf
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   └── services
│       └── webserver-cluster
│           ├── main.tf
│           └── user-data.sh
```
  
- 리소스에 전달해야 되는 매개변수 중 패드워드 처럼 민감정보는 코드에 직접 평문 입력을 하는 대신 전달 할 수 있는 방안

```json
variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}
```

- s3 에 tfstate 에서 시크릿 정보 확인
  - 상태 파일에 시크릿정보가 다 노출되어 있음을 확인 -> 암호화의 필요성
  
<img src="https://user-images.githubusercontent.com/44595181/200136645-e0e69c26-1f7c-4ee6-a7c1-49e70d04e2ec.png" width="800"/>


### 웹서버 클러스터 생성 : stage/services/webserver-cluster/main.tf

- **templatefile** 함수
  - **templatefile** 함수는 PATH 에서 파일을 읽고 그 내용을 문자열로 반환
  - stage/services/webserver-cluster/user-data.sh 파일을 넣고 문자열로 내용을 읽을 수 있음

- 배포 및 접속 확인 
  
<img src="https://user-images.githubusercontent.com/44595181/200138950-2bb1ac00-a1ed-4327-b848-35387f28ca27.png" width="700"/>


### M1 Error 해결 😤
- m1에서 arm64 다윈 커널용 바이너리가 없어서 terraform init 에 실패
  
<img src="https://user-images.githubusercontent.com/44595181/200137304-6655b69b-7270-4031-98dd-3cc57a01d06f.png" width="800"/>

</br>

```bash
# terraform-provider-template download
$git clone https://github.com/hashicorp/terraform-provider-template

# go download
$brew install go

# go version 확인
$go version
go version go1.19.3 darwin/arm64

# go build 
$go build
$mkdir -p  ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64
$mv terraform-provider-template ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64/terraform-provider-template_v2.2.0_x5
$chmod +x ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64/terraform-provider-template_v2.2.0_x5

```

<img src="https://user-images.githubusercontent.com/44595181/200138776-b4e60fd3-ed3f-429a-9bba-bc006df6448d.png" width="800"/>