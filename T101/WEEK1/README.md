# WEEK1


## 테라폼 가시화 툴 pluralith 를 통해서 EC2 웹 서버 배포


[![Pluralith GitHub Badge](https://user-images.githubusercontent.com/25454503/158065018-55796de7-60a8-4c91-8aa4-3f53cd3c253f.svg)](https://www.pluralith.com)

### pluralith CLI
```bash
# Initialize Pluralith in the current working directory
pluralith init --api-key $PLURALITH_API_KEY --project-id $PLURALITH_PROJECT_ID

# Run Pluralith in CI, generate a diagram and post it as a pull request comment.
pluralith run plan
pluralith run apply
pluralith run destroy
```

### Diagram Generated

→ **`Click the image to view this run in the Pluralith Dashboard`**

![Pluralith Diagram](https://firebasestorage.googleapis.com/v0/b/pluralith.appspot.com/o/project_245055626%2Frun_7848783%2Frun_7848783_1666470387711.png?alt=media&token=014a97da-7964-41be-8612-6fbb7213a502)

### Changes

| **Created** | **Updated** | **Destroyed** | **Recreated** | **Drifted** | **Unchanged** |
|-------------|-------------|-------------|---------------|---------------|---------------|
| 🟢 **`+ 8`** | 🟠 **`~ 0`** | 🔴 **`- 0`**   | 🔵 **`@ 0`**   | 🟣 **`# 0`**   | ⚪ **`# 0`**   |

---

## AWS VPC(Subnet, IGW 등)을 코드로 배포한 환경에서 EC2 웹 서버 배포 


<img src="https://user-images.githubusercontent.com/44595181/197362749-f31b060e-35d4-4d38-b7ab-c673679c1fed.png" width="450" height="450"/>