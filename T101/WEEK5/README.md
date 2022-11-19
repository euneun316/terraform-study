# WEEK5


# 반복문 Loops
테라폼이 제공하는 반복문 구성

- `count` 매개변수 parameter : 리소스와 모듈의 반복

- `for_each` 표현식 expressions : 리소스 내에서 리소스 및 인라인 블록, 모듈을 반복

- `for` 표현식 expressions : 리스트 lists 와 맵 maps 을 반복

- `for 문자열 지시어` string directive : 문자열 내에서 리스트 lists 와 맵 maps 을 반복

---

## count 매개 변수

[count 공식문서](https://developer.hashicorp.com/terraform/language/meta-arguments/count)

### count.index 사용
`count.index` 를 사용하여 반복문 안에 있는 각각의 반복 `iteration` 을 가리키는 인덱스를 얻을 수 있음

```bash
# main.tf
resource "aws_iam_user" "myiam" {
count = 3
name  = "imok.${count.index+1}"
}
```

- `terraform state list` 확인
```bash
aws_iam_user.myiam[0]
aws_iam_user.myiam[1]
aws_iam_user.myiam[2]
```

<img src="https://user-images.githubusercontent.com/44595181/202712893-fb38a3a6-c9c8-47c4-92c8-d846c248d98d.png" width="900"/>

### 배열 조회 구문과 length 함수 사용

**배열 조회 구문** Array lookup syntax : ARRAY[`<INDEX>`]
- 테라폼에서 count 와 함께 배열 조회 구문과 length 함수를 사용해서 사용자들 생성 가능
- 리소스에 count 사용한 후에는 하나의 리소스가 아니라 **리소스의 배열**이 됨

```bash
# main.tf
resource "aws_iam_user" "myiam" {
count = length(var.user_names)
name  = var.user_names[count.index]
}
```

- `terraform apply` 결과
```bash
aws_iam_user.myiam[1]: Creating...
aws_iam_user.myiam[2]: Creating...
aws_iam_user.myiam[0]: Creating...
aws_iam_user.myiam[2]: Creation complete after 2s [id=imok3]
aws_iam_user.myiam[1]: Creation complete after 2s [id=imok2]
aws_iam_user.myiam[0]: Creation complete after 2s [id=imok1]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

all_arns = [
"arn:aws:iam::[Account ID]:user/imok1",
"arn:aws:iam::[Account ID]:user/imok2",
"arn:aws:iam::[Account ID]:user/imok3",
]
first_arn = "arn:aws:iam::[Account ID]:user/imok1"
```

### count 제약 사항

1. 전체 리소스를 반복할 수는 있지만 리소스 내에서 인라인 블록을 반복할 수는 없음. 인라인 블록 내에서는 count 사용은 지원하지 않음
   
2. 수정 시 발생하는 에러
   
- 중간에 있는 imok2 user를 제거하고 plan & apply

```bash
default = ["imok1", "imok2", "imok3"]

```

 - `terraform plan` 결과
    
```bash
~ update in-place
- destroy

Terraform will perform the following actions:

# aws_iam_user.myiam[1] will be updated in-place
~ resource "aws_iam_user" "myiam" {
        id            = "imok2"
    ~ name          = "imok2" -> "imok3"
        tags          = {}
        # (5 unchanged attributes hidden)
    }

# aws_iam_user.myiam[2] will be destroyed
# (because index [2] is out of range for count)
- resource "aws_iam_user" "myiam" {
    - arn           = "arn:aws:iam::[Account ID]:user/imok3" -> null
    - force_destroy = false -> null
    - id            = "imok3" -> null
    - name          = "imok3" -> null
    - path          = "/" -> null
    - tags          = {} -> null
    - tags_all      = {} -> null
    - unique_id     = "fgdgdfgdfgd" -> null
    }

Plan: 0 to add, 1 to change, 1 to destroy.

Changes to Outputs:
~ all_arns = [
        # (1 unchanged element hidden)
        "arn:aws:iam::[Account ID]:user/imok2",
    - "arn:aws:iam::[Account ID]:user/imok3",
    ]
```
  - 배열의 중간에 항목을 제거하면 모든 항목이 1칸씩 앞으로 당겨짐.
  - 테라폼이 인덱스 번호를 리소스 식별자로 보기 때문에 ‘인덱스 1에서는 계정 생성, 인덱스2에서는 계정 삭제한다’라고 해석함
  - 즉 count 사용 시 목록 중간 항목을 제거하면 테라폼은 해당 항목 뒤에 있는 모든 리소스를 삭제한 다음 해당 리소스를 처음부터 다시 만듬.
  - 따라서 위 예시에서 **imok2 user를 삭제했지만, imok3 user가 삭제되는 에러 발생**

<img src="https://user-images.githubusercontent.com/44595181/202724133-c1f14dfc-4e82-47d0-97b3-47f96e81cd61.png" width="900"/>

---

## for each 표현식
[for_each 공식문서](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

for_each 표현식을 사용하면 `리스트 lists`, `집합 sets`, `맵 maps` 를 사용하여 전체 리소스의 여러 복사본 또는 리소스 내 인라인 블록의 여러 복사본, 모듈의 복사본을 생성 할 수 있음

```bash
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  for_each = <COLLECTION>

  [CONFIG ...]
}
```
- **COLLECTION** 은 루프를 처리할 집합 sets 또는 맵 maps
- **리소스에 for_each 를 사용할 때 리스트는 지원 안함**

- CONFIG 는 해당 리소스와 관련된 하나 이상의 인수로 구성되는데 CONFIG 내에서 `each.key`또는 `each.value` 를 사용하여 COLLECTION 에서 현재 항목의 키와 값에 접근할 수 있음

### for_each 예제
for_each 를 사용하여 3명의 IAM 사용자를 생성

`var.user_names` 리스트를 집합(set)으로 변환하기 위해 toset 사용. 

```bash
# main.tf
resource "aws_iam_user" "myiam" {
  for_each = toset(var.user_names)
  name     = each.value
}
```

for_each 를 사용한 후에는 하나의 리소스 또는 count 를 사용한 것과 같은 리소스 배열이 되는 것이 아니리 **리소스 맵** `list into a set` 이 됩니다.

- `terraform state list` 확인
  
```bash
aws_iam_user.myiam["imok1"]
aws_iam_user.myiam["imok2"]
aws_iam_user.myiam["imok3"]
```

- `terraform apply` 확인

```bash
aws_iam_user.myiam["imok2"]: Creating...
aws_iam_user.myiam["imok3"]: Creating...
aws_iam_user.myiam["imok1"]: Creating...
aws_iam_user.myiam["imok3"]: Creation complete after 2s [id=imok3]
aws_iam_user.myiam["imok2"]: Creation complete after 2s [id=imok2]
aws_iam_user.myiam["imok1"]: Creation complete after 2s [id=imok1]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

all_users = [
  "arn:aws:iam::[Account ID]:user/imok1",
  "arn:aws:iam::[Account ID]:user/imok2",
  "arn:aws:iam::[Account ID]:user/imok3",
]
```

### 리소스 중간 값 제거 테스트
for_each 를 사용해 **리소스를 맵으로 처리**하면 컬렉션 중간의 항목도 안전하게 제거할 수 있어서, count 로 리소스를 배열 처리보다 이점이 큽니다.

중간에 있는 imok2 user를 제거하고 plan & apply

- `terraform plan` 결과
  
  이제 주변 모든 리소스를 옮기지 않고 정확히 목표한 리소스만 삭제가 됩니다.

```bash
  - destroy

Terraform will perform the following actions:

  # aws_iam_user.myiam["imok2"] will be destroyed
  # (because key ["imok2"] is not in for_each map)
  - resource "aws_iam_user" "myiam" {
      - arn           = "arn:aws:iam::[Account ID]:user/imok2" -> null
      - force_destroy = false -> null
      - id            = "imok2" -> null
      - name          = "imok2" -> null
      - path          = "/" -> null
      - tags          = {} -> null
      - tags_all      = {} -> null
      - unique_id     = "dsdsdsdsdsd" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  ~ all_users = [
        "arn:aws:iam::[Account ID]:user/imok1",
      - "arn:aws:iam::[Account ID]:user/imok2",
        "arn:aws:iam::[Account ID]:user/imok3",
    ]
```

---

## for 표현식
[for Expressions 공식문서](https://developer.hashicorp.com/terraform/language/expressions/for)

단일 값을 생성하기 위해 반복이 필요한 경우 사용


### for Expressions - list 예제

조건을 지정해서 결과 리스트를 필터링할 수 있음 </br>
list를 사용한 for 표현식 : `[for <ITEM> in <LIST> : <OUTPUT>]`

- LIST : 반복할 리스트
- ITEM : LIST의 각 항목에 할당할 변수의 이름
- OUTPUT : ITEM을 어떤 식으로든 변환하는 표현식

```bash
# main.tf
variable "names" {
  description = "A list of names"
  type        = list(string)
  default     = ["imok22", "imok1", "imok333"]
}

output "upper_names" {
  value = [for name in var.names : upper(name)]
}

output "short_upper_names" {
  value = [for name in var.names : upper(name) if length(name) < 6]
}
```

- `terraform output` 결과

```bash
short_upper_names = [
  "IMOK1",
]
upper_names = [
  "IMOK22",
  "IMOK1",
  "IMOK333",
]
```

### for Expressions - map 예제

map을 사용한 for 표현식 : `[for <KEY>, <VALUE> in <MAP> : <OUTPUT>]`
- MAP : 반복되는 맵
- KEY, VALUE : MAP의 각 키-값 쌍에 할당할 로컬 변수의 이름
- OUTPUT : KEY와 VALUE를 어떤 식으로든 변환하는 표현식입니다.

```bash
#main.tf
variable "names" {
  description = "A list of names"
  type        = list(string)
  default     = ["imok1", "imok22", "imok333"]
}

output "upper_names" {
  value = [for name in var.names : upper(name)]
}

output "short_upper_names" {
  value = [for name in var.names : upper(name) if length(name) < 5]
}

variable "hero_thousand_faces" {
  description = "map"
  type        = map(string)
  default = {
    imok1   = "hero"
    imok22  = "love interest"
    imok333 = "mentor"
  }
}

output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}
```


- `terraform output` 결과
```bash
bios = [
  "imok1 is the hero",
  "imok22 is the love interest",
  "imok333 is the mentor",
]
short_upper_names = []
upper_names = [
  "IMOK1",
  "IMOK22",
  "IMOK333",
]
```

### for Expressions - 출력 예제
for 표현식을 리스트가 아닌 맵을 출력하는 데 사용할 수도 있음

- 리스트를 반복하고 맵을 출력 Loop over a list and output a map </br>
`{for <ITEM> in <LIST> : <OUTPUT_KEY> => <OUTPUT_VALUE>}`

- 맵을 반복하고 리스트를 출력 Loop over a map and output a map </br>
`{for <KEY>, <VALUE> in <MAP> : <OUTPUT_KEY> => <OUTPUT_VALUE>}`


```bash
#main.tf
variable "names" {
  description = "A list of names"
  type        = list(string)
  default     = ["imok1", "imok22", "imok333"]
}

output "upper_names" {
  value = [for name in var.names : upper(name)]
}

output "short_upper_names" {
  value = [for name in var.names : upper(name) if length(name) < 6]
}

variable "hero_thousand_faces" {
  description = "map"
  type        = map(string)
  default = {
    imok1   = "hero"
    imok22    = "love interest"
    imok333 = "mentor"
  }
}

output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}

output "upper_roles" {
  value = { for name, role in var.hero_thousand_faces : upper(name) => upper(role) }
}

```

- `terraform output` 결과
```bash
bios = [
  "imok1 is the hero",
  "imok22 is the love interest",
  "imok333 is the mentor",
]
short_upper_names = [
  "IMOK1",
]
upper_names = [
  "IMOK1",
  "IMOK22",
  "IMOK333",
]
upper_roles = {
  "IMOK1" = "HERO"
  "IMOK22" = "LOVE INTEREST"
  "IMOK333" = "MENTOR"
}
```

---

## 문자열 지시자(String Derective)

문자열 지시자를 사용하면 문자열 보간과 유사한 구문으로 문자열 내에서 for 반복문, if문 같은 제어문을 사용할 수 있음</br>
- 문자열 보간법 : `"Hello, ${var.name}"`

- 달러 부호와 중괄호 `${..}` 대신 백분율 부호 `%{..}` 를 사용한다는 차이가 있음 

</br>

for 문자열 지시자 : `%{ for <ITEM> in <COLLECTION> }<BODY>%{ endfor }`

- COLLECTION : 반복할 리스트 또는 맵
- ITEM : COLLECTION 의 각 항목에 할당할 로컬 변수의 이름
- BODY : ITEM을 참조할 수 있는 각각의 반복을 렌더링하는 대상

### String Derective 예제

```bash
variable "names" {
  description = "Names to render"
  type        = list(string)
  default     = ["imok1", "imok22", "imok33"]
}

output "for_directive" {
  value = "%{ for name in var.names }${name}, %{ endfor }"
}
```

- `terraform output` 결과

```bash
for_directive = "imok1, imok22, imok33, "
```

- index 추가

```bash
variable "names" {
  description = "Names to render"
  type        = list(string)
  default     = ["imok1", "imok22", "imok33"]
}

output "for_directive" {
  value = "%{ for name in var.names }${name}, %{ endfor }"
}

output "for_directive_index" {
  value = "%{ for i, name in var.names }(${i}) ${name}, %{ endfor }"
}

```

- `terraform output` 결과

```bash
for_directive = "imok1, imok22, imok33, "
for_directive_index = "(0) imok1, (1) imok22, (2) imok33, "
```