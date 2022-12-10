# for_each 활용해 vpc 생성하기

`count` 매개변수 사용 시 아래와 같은 제약사항이 있습니다.

1. **인라인 블록에 `count` 사용 지원하지 않음**
   - 전체 리소스를 반복할 수는 있지만 리소스 내에서 인라인 블록을 반복할 때, count 사용은 지원하지 않습니다.
2. **수정 시 발생하는 에러**
   - 배열의 중간 항목을 제거하면 모든 항목이 1칸씩 앞으로 당겨집니다.
   - 즉 count 사용 시, 목록 중간 항목을 제거하면 테라폼은 해당 항목 뒤에 있는 모든 리소스를 삭제한 다음 해당 리소스를 처음부터 다시 만듭니다.

리소스의 여러 복사본을 만들 때는 count 대신 for_each 를 사용하는 것이 바람직합니다. </br>
따라서 `for each` 표현식을 사용해 vpc를 생성하는 실습을 진행했습니다.

## for each 표현식
[for_each 공식문서](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

for_each 표현식을 사용하면 `리스트 lists`, `집합 sets`, `맵 maps` 를 사용하여 전체 리소스의 여러 복사본 또는 리소스 내 인라인 블록의 여러 복사본, 모듈의 복사본을 생성 할 수 있습니다.

```bash
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  for_each = <COLLECTION>

  [CONFIG ...]
}
```
- **COLLECTION** 은 루프를 처리할 집합 또는 맵
- **리소스에 for_each 를 사용할 때, 리스트는 지원 안함**

- CONFIG 는 해당 리소스와 관련된 하나 이상의 인수로 구성되는데, CONFIG 내에서 `each.key`또는 `each.value` 를 사용하여 COLLECTION 에서 현재 항목의 키와 값에 접근할 수 있음

## for each 사용 예시

```bash
# public subnet
resource "aws_subnet" "pub_sub" {
  for_each                = var.public_subnet
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.tags}-${each.key}"
  }
}
```

맵에서 값만 반환하는 내장 함수 `values` 사용 가능

```bash
output "pub_sub_ids" {
  value = aws_subnet.pub_sub.*
}

output "dev_pri_sub_ids" {
  value = values(aws_subnet.dev_pri_sub)[*].id
}

```
### terraform outputs

for_each 를 사용한 후에는 하나의 리소스 또는 count 를 사용한 것과 같은 **리소스 배열이 되는 것이 아니라** 리소스 맵 `list into a set` 이 됩니다.

```bash
Outputs:

dev_pri_sub_ids = [
  "subnet-0457a9a5e265772e4",
  "subnet-08b233055afe17048",
]
pub_sub_ids = [
  {
    pub-sub-2a = {
      "availability_zone" = "ap-northeast-2a"
      "availability_zone_id" = "apne2-az1"
      "cidr_block" = "10.60.4.0/24"
      "id" = "subnet-0caaebfec80d80359"
      "tags" = tomap({
        "Name" = "T101-pub-sub-2a"
      })
      "vpc_id" = "vpc-0473c85bd926f6873"
    },
    pub-sub-2c = {
      "availability_zone" = "ap-northeast-2c"
      "availability_zone_id" = "apne2-az3"
      "cidr_block" = "10.60.5.0/24"
      "id" = "subnet-0aaaf57e88b761897"
      "tags" = tomap({
        "Name" = "T101-pub-sub-2c"
      })
      "vpc_id" = "vpc-0473c85bd926f6873"
    },
  }
]

```