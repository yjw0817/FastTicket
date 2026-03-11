# Windows 단일 서버에서 Nginx + 다중 Tomcat 로드밸런싱 구성 가이드

## 1. 목적

현재 개발 중인 Java 전자정부 프레임워크 프로젝트(FastTicket)를  
**단일 Windows 서버**에서 다음 구조로 분산 실행한다.

- Nginx: `80`
- Tomcat instance1: `8083`
- Tomcat instance2: `8082`

사용자는 아래 주소로만 접속한다.

- `http://localhost/FastTicket/`

Nginx가 뒤에서 두 개의 Tomcat 인스턴스로 요청을 분산한다.

---

## 2. 최종 구조

```text
브라우저
  ↓
Nginx :80
  ↓
  ├─ Tomcat instance1 :8083  (/FastTicket)
  └─ Tomcat instance2 :8082  (/FastTicket)
```

---

## 3. 현재 기준 환경

### 공통 Tomcat 본체
- `C:\apache-tomcat-9.0.115`

### JDK
- `C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot`

### CATALINA_BASE 인스턴스 폴더
- `C:\tomcat-bases\instance1`
- `C:\tomcat-bases\instance2`

### Nginx
- `C:\nginx`

---

## 4. Tomcat 다중 인스턴스 구성 개념

Tomcat은 다음 두 개념으로 분리해서 사용한다.

### CATALINA_HOME
Tomcat 공통 본체 경로

- `C:\apache-tomcat-9.0.115`

여기에는 공통 실행 파일과 라이브러리가 있다.

예:
- `bin`
- `lib`

### CATALINA_BASE
각 인스턴스별 실행 공간

- `C:\tomcat-bases\instance1`
- `C:\tomcat-bases\instance2`

여기에는 인스턴스별 설정과 로그와 배포 파일이 있다.

예:
- `conf`
- `logs`
- `temp`
- `webapps`
- `work`
- `lib`
- `bin`

---

## 5. 인스턴스 폴더 생성

다음 폴더를 생성한다.

### instance1
- `C:\tomcat-bases\instance1\bin`
- `C:\tomcat-bases\instance1\conf`
- `C:\tomcat-bases\instance1\logs`
- `C:\tomcat-bases\instance1\temp`
- `C:\tomcat-bases\instance1\webapps`
- `C:\tomcat-bases\instance1\work`
- `C:\tomcat-bases\instance1\lib`

### instance2
- `C:\tomcat-bases\instance2\bin`
- `C:\tomcat-bases\instance2\conf`
- `C:\tomcat-bases\instance2\logs`
- `C:\tomcat-bases\instance2\temp`
- `C:\tomcat-bases\instance2\webapps`
- `C:\tomcat-bases\instance2\work`
- `C:\tomcat-bases\instance2\lib`

### conf 복사
원본 Tomcat의 `conf` 내용을 각 인스턴스의 `conf`로 복사한다.

원본:
- `C:\apache-tomcat-9.0.115\conf\*`

복사 대상:
- `C:\tomcat-bases\instance1\conf\`
- `C:\tomcat-bases\instance2\conf\`

---

## 6. server.xml 포트 설정

각 인스턴스의 `conf\server.xml`에서 포트를 서로 다르게 설정해야 한다.

### instance1
파일:
- `C:\tomcat-bases\instance1\conf\server.xml`

예시 기준:

```xml
<Server port="8007" shutdown="SHUTDOWN">
```

HTTP Connector:

```xml
<Connector port="8083" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```

AJP를 사용할 경우 예시:

```xml
<Connector protocol="AJP/1.3"
           address="::1"
           port="8011"
           redirectPort="8443" />
```

### instance2
파일:
- `C:\tomcat-bases\instance2\conf\server.xml`

예시 기준:

```xml
<Server port="8006" shutdown="SHUTDOWN">
```

HTTP Connector:

```xml
<Connector port="8082" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```

AJP를 사용할 경우 예시:

```xml
<Connector protocol="AJP/1.3"
           address="::1"
           port="8010"
           redirectPort="8443" />
```

---

## 7. 실행용 배치 파일

`C:\tomcat-bases` 아래에 실행용 배치 파일을 만든다.

### startup-instance1.bat

```bat
@echo off
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot"
set "CATALINA_HOME=C:\apache-tomcat-9.0.115"
set "CATALINA_BASE=C:\tomcat-bases\instance1"

call "%CATALINA_HOME%\bin\startup.bat"
```

### shutdown-instance1.bat

```bat
@echo off
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot"
set "CATALINA_HOME=C:\apache-tomcat-9.0.115"
set "CATALINA_BASE=C:\tomcat-bases\instance1"

