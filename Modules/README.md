# Terraform default module

프로젝트를 terraform 코드로 관리하고, 코드를 여러 환경에서 재사용하기 위해 module을 사용했습니다.

## Terraform Workspace

**작업 공간을 통한 Workspaces 격리**

- 테라폼은 기본 `default` 작업 공간을 사용합니다. 새 작업 공간을 만들거나 전환하려면 `terraform workspace` 명령을 사용합니다.
- 작업 공간은 code refactoring을 시도하는 것 같이, 이미 배포된 인프라에 영향을 주지 않고 테라폼 모듈을 테스트할 때 유용합니다.

### workspace 구조

`terraform.tfstate.d` 라는 폴더 아래에 workspace 별로 폴더가 생성되고, 각각 상태 파일인 `.tfstate` 파일이 관리되는 형태입니다.

```
# workspace 구조 예시

├── terraform.tfstate.d
│   ├── imok
│   │   ├── terraform.tfstate
│   │   └── terraform.tfstate.backup
│   └── project
│       ├── terraform.tfstate
│       └── terraform.tfstate.backup

```

### workspace 사용

1. 새 workspace 생성

   `terraform workspace new [workspace name]`

2. workspace 전환

   `terraform workspace select [workspace name]`

3. workspace 리스트 확인

   `terraform workspace list`

4. 현재 workspace 확인

   `terraform workspace show`

### aws credentials 사용

terraform 프로젝트를 두 개 이상의 어카운트에서 사용해야 할 경우, `aws credential`의 `profile` 이름을 workspace 이름과 일치시키는 방법을 사용합니다.

- `~/.aws/credentials` 파일 예

```python
[imok]
aws_access_key_id = []
aws_secret_access_key = []
[workspace name]
aws_access_key_id = []
aws_secret_access_key = []
...
```
---
## Terraform Module

[Terraform Module 공식문서](https://developer.hashicorp.com/terraform/tutorials/modules/module-use)

[Terraform VPC Module Example](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.14.0)

<img src="https://user-images.githubusercontent.com/44595181/208887717-bbfd178e-1ef8-4c7f-a24e-ff1f300a263c.png"/>


