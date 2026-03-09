CLASS zcl_table2_ms DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  TYPES: BEGIN OF ty_stock,
             name  TYPE string,
             price TYPE p LENGTH 8 DECIMALS 2,
             trend TYPE string,
           END OF ty_stock.
    TYPES tt_stocks TYPE SORTED TABLE OF ty_stock WITH NON-UNIQUE KEY trend.
    "FILTER를 사용하기 위해서는 SORTED or Hashed Table이어야 하며, 대상 값이 key로 존재해야 함
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TABLE2_MS IMPLEMENTATION.


     METHOD if_oo_adt_classrun~main.
    " 1. 테이블 변수 선언과 동시에 데이터 채우기 (Inline Declaration)
    DATA(lt_my_stocks) = VALUE tt_stocks(
      ( name = 'Palantir' price = '25.30'  trend = 'UP' )
      ( name = 'Daedong'  price = '12.15'  trend = 'DOWN' )
      ( name = 'SAP'      price = '185.00' trend = 'UP' )
      ( name = 'Samsung'  price = '72.50'  trend = 'STABLE' )
    ).

    DATA(ls_Result) = FILTER #( lt_my_stocks EXCEPT WHERE trend = `UP` ).
    out->write( ls_Result ).
    endMETHOD.
ENDCLASS.
