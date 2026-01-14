# ? Android 키 제한 설정 완료

**작성일**: 2026-01-14  
**상태**: Google Cloud Console에서 Android 키 제한 설정 완료

---

## ? Android 앱 정보

### 패키지명
```
com.wickedzerg.mobilegcs
```

### 앱 세부 정보
- **Application ID**: `com.wickedzerg.mobilegcs`
- **Namespace**: `com.wickedzerg.mobilegcs`
- **Version Code**: `1`
- **Version Name**: `1.0.0`
- **Min SDK**: `24` (Android 7.0)
- **Target SDK**: `34` (Android 14)

---

## ? Google Cloud Console 설정

### 설정된 제한 사항

1. **애플리케이션 제한**
   - ? Android 앱 선택
   - ? 패키지명: `com.wickedzerg.mobilegcs`
   - ? SHA-1 인증서 지문: (설정됨)

2. **API 키 제한**
   - ? Generative Language API만 허용

---

## ? SHA-1 인증서 지문 확인 방법

### 디버그 키스토어 (개발용)

```bash
# Windows
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# Linux/Mac
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### 릴리스 키스토어 (프로덕션용)

```bash
keytool -list -v -keystore your-release-key.keystore -alias your-key-alias
```

### 출력 예시
```
Certificate fingerprints:
     SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
     SHA256: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

---

## ? Google Cloud Console 설정 체크리스트

### API 키 제한
- [x] Android 앱 제한 설정
- [x] 패키지명: `com.wickedzerg.mobilegcs`
- [x] SHA-1 인증서 지문 추가
- [x] Generative Language API만 허용

### 추가 보안 설정 (권장)
- [ ] 키 이름 명확하게 설정 (예: `SC2-Bot-Android-Production`)
- [ ] 할당량 제한 설정
- [ ] 사용량 모니터링 활성화

---

## ? 테스트 방법

### 1. Android 앱에서 API 호출 테스트

앱을 실행하고 API 호출이 정상적으로 작동하는지 확인:

```kotlin
// MainActivity.kt 또는 ApiClient.kt에서
val apiKey = BuildConfig.GEMINI_API_KEY
// API 호출 테스트
```

### 2. 키 제한 확인

다른 패키지명으로 앱을 빌드하거나, 다른 SHA-1 지문으로 시도하면 API 호출이 거부되어야 합니다.

---

## ? 설정된 정보 요약

### Google Cloud Console
- **API 키**: `AIzaSyBDdPWJyXs56AxeCPmqZpySFOVPjjSt_CM`
- **애플리케이션 제한**: Android 앱
- **패키지명**: `com.wickedzerg.mobilegcs`
- **SHA-1 지문**: (Google Cloud Console에 설정됨)

### Android 앱
- **패키지명**: `com.wickedzerg.mobilegcs`
- **키 위치**: `local.properties` → `GEMINI_API_KEY`
- **빌드 설정**: `build.gradle.kts`에서 `BuildConfig.GEMINI_API_KEY`로 사용

---

## ? 추가 설정 (필요한 경우)

### 여러 SHA-1 지문 추가

개발용과 프로덕션용 키스토어가 다른 경우, 두 SHA-1 지문을 모두 추가해야 합니다:

1. **디버그 키스토어 SHA-1** (개발/테스트용)
2. **릴리스 키스토어 SHA-1** (프로덕션용)

Google Cloud Console에서 여러 SHA-1 지문을 쉼표로 구분하여 추가할 수 있습니다.

---

## ?? 주의사항

1. **키스토어 보안**
   - 릴리스 키스토어 파일을 안전하게 보관하세요
   - 키스토어 비밀번호를 안전하게 관리하세요

2. **SHA-1 지문 변경**
   - 키스토어를 변경하면 SHA-1 지문도 변경됩니다
   - Google Cloud Console에서 새 SHA-1 지문을 추가해야 합니다

3. **패키지명 변경**
   - 패키지명을 변경하면 Google Cloud Console에서도 업데이트해야 합니다

---

## ? 관련 문서

- **보안 강화 가이드**: `docs/API_KEY_SECURITY_HARDENING.md`
- **키 업데이트**: `docs/API_KEY_UPDATE_FINAL.md`
- **Android 앱 설정**: `monitoring/mobile_app_android/README.md`

---

## ? 완료 상태

- [x] Google Cloud Console에서 Android 키 제한 설정 완료
- [x] 패키지명 확인: `com.wickedzerg.mobilegcs`
- [x] SHA-1 인증서 지문 추가됨
- [x] API 키 제한 설정됨

**→ Android 앱에서 안전하게 API를 사용할 수 있습니다!**

---

**마지막 업데이트**: 2026-01-14
