# Default Terraform module 구조

1. **root module** : 실제로 수행하게 되는 작업 디렉터리의 terraform 코드 모음
	- `root.tf`
2. **child module** : root module에서 리소스를 생성하기 위해 참조하고 있는 module block
	- `EC2`, `VPC`, `IAM`, `SG`

```
.
├── ec2
│   ├── ami.tf
│   ├── key-pair.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── user_data
│   │   ├── user_data_private.sh
│   │   └── user_data_public.sh
│   └── variables.tf
├── iam
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── sg
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├──vpc
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── terraform.tfstate.d # workspace
│   └── imok
│       ├── terraform.tfstate
│       └── terraform.tfstate.backup
├── terraform.tfvars
├── outputs.tf
├── provider.tf
├── root.tf # root module
└── variables.tf
```

## 구축 예상 아키텍처 ✅

<img src="https://user-images.githubusercontent.com/44595181/206907028-81f39f8c-ab2e-40d2-ab9c-ec31c9172c97.png"/>
