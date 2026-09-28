# 실시간 인터랙티브 투표 · 강사용 설치 안내

교육장에서 QR 하나로 참가자 투표를 받는 웹 도구입니다. 로그인·앱 설치 없이 익명으로 참여하고, 결과는 강사 화면에 실시간으로 그려집니다.

- 질문 유형 4가지: 객관식 투표 / 척도 평가 / 워드클라우드 / 자유 의견
- 비용: GitHub Pages(무료) + Supabase Free 플랜(무료)
- 소요 시간: 처음 한 번 20~30분

> 이 저장소는 **서버 값이 비어 있는 상태**입니다. 아래 순서대로 본인 계정에 설치하면 본인만의 투표 도구가 됩니다.

---

## 준비물

| 항목 | 비고 |
|---|---|
| GitHub 계정 | github.com 가입 |
| Supabase 계정 | supabase.com → Start your project → **GitHub 계정으로 가입**하면 빠릅니다 |
| PC 브라우저 | 크롬 권장 |

---

## 1단계. 내 저장소 만들기 (GitHub)

1. 이 저장소 페이지 오른쪽 위 초록색 **Use this template** → **Create a new repository**
2. Repository name: 예) `my-poll`
3. **Public** 선택 (무료 계정에서 GitHub Pages를 쓰려면 공개 저장소여야 합니다)
4. **Create repository**

## 2단계. 데이터 저장소 만들기 (Supabase)

1. Supabase 대시보드 → **New project**
2. Name: 예) `my-poll` / Database Password: 아무 값이나 만들고 따로 적어 둠
3. Region: **Northeast Asia (Seoul)** 선택
4. **Create new project** → 1~2분 기다리기

## 3단계. 표(table) 만들기

1. Supabase 왼쪽 메뉴 **SQL Editor** → **New query**
2. 이 저장소의 `setup.sql` 파일을 열어 내용 전체를 복사 → 붙여넣기
3. 오른쪽 아래 **Run**
4. 결과 칸에 `poll_rooms`, `poll_answers` 두 줄이 보이면 성공

여러 번 실행해도 문제없습니다.

## 4단계. 연결 값 2개 복사하기

Supabase 화면에서 아래 두 값을 메모장에 복사해 둡니다.

| 값 | 생김새 | 위치 |
|---|---|---|
| Project URL | `https://abcdefgh.supabase.co` | 프로젝트 상단 **Connect** 버튼 또는 Project Settings 안의 API/Data API 메뉴 |
| Publishable key | `sb_publishable_...` (또는 `eyJhbGciOi...`로 시작하는 anon key) | **Project Settings → API Keys** |

> ⛔ **service_role / Secret key는 절대 넣지 마세요.** 이 키가 공개 저장소에 올라가면 누구나 데이터베이스 전체를 조작할 수 있습니다.
> Publishable key와 anon key는 브라우저 공개용이라 노출돼도 괜찮습니다.

Supabase 메뉴 이름은 업데이트로 바뀔 수 있습니다. 위치가 다르면 대시보드에서 "API Keys"를 찾아 보세요.

## 5단계. index.html에 값 넣기

1. GitHub 내 저장소에서 `index.html` 클릭 → 오른쪽 위 **연필 아이콘(Edit)**
2. `Ctrl + F`로 `PASTE_YOUR` 검색 → 아래 두 줄이 나옵니다

```js
const CONFIG = {
  SUPABASE_URL: "PASTE_YOUR_PROJECT_URL",
  SUPABASE_ANON_KEY: "PASTE_YOUR_PUBLISHABLE_KEY",
};
```

3. 따옴표는 남기고 안쪽 글자만 4단계에서 복사한 값으로 바꿉니다

```js
const CONFIG = {
  SUPABASE_URL: "https://abcdefgh.supabase.co",
  SUPABASE_ANON_KEY: "sb_publishable_xxxxxxxxxxxx",
};
```

4. 오른쪽 위 **Commit changes** → 한 번 더 **Commit changes**

## 6단계. 웹 주소 만들기 (GitHub Pages)

