# Material Master RAP Application

> SAP BTP 환경에서 **RESTful ABAP Programming Model(RAP)** 로 직접 구현한 자재(Material) 마스터 관리 애플리케이션입니다.
> CDS View → Behavior → Service Definition까지 풀스택을 직접 작성하며, OData V4 기반 Fiori Elements UI가 자동 생성되도록 구성했습니다.

ERP 연구회 학습 과정에서 RAP 구조를 이해하기 위해 **자재 마스터 시나리오를 처음부터 직접 설계**했습니다. 단순히 generator로 자동 생성하는 데 그치지 않고, Draft 기능·권한 제어·Determination·필드 매핑 등 RAP의 핵심 요소를 손으로 구현했습니다.

---

## 핵심 요약

| 구성 | 오브젝트 | 역할 |
|------|----------|------|
| Persistence Table | `zmat_minsung` | 실제 자재 데이터 저장 |
| Draft Table | `zmat_mins_d` | 임시 저장(Draft) 데이터 |
| CDS View (Root) | `ZCDS_MAT_MS` | 데이터 모델 + UI Annotation |
| Behavior Definition | `ZCDS_MAT_MS` (managed, draft) | CRUD·Draft·권한·Determination 정의 |
| Behavior Implementation | `zbp_cds_mat_ms` | 권한 핸들러, CreatedAt 자동 계산 |
| Service Definition | `ZUI_MAT_MINSUNG_V4` | OData V4 서비스 노출 |

핵심 키워드: `RAP` · `CDS View` · `Behavior Definition (BDEF)` · `Draft` · `OData V4` · `Fiori Elements` · `ABAP Cloud`

---

## 아키텍처

```
zmat_minsung (DB Table)
      │
ZCDS_MAT_MS (Root View Entity)  ── UI Annotation (@UI.lineItem, @UI.selectionField, @UI.facet ...)
      │
Behavior Definition (managed, with draft)
      │  └─ zbp_cds_mat_ms (Implementation)
      │       ├─ 권한 핸들러 (instance / global authorization)
      │       └─ calculateCreatedAt (Determination on save)
      │
ZUI_MAT_MINSUNG_V4 (Service Definition)
      │
OData V4 Service → Fiori Elements UI (List Report + Object Page)
```

---

## 구현 상세

### 1. CDS View — `ZCDS_MAT_MS`

`zmat_minsung` 테이블을 root view entity로 모델링하고, UI Annotation으로 화면 구성을 백엔드에서 정의했습니다.

- `@UI.lineItem` — List Report의 테이블 컬럼 (Material, Description, MaterialType, Unit, CreatedAt)
- `@UI.selectionField` — 상단 조회 조건 필드 (Material, MaterialType)
- `@UI.identification` / `@UI.facet` — Object Page 상세 화면의 섹션 배치
- `@ObjectModel.usageType` — 성능 최적화 힌트 (serviceQuality, sizeCategory)

필드 별칭(alias)으로 DB 컬럼명을 업무 의미가 드러나는 이름으로 변환했습니다 (`matnr` → `Material`, `maktx` → `Description` 등).

### 2. Behavior Definition — managed, with draft

```
managed implementation in class zbp_cds_mat_ms unique;
strict ( 2 );
with draft;
```

- **Draft 활성화** — 임시 저장 후 Activate/Discard/Resume 가능 (`zmat_mins_d` 테이블 사용)
- **동시성 제어** — `lock master total etag CreatedAt` 로 낙관적 잠금(Optimistic Locking) 구현
- **권한 분리** — `create ( authorization : global )`, instance 권한 마스터
- **읽기 전용 필드** — `Material`(update 시), `CreatedAt`
- **Determination** — 저장 시 `calculateCreatedAt` 자동 실행
- **매핑** — CDS 필드명과 DB 컬럼명 매핑 정의

### 3. Behavior Implementation — `zbp_cds_mat_ms`

- **`get_instance_authorizations`** — Update/Delete 권한 허용 처리
- **`get_global_authorizations`** — Create 권한 요청 시 허용 응답 (실무에서는 `AUTHORITY-CHECK` 사용 지점)
- **`calculateCreatedAt`** — `READ ENTITIES` → `GET TIME STAMP` → `MODIFY ENTITIES` 패턴으로 생성 시각 자동 기록

### 4. Service Definition — `ZUI_MAT_MINSUNG_V4`

```
define service ZUI_MAT_MINSUNG_V4 {
  expose ZCDS_MAT_MS;
}
```

CDS를 OData V4 서비스로 노출 → Service Binding을 통해 Fiori Elements UI가 자동 생성됩니다.

---

## 함께 학습한 Modern ABAP

RAP 구현 과정에서 ABAP Cloud의 최신 문법도 함께 연습했습니다.

| 클래스 | 학습 내용 |
|--------|-----------|
| `zcl_table_ms` | `VALUE` 연산자로 테이블 생성, `INSERT FROM TABLE`, Inline Declaration, RAP용 테스트 데이터 적재 |
| `zcl_conditionals_control_ms` | `COND` 표현식으로 조건 분기 (주식 trend → 의견 매핑) |
| `zcl_table2_ms` | `FILTER` 연산자 (Sorted Table 기반 조건 필터링) |

모두 `if_oo_adt_classrun` 인터페이스 기반의 Console 실행형 클래스로 작성했습니다.

---

## 배운 점

- **RAP는 CDS 설계가 핵심** — 데이터 모델(CDS)을 중심으로 Behavior, Service가 확장되는 구조를 직접 구현하며 체감했습니다.
- **Draft·권한·Determination** — 단순 CRUD를 넘어, 실무에서 필요한 동시성 제어와 자동화 로직을 BDEF/구현 클래스로 나눠 작성하는 방법을 익혔습니다.
- **백엔드에서 UI까지** — UI Annotation만으로 Fiori Elements 화면이 생성되는 "Annotation 기반 개발"의 원리를 이해했습니다.

---

*본 프로젝트는 ERP 연구회 학습 과정에서 SAP BTP Trial 환경(ABAP Cloud)으로 직접 구현한 개인 학습 결과물입니다.*
