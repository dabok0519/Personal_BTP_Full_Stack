CLASS lhc_ZCDS_MAT_MS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcds_mat_ms RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zcds_mat_ms RESULT result.

    METHODS calculateCreatedAt FOR DETERMINE ON SAVE
      IMPORTING keys FOR zcds_mat_ms~calculateCreatedAt.

ENDCLASS.

CLASS lhc_ZCDS_MAT_MS IMPLEMENTATION.

  METHOD get_instance_authorizations.
  " 2. 수정(Update)과 삭제(Delete) 권한도 모두 허용으로 설정합니다.
    result = VALUE #( FOR key IN keys (
                        %tky    = key-%tky
                        %update = if_abap_behv=>auth-allowed
                        %delete = if_abap_behv=>auth-allowed ) ).
  ENDMETHOD.

  METHOD get_global_authorizations.
  " 1. 시스템이 '생성(create)' 권한을 확인해달라고 요청했는지 체크합니다.
  IF requested_authorizations-%create = if_abap_behv=>mk-on.

    " 2. 실제 현업에서는 여기서 AUTHORITY-CHECK 오브젝트를 사용합니다.
    " 지금은 실습 중이니 '무조건 허용(Allowed)'으로 응답

    result-%create = if_abap_behv=>auth-allowed.
  ENDIF.
  ENDMETHOD.

  METHOD calculateCreatedAt.
  " 1. 현재 변경 중인 데이터의 키(Key) 값들을 가져옵니다.
  READ ENTITIES OF ZCDS_MAT_MS IN LOCAL MODE
    ENTITY ZCDS_MAT_MS
      FIELDS ( CreatedAt ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_materials).

  GET TIME STAMP FIELD DATA(lv_ts). " 현재 시스템 시간 구하기

  " 2. 데이터에 시간을 채워서 업데이트합니다.
  MODIFY ENTITIES OF ZCDS_MAT_MS IN LOCAL MODE
    ENTITY ZCDS_MAT_MS
      UPDATE FIELDS ( CreatedAt )
      WITH VALUE #( FOR material IN lt_materials (
                      %tky       = material-%tky
                      CreatedAt = lv_ts ) ).
  ENDMETHOD.

ENDCLASS.