call "%CATALINA_HOME%\bin\shutdown.bat"
```

### startup-instance2.bat

```bat
@echo off
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot"
set "CATALINA_HOME=C:\apache-tomcat-9.0.115"
set "CATALINA_BASE=C:\tomcat-bases\instance2"

call "%CATALINA_HOME%\bin\startup.bat"
```

### shutdown-instance2.bat

```bat
@echo off
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot"
set "CATALINA_HOME=C:\apache-tomcat-9.0.115"
set "CATALINA_BASE=C:\tomcat-bases\instance2"

call "%CATALINA_HOME%\bin\shutdown.bat"
```

---

## 8. PowerShell에서 배치 파일 실행 방법

PowerShell에서는 현재 폴더의 배치 파일을 실행할 때 `.\`를 붙여야 한다.

예:

```powershell
cd C:\tomcat-bases
.\startup-instance1.bat
.\startup-instance2.bat
```

종료:

```powershell
cd C:\tomcat-bases
.\shutdown-instance1.bat
.\shutdown-instance2.bat
```

---

## 9. 포트 충돌 확인 방법

Tomcat 실행 시 `Address already in use: bind` 오류가 나오면  
이미 해당 포트를 다른 프로세스가 사용 중이라는 뜻이다.

확인 명령:

```powershell
netstat -ano | findstr :8082
netstat -ano | findstr :8083
netstat -ano | findstr :8006
netstat -ano | findstr :8007
```

PID 확인 후 어떤 프로세스인지 확인:

```powershell
tasklist /fi "pid eq 23604"
```

강제 종료:

```powershell
taskkill /PID 23604 /F
```

---

## 10. 프로젝트 WAR 배포

현재 프로젝트명은 `FastTicket`이다.

### instance1 배포
- `C:\tomcat-bases\instance1\webapps\FastTicket.war`

### instance2 배포
- `C:\tomcat-bases\instance2\webapps\FastTicket.war`

Eclipse에서 WAR Export 경로를 위처럼 지정한다.

예:
- 프로젝트 우클릭
- `Export`
- `Web`
- `WAR file`

배포 후 Tomcat이 자동으로 풀면 아래 폴더가 생성된다.

- `C:\tomcat-bases\instance1\webapps\FastTicket`
- `C:\tomcat-bases\instance2\webapps\FastTicket`

---

## 11. 개별 Tomcat 접속 확인

### instance1
- `http://localhost:8083/FastTicket`

### instance2
- `http://localhost:8082/FastTicket`

두 주소가 각각 정상적으로 떠야 한다.

---

## 12. Nginx 설치

Windows용 Nginx zip을 내려받아 아래 경로로 둔다.

- `C:\nginx`

최종적으로 아래 파일이 있어야 한다.

- `C:\nginx\nginx.exe`
- `C:\nginx\conf\nginx.conf`

---

## 13. nginx.conf 설정

파일:
- `C:\nginx\conf\nginx.conf`

아래 내용으로 설정한다.

```nginx
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    upstream fastticket_backend {
        server 127.0.0.1:8082;
        server 127.0.0.1:8083;
    }

    server {
        listen       80;
        server_name  localhost;

        location /FastTicket/ {
            proxy_pass http://fastticket_backend/FastTicket/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

---

## 14. Nginx 실행/검사/재적용/종료

### 실행

```powershell
cd C:\nginx
.\nginx.exe
```

### 설정 문법 검사

```powershell
cd C:\nginx
.\nginx.exe -t
```

### 설정 재적용

```powershell
cd C:\nginx
.\nginx.exe -s reload
```

### 종료

```powershell
cd C:\nginx
.\nginx.exe -s stop
```

---

## 15. 최종 접속 주소

사용자는 아래 주소로 접속한다.

- `http://localhost/FastTicket/`

Nginx가 뒤에서 `8082`, `8083`으로 요청을 분산한다.

---

## 16. 확인 완료된 상태

현재 확인 완료된 항목:

- `instance1` 정상 실행
- `instance2` 정상 실행
- `http://localhost:8083/FastTicket` 정상
- `http://localhost:8082/FastTicket` 정상
- `http://localhost/FastTicket/` 정상
- Nginx를 통한 프록시/로드밸런싱 연결 정상

---

## 17. 주의사항

### 1) 세션 문제
로그인 세션을 서버 메모리에만 저장하면  
요청이 8082와 8083 사이에서 바뀔 때 세션 문제가 생길 수 있다.

향후 검토 필요:
- sticky session
- session clustering
- Redis 등 외부 세션 저장소

