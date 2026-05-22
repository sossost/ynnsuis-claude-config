---
description: "앱 릴리즈 브랜치 생성, 버전 범프, 릴리즈 노트 PR, 태그 + GitHub Release 자동 생성"
---

# Release Command

앱 릴리즈 프로세스를 자동화합니다.

## What This Command Does

1. **버전 확인** - 현재 버전과 범프할 버전 결정
2. **버전 범프 대상 파일 전수 체크** - 누락 없이 모든 파일 업데이트 확인
3. **릴리즈 브랜치 생성** - `release/x.y.z` 형식
4. **단일 커밋** - `chore(release): vX.Y.Z`
5. **릴리즈 노트 자동 생성** - 이전 태그 이후 변경사항 수집
6. **PR 생성** - 릴리즈 노트를 포함한 PR
7. **머지 후 태그 + GitHub Release** - `vX.Y.Z` 태그 생성, 푸시, GitHub Release 페이지 생성

## When to Use

`/yc:release` 또는 `/yc:release 1.0.12` 형식으로 사용:
- 새 버전을 배포할 때
- 버전 범프가 필요할 때

## 버전 범프 대상 파일 (필수 전수 체크)

| 파일 | 필드 |
|------|------|
| `package.json` | `version` |
| `app.json` | `expo.version`, `expo.runtimeVersion` |
| `android/app/build.gradle` | `versionCode`, `versionName` |
| `ios/app/Info.plist` | `CFBundleShortVersionString` |
| `ios/app/Supporting/Expo.plist` | `EXUpdatesRuntimeVersion` |

**CRITICAL**: 모든 파일의 버전이 일치하는지 반드시 확인. 하나라도 누락하면 빌드/OTA 불일치 발생.

`versionCode` (Android)는 정수이며 매 릴리즈마다 증가해야 함. 버전 문자열과 별도로 관리.

## 릴리즈 브랜치 규칙

- 브랜치명: `release/x.y.z`
- main에서 분기
- 커밋 메시지: `chore(release): vX.Y.Z` (단일 커밋)
- 여러 커밋이 생기면 스쿼시

## PR 형식

### 제목
```
chore(release): vX.Y.Z
```

### 본문
```markdown
## Release X.Y.Z

### Features
- **기능 제목** (#PR번호) — 간단한 설명

### Bug Fixes
- **버그픽스 제목** (#PR번호) — 간단한 설명

### Refactor
- **리팩토링 제목** (#PR번호) — 간단한 설명

### Chore
- **기타 작업** (#PR번호) — 간단한 설명
```

변경사항은 이전 태그(`git tag -l 'v*' | sort -V | tail -1`)부터 현재 main HEAD까지의 커밋에서 자동 수집.
커밋 타입(`feat`, `fix`, `refactor`, `chore`)별로 분류.

## 실행 플로우

```
1. 현재 버전 확인 (package.json 기준)
2. 범프할 버전 결정 (인자로 받거나 사용자에게 질문)
3. 모든 버전 파일의 현재 상태 확인 — 이미 범프된 파일과 안 된 파일 구분
4. 안 된 파일만 업데이트 (이미 맞는 파일은 건드리지 않음)
5. git checkout -b release/x.y.z
6. git add [변경된 버전 파일들]
7. git commit -m "chore(release): vX.Y.Z"
8. git push -u origin release/x.y.z
9. 이전 태그 이후 커밋 수집 → 릴리즈 노트 생성
10. gh pr create
```

## 머지 후: 태그 + GitHub Release

PR 머지 후 바로 실행:

```
1. git checkout main && git pull origin main
2. git tag vX.Y.Z
3. git push origin vX.Y.Z
4. gh release create vX.Y.Z --title "vX.Y.Z" --notes "[릴리즈 노트]"
```

### GitHub Release 노트 형식

PR 서머리와 동일한 릴리즈 노트를 사용:

```markdown
## Release X.Y.Z

### Features
- **기능 제목** (#PR번호) — 간단한 설명

### Bug Fixes
- **버그픽스 제목** (#PR번호) — 간단한 설명

### Refactor
- **리팩토링 제목** (#PR번호) — 간단한 설명

### Chore
- **기타 작업** (#PR번호) — 간단한 설명
```

## Handoff Message

PR 생성 후:
```
릴리즈 PR 생성 완료: [PR URL]

머지하면 태그 + GitHub Release를 생성합니다.
```

머지 + 태그 + Release 완료 후:
```
릴리즈 완료:
- PR: [PR URL]
- Release: [Release URL]
```

## Related Commands

```
/yc:code-review → /yc:release → 머지 → 태그 + GitHub Release
```
