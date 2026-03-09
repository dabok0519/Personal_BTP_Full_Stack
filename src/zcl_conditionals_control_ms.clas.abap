CLASS zcl_conditionals_control_ms DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    " 데이터를 담을 구조(Structure)와 테이블 타입 정의
    TYPES: BEGIN OF ty_stock,
             name  TYPE string,
             price TYPE p LENGTH 8 DECIMALS 2,
             trend TYPE string,
           END OF ty_stock.
    TYPES tt_stocks TYPE STANDARD TABLE OF ty_stock WITH EMPTY KEY.

ENDCLASS.




CLASS zcl_conditionals_control_ms IMPLEMENTATION.

 METHOD if_oo_adt_classrun~main.
    " 1. 테이블 변수 선언과 동시에 데이터 채우기 (Inline Declaration)
    DATA(lt_my_stocks) = VALUE tt_stocks(
      ( name = 'Palantir' price = '25.30'  trend = 'UP' )
      ( name = 'Daedong'  price = '12.15'  trend = 'DOWN' )
      ( name = 'SAP'      price = '185.00' trend = 'UP' )
      ( name = 'Samsung'  price = '72.50'  trend = 'STABLE' )
    ).

    LOOP AT lt_my_stocks INTO DATA(ls_stock).
        DATA(lv_action) = COND STRING(
        WHEN ls_stock-trend = 'UP' THEN '추천'
        WHEN ls_stock-trend = 'DOWN' THEN '비추'
        WHEN ls_stock-trend = 'STABLE' THEN '보류'
        ELSE '오류'
        ).
        out->write( |종목: { ls_stock-name } | && | 의견: { lv_action }| ).
    ENDLOOP.
    ENDMETHOD.
ENDCLASS.