### 2) 단일 서버 한계
현재 구조는 **단일 서버 내 다중 Tomcat + Nginx** 구조다.

즉:
- 프로세스 분산은 가능
- 배포 분리는 가능
- 일부 장애 우회는 가능

하지만:
- 서버 자체가 죽으면 전체 서비스 중단

즉 이것은 **진짜 서버 이중화**는 아니다.

### 3) Eclipse 개발 배포와 운영 배포 분리
현재는 개발 단계이므로 Eclipse에서 WAR를 export해서 배포했다.

실운영 시에는:
- CI/CD
- 배포 스크립트
- 서비스 등록
- 로그 로테이션
- 모니터링

등을 추가로 정리하는 것이 좋다.

---

## 18. 추천 다음 작업

1. 한쪽 Tomcat을 내려도 Nginx 경유 서비스가 계속 되는지 확인
2. 세션 유지 방식 검토
3. 정적 리소스 및 쿠키 동작 확인
4. 서비스 시작/중지 자동화
5. Windows 서비스 등록 여부 검토
6. 운영 배포 절차 문서화

---

## 19. 빠른 점검 명령 모음

### instance1 시작/종료
```powershell
cd C:\tomcat-bases
.\startup-instance1.bat
.\shutdown-instance1.bat
```

### instance2 시작/종료
```powershell
cd C:\tomcat-bases
.\startup-instance2.bat
.\shutdown-instance2.bat
```

### Nginx 시작/검사/재적용/종료
```powershell
cd C:\nginx
.\nginx.exe
.\nginx.exe -t
.\nginx.exe -s reload
.\nginx.exe -s stop
```

### 포트 점검
```powershell
netstat -ano | findstr :80
netstat -ano | findstr :8082
netstat -ano | findstr :8083
netstat -ano | findstr :8006
netstat -ano | findstr :8007
```

---

## 20. 현재 로그인 세션 구조와 로드밸런싱 이슈

현재 FastTicket의 로그인 세션 구조는 다음과 같다.

### 현재 로그인 세션 방식

| 항목 | 내용 |
|---|---|
| 방식 | Tomcat HttpSession (서버 메모리) |
| 세션 키 | `loginVO` (`MemberVO` 객체, 비밀번호는 null 처리) |
| 타임아웃 | 480분 (8시간) |
| 인증 체크 | `LoginInterceptor.preHandle()` 에서 모든 `*.do` 요청 검사 |
| 제외 URL | `/login.do`, `/logout.do` |
| 로그인 | `POST /login.do` → BCrypt 비교 → 세션 저장 → `/venueList.do` 리다이렉트 |
| 로그아웃 | `GET /logout.do` → `session.invalidate()` → `/login.do` 리다이렉트 |

### 세션에 저장되는 정보

`loginVO (MemberVO)` 예시:
- `memberId`
- `memberNm`
- `tel` (복호화된 평문)
- `telLast4`
- `email`
- `useYn`
- `password = null`

### 구조적 특징

- Spring Security 미사용
- 순수 인터셉터 기반 인증
- CSRF 방어 없음
- 로그인 시 세션 재생성 없음
- Remember-me 없음

---

## 21. 왜 로드밸런서 뒤에서 로그인 유지가 안 되는가

현재 세션은 **Tomcat HttpSession = 각 Tomcat 프로세스의 로컬 메모리**에 저장된다.

즉:

- 로그인 요청이 `instance2 (8082)` 로 가면
  - `instance2` 메모리에만 `loginVO` 저장
- 다음 요청이 `instance1 (8083)` 로 가면
  - `instance1`은 그 세션을 모름
- 결과적으로 인터셉터에서 인증 실패로 판단할 수 있다

즉 현재 구조에서의 핵심 문제는 다음과 같다.

> 로드밸런서는 자유롭게 요청을 분산하지만,  
> 세션은 각 Tomcat 로컬 메모리에 따로 존재하므로  
> 다중 Tomcat 환경에서 로그인 상태가 유지되지 않는다.

이 문제는 Nginx 자체의 문제가 아니라,  
**세션 저장 구조가 단일 Tomcat 전제**로 되어 있기 때문에 발생한다.

---

## 22. 현재 단계에서의 판단 기준

현재는 개발 환경이므로, 바로 Redis까지 붙이기 부담이 있을 수 있다.  
이 경우 접근 순서는 아래가 맞다.

### 1) 먼저 지금 구조가 왜 깨지는지 이해
- 현재 로그인은 Tomcat 로컬 메모리 세션 기반
- 따라서 다중 Tomcat + 자유 분산 시 로그인 유지가 깨질 수 있음

