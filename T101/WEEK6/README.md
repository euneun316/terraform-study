# WEEK6
Managing Secrets with Terraform

# Secret Management Basics
배포 과정에서 민감 정보 (DB암호, API 키, TLS인증서, SSH키, GPG 키 등)를 안전하게 관리가 필요함

민감 정보 관리 규칙 : **민감 정보를 평문으로 저장 하지 말것**

```go
resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = var.db_name

  # DO NOT DO THIS!!!
  username = "admin"
  password = "password"
  # DO NOT DO THIS!!!
}
```
- 버전 관리 시스템에 위 코드가 있을 경우 누구나 해당 데이터베이스를 비밀번호로 접속 할 수 있음. 따라서 비밀번호 관리 도구가 필요함

---

# Secret Management tools

`The types of secrets you store` : 3가지 유형, 유형에 따라 관리 방식의 차이가 있음

- Personal secrets : 개인 소유의 암호, 예) 방문하는 웹 사이트 사용자 이름과 암호, SSH 키
- Customer secrets : 고객 소유의 암호, 예) 사이트를 운영하는데 고객의 사용자 이름과 암호, 고객의 개인정보 등 → 해싱 알고리즘 사용
- Infrastructure secrets : 인프라 관련 암호, 예) DB암호, API 키 등 → 암복호화 알고리즘 사용

`The way you store secrets` : 2가지 암호 저장 방식 - 파일 기반 암호 저장 vs 중앙 집중식 암호 저장

- File-based secret stores : 민감 정보를 암호화 후 저장 → 암호화 관련 키 관리가 중요 ⇒ 해결책 : AWS KMS, GCP KMS 혹은 PGP Key
- Centralized secret stores : 일반적으로 데이터베이스(MySQL, Psql, DynamoDB 등)에 비밀번호를 암호화하여 저장, 암호화 키는 서비스 자체 혹은 클라우드 KMS를 사용

`The interface you use to access secrets` : 암호 관리 툴은 API, CLI, UI 통해서 사용할 수 있음

`A comparison of secret management tools` : 툴 비교

|  | Types of secrets | Secret Storage | Secret Interface |
| --- | --- | --- | --- |
| HashiCorp Vault | Infrastructure | Centralized service | UI, API, CLI |
| AWS Secrets Manager | Infrastructure | Centralized service | UI, API, CLI |
| GCP Secrets Manager | Infrastructure | Centralized service | UI, API, CLI |
| Azure Key Vault | Infrastructure | Centralized service | UI, API, CLI |
| Keychain (macOS) | Personal | Files | UI, CLI |
| Credential Manager (Windows) | Personal | Files | UI, CLI |
| Auth0 | Customer | Centralized service | UI, API, CLI |
| AWS Cognito | Customer | Centralized service | UI, API, CLI |

---

# Secret Management tools with Terraform

IAM 자격 증명 정보를 코드의 Provider 에 직접 입력하는 것은 안전하지 않음

```go
provider "aws" {
  region = "us-east-2"

  # DO NOT DO THIS!!!
  access_key = "(ACCESS_KEY)"
  secret_key = "(SECRET_KEY)"
  # DO NOT DO THIS!!!
}
```

1. 사용자 환경 변수 사용
- 환경 변수 사용 시 코드에 암호가 들어가지 않고, 자격 증명이 디스크가 아닌 메모리에만 저장됨
```bash
$  export AWS_ACCESS_KEY_ID=(YOUR_ACCESS_KEY_ID)
$  export AWS_SECRET_ACCESS_KEY=(YOUR_SECRET_ACCESS_KEY)
```

2. aws configure 사용
```bash
$ aws configure
```

3. 내 PC가 아닌 곳에서 임시 보안 자격 증명
- EC2 instance IAM role, Github Action

## EC2 Instance running Jenkins as a CI server, with IAM roles 
EC2에 Jenkins 설치 후 CI서버로 테라폼 코드를 실행한다고 가정

IAM role 는 특정 사용자에 연결되지 않으며, 영구적인 자격증명이 아님. 
Role(EC2FullAccess) Switch 를 통해, EC2를 사용할 수 있음

### IAM role 확인
<img src="https://user-images.githubusercontent.com/44595181/204095321-afb8e61d-a223-4f74-8f77-520dfb7c6783.png" width="700"/>

### ssh 키페어로 EC2 접속 후 IAM role 동작 확인