1. 내 저장소 → **Settings** → 왼쪽 **Pages**
2. Source: **Deploy from a branch**
3. Branch: **main** / 폴더 **/(root)** → **Save**
4. 1~3분 뒤 새로고침하면 상단에 주소가 나타납니다
   `https://내아이디.github.io/저장소이름/`

## 7단계. 리허설

1. PC에서 위 주소 접속 → 질문 목록 화면이 나오면 연결 성공
2. **진행 화면 열기 ▶** → QR 표시
3. 내 휴대폰으로 QR 스캔 → 응답 → PC 화면 막대그래프가 움직이는지 확인
4. 끝나면 **이 질문 응답 초기화**

"아직 서버가 연결되지 않았습니다" 화면이 나오면 5단계 값을 다시 확인합니다. 이 화면에서 값을 넣고 **연결 테스트**를 누르면 어디가 틀렸는지 오류 문구가 나옵니다.

---

## 강의 운영 체크리스트

**강의 2~3일 전**
- Supabase Free 프로젝트는 **1주일 동안 사용이 없으면 자동 일시정지**됩니다. 대시보드에 들어가 상태를 확인하고, 멈춰 있으면 **Resume project**를 누릅니다. 재개에 몇 분 걸릴 수 있으니 당일 아침에 처음 확인하지 마세요.
- 질문 세트를 미리 만들고 **내보내기**로 JSON 파일을 받아 둡니다.

**강의 당일**
- 질문 세트는 **그 PC의 브라우저 안에만** 저장됩니다. 강의장 PC가 다르면 **불러오기**로 JSON 파일을 올립니다.
- 방 코드는 교육마다 **새 코드**를 누르세요. 같은 코드를 다시 쓰면 지난 교육 응답이 섞입니다.
- 전체화면 버튼으로 빔프로젝터에 띄우고, QR 옆 주소도 말로 한 번 안내합니다.

**버튼 정리**

| 버튼 | 기능 |
|---|---|
| 응답 마감 / 열기 | 참가자 입력을 막거나 다시 받음 |
| 결과 가리기 / 보이기 | 응답은 계속 받으면서 화면 결과만 숨김 (먼저 답하고 한꺼번에 공개할 때) |
| 휴대폰에 결과 표시 | 응답을 제출한 참가자 폰에도 결과 그래프 표시 |
| 이 질문 응답 초기화 | 현재 질문 응답 전체 삭제 (되돌릴 수 없음) |

---

## 알아 둘 점

- **개인정보**: 이름·연락처를 수집하지 않습니다. 자유 의견 질문에서 참가자에게 실명·연락처를 적지 말라고 안내하세요.
- **공개 범위**: 방 코드를 아는 사람은 응답을 보고 넣을 수 있습니다. 교육 현장용 도구로 쓰고, 민감한 설문에는 쓰지 마세요.
- **고객사 자료**: 저장소가 공개(Public)라서 여기에 올린 파일은 누구나 볼 수 있습니다. 고객사 이름이 들어간 결과 페이지를 올릴 때는 공개해도 되는지 먼저 확인하세요.
- **Supabase Free 플랜 한도(2026년 9월 기준 공식 페이지)**: 활성 프로젝트 2개, DB 500MB, API 요청 무제한, Realtime 동시 접속 200. 참가자 화면은 2.5초 간격 조회 방식이라 Realtime 연결을 쓰지 않습니다. 요금 정책은 바뀔 수 있으니 supabase.com/pricing 에서 확인하세요.

## 문제 해결

| 증상 | 확인할 것 |
|---|---|
| "relation poll_rooms does not exist" | 3단계 setup.sql 실행 안 됨 |
| "Invalid API key" | 5단계 키 복사 누락·공백 포함 여부 |
| 접속은 되는데 한참 로딩 | Supabase 프로젝트 일시정지 → Resume project |
| 주소가 404 | 6단계 Pages 설정 후 2~3분 대기, 저장소 Public 여부 |
| 강사 화면 결과가 늦게 뜸 | 1.5초 간격 자동 새로고침이 있으니 잠시 대기. 계속 안 되면 3단계 재실행 |
| 휴대폰에서 이미 답했다고 나옴 | 같은 폰·같은 브라우저는 같은 참가자로 봅니다. 객관식·척도는 마지막 응답만 집계 |