### 2) 그 다음 세션 공유 방식 결정
선택지는 대표적으로 다음 3가지가 있다.

- Redis
- DB
- Tomcat 클러스터 세션 복제

즉 지금 단계에서는:

1. **현재 구조 이해**
2. **세션 공유 방식 결정**
3. **운영 구조에 맞게 적용**

이 순서로 가는 것이 맞다.

---

## 23. 세션 공유 방식 선택지

### A. Sticky Session
Nginx가 같은 사용자를 가능하면 같은 Tomcat으로 계속 보내는 방식

#### 장점
- 가장 빠르게 적용 가능
- 애플리케이션 수정 거의 없음
- 개발/원인 확인용으로 유용

#### 단점
- 진짜 자유로운 분산 아님
- 특정 서버 의존도가 높아짐
- 서버 장애 시 세션 유실 가능
- 장기적인 정답은 아님

> 참고: sticky session은 **원인 확인용 / 임시 운영 대응용**으로는 유효하지만,  
> “로드밸런서가 자유롭게 분산해야 한다”는 목표와는 다소 다르다.

### B. Redis 기반 세션 공유
Redis 같은 외부 저장소에 세션을 저장하는 방식

#### 장점
- 어느 Tomcat이 요청을 받아도 같은 세션 조회 가능
- 로드밸런서가 자유롭게 분산 가능
- 운영 구조상 가장 일반적이고 깔끔함
- 확장성이 좋음

#### 단점
- Redis 인프라 필요
- 애플리케이션 변경 필요
- 초기 설정 학습 필요

#### 권장도
가장 권장되는 방향

### C. DB 기반 세션 공유
DB 테이블에 세션을 저장하는 방식

#### 장점
- 이미 DB 인프라가 있는 경우 추가 진입장벽이 낮을 수 있음
- 중앙 저장 구조 가능

#### 단점
- 성능 부담 가능
- 세션 액세스가 잦으면 DB 부하 증가
- Redis보다 일반적으로 비효율적일 수 있음

#### 권장도
특수 상황에서는 가능하지만, 일반적으로 Redis보다 우선순위는 낮음

### D. Tomcat 클러스터 세션 복제
Tomcat끼리 세션을 복제하는 방식

#### 장점
- 기존 HttpSession 구조를 크게 유지할 수 있음
- 외부 세션 저장소 없이도 구성 가능

#### 단점
- 설정이 복잡함
- 운영 난이도 높음
- 노드 수 증가 시 관리 부담
- 요즘은 Redis 같은 외부 저장소 방식이 더 선호되는 편

#### 권장도
가능은 하지만, 장기 운영 기준으로는 우선 추천하지 않음

---

## 24. 현재 프로젝트에 대한 현실적인 권장 방향

현재 FastTicket 구조 기준 권장 방향은 다음과 같다.

### 단기
- 현재 구조가 왜 깨지는지 팀 내에서 명확히 이해
- 개발 검증용으로 sticky session 사용 가능

### 중기
- 세션 공유 방식 결정
- 우선순위 추천: **Redis > DB > Tomcat 세션 복제**

### 장기
- Redis 기반 세션 구조로 전환
- 로그인 성공 시 세션 재생성 추가
- 세션 저장 객체 최소화
- 필요 시 Spring Security 또는 Spring Session 검토

---

## 25. 보안/구조 개선 메모

현재 구조에서 향후 개선 권장 사항:

### 1) 로그인 성공 시 세션 재생성
현재는 로그인 시 세션 고정 공격 방어가 없다.  
로그인 성공 후 기존 세션을 무효화하고 새 세션을 생성하는 방식 검토 필요.

### 2) 세션 저장 정보 최소화
현재 `loginVO` 안에 전화번호 평문(`tel`)이 포함된다.  
세션에는 꼭 필요한 최소한의 사용자 정보만 저장하는 것이 바람직하다.

### 3) 인터셉터 기반 인증 구조 점검
현재는 `LoginInterceptor.preHandle()` 이 모든 `*.do` 요청의 인증을 담당한다.  
세션 저장 구조를 바꾸면 인터셉터 동작도 함께 점검해야 한다.

---

## 26. 한 줄 결론

현재 FastTicket의 로그인 구조는 **단일 Tomcat에는 적합하지만**,  
**Nginx 뒤 다중 Tomcat 로드밸런싱에서 자유로운 분산을 하기에는 세션 구조상 한계가 있다.**

따라서 현재는:

1. **왜 깨지는지 이해하고**
2. **세션 공유 방식을 결정한 뒤**
3. **Redis/DB/Tomcat 세션 복제 중 적절한 방식을 적용**

하는 순서로 진행하는 것이 맞다.