```bash
$ ssh -i "imok-corp-key.pem" ec2-user@$(terraform output -raw instance_ip)

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
1 package(s) needed for security, out of 1 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-172-31-5-225 ~]$
```

**인스턴스 메타데이터 검색**

[인스턴스 메타데이터 검색](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html) : 실행 중인 모든 인스턴스 메타데이터 범주를 살펴보려면 다음 IPv4 또는 IPv6 URI를 사용합니다.

**IPv4**
```
http://169.254.169.254/latest/meta-data/
```

- 각자 자신의 SSH 키페어로 EC2 접속 후 IAM role 동작 확인
    
```bash
curl -s http://169.254.169.254/latest/meta-data/
curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials ; echo
IAMROLE=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials)
# 임시 보안 자격 증명 IAM role 확인
curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/$IAMROLE

# EC2 관련 명령 실행 확인
export AWS_DEFAULT_REGION=ap-northeast-2
aws ec2 describe-vpcs --output table
aws ec2 describe-instances --query "Reservations[*].Instances[*].{PublicIPAdd:PublicIpAddress,InstanceName:Tags[?Key=='Name']|[0].Value,Status:State.Name}" --filters Name=instance-state-name,Values=running --output tex
---------------------------
```

<img src="https://user-images.githubusercontent.com/44595181/204095543-c77b74d8-40f0-46ad-8ca5-2d32913fa32a.png" width="1100"/>

---

## GitHub Actions as a CI server, with OIDC
Github Actions 은 직접 자격 증명과 OIDC (Open ID Connect) 지원 </br>
- AWS 공식문서 : </br>
[Creating OpenID Connect (OIDC) identity providers](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html) </br>
[Creating a role for web identity or OpenID Connect Federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html)</br>
- GitHub 공식 문서 : </br>
[Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#updating-your-github-actions-workflow)
### OAuth 2.0
<img src="https://user-images.githubusercontent.com/44595181/204097051-98ca361d-7397-4e32-aaba-ee46ffeb73a9.png" width="700"/>

1. **User** : 사용자 -> **Resource Owner**
2. **mine** : 내가 만들 서비스 -> **Client**
3. **Their** : 사용자가 회원 가입해 있는 곳(구글 페이스북 등) -> 
   - **Resource Server** : 데이터를 가진 서버
   - **Authorization Server** : 인증과 관련된 처리를 전담하는 서버 (통상 인증 서버 역할은 R.S 에 통합)

### GitHub Actions

<img src="https://user-images.githubusercontent.com/44595181/204114088-e1a3c091-3697-4f1e-9be4-4675cc18f4cf.png" width="700"/>

- **provider URL** : `https://token.actions.githubusercontent.com`
- **Audience** : `sts.amazonaws.com` if you are using the [official action](https://github.com/aws-actions/configure-aws-credentials)


**[Assume a role in AWS]** </br>

IAM Role의 `trust relationships` 을 terraform 으로 작성
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::123456123456:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:GitHubOrg/GitHubRepo:*"
                },
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
```

**[GitHub Actions]**

1. **github repo 생성 및 clone** </br>
```bash
git clone https://github.com/euneun316/aws-oidc.git
```


2. `.github/workflows/first.yml` 작성 후 push </br>
   
first.yml 파일을 푸시(push)하면 GitHub는 해당 워크플로우를 자동으로 즉시 실행함.

```yml
name: AWS OIDC TEST
 
on: push
 
jobs:
 build:
   name: build
   permissions:
     id-token: write
     contents: write
     
   runs-on: ubuntu-latest
   
   steps:
     - name: Checkout
       uses: actions/checkout@v2
      
     - name: Configure AWS Credentials
       uses: aws-actions/configure-aws-credentials@master
       with:
         aws-region: ap-northeast-2
         role-to-assume: arn:aws:iam::[Account ID]:role/github-iam-role-example
         role-session-name: GithubActionsSession
    
     - name: S3 Bucket List
       run: |
         aws s3 ls

```
  
<img src="https://user-images.githubusercontent.com/44595181/204112819-8c609851-2ce6-4e67-97d5-c81285c988e0.png" width="700"/>

3. **Actions 확인** </br>
   
GitHub의 코드 저장소 화면에서 Actions 탭을 클릭하면 워크플로우의 실행 결과를 바로 확인할 수 있음.

<img src="https://user-images.githubusercontent.com/44595181/204112833-5fff35ed-723a-4e60-aa9e-e688746f6f30.png" width="800"/>