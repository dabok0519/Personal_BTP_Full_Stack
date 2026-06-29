CLASS zcl_table_ms DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS ZCL_TABLE_MS IMPLEMENTATION.


    METHOD if_oo_adt_classrun~main.
    DATA: IT_materials TYPE TABLE OF zmat_minsung.

   " 1. 기존 데이터 초기화
    DELETE FROM zmat_minsung.

   " 2. 자재 데이터 준비 (Modern ABAP의 VALUE 연산자 활용)
    GET TIME STAMP FIELD DATA(lv_ts).

    IT_materials = VALUE #(
      ( matnr = 'MAT-001' maktx = 'CPU i9'     mtart = 'ROH'  meins = 'EA' created_at = lv_ts )
      ( matnr = 'MAT-002' maktx = 'DDR5 32GB'  mtart = 'ROH'  meins = 'EA' created_at = lv_ts )
      ( matnr = 'MAT-003' maktx = 'Gaming PC'  mtart = 'FERT' meins = 'EA' created_at = lv_ts )
    ).

   " 3. DB에 데이터 저장
    INSERT zmat_minsung FROM TABLE @IT_materials.

   " 4. 저장된 데이터 조회 (Inline Declaration 활용)
    SELECT * FROM zmat_minsung
      INTO TABLE @DATA(lt_result).

   " 5. 콘솔 출력 (ALV 대신 확인용)
    out->write( '--- MM 자재 마스터 조회 결과 ---' ).
    out->write( lt_result ).

  ENDMETHOD.
ENDCLASS.