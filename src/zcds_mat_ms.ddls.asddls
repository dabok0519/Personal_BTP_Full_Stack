
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '자재 마스터 뷰'
--이 뷰가 무엇인지 설명하는 짧은 텍스트
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED }
-- 성능 최적화를 위해 컴퓨터에 보내는 힌트 
define root view entity ZCDS_MAT_MS as select from zmat_minsung
{
  // 1. 상세 화면(Object Page)의 탭/섹션을 정의합니다.
    @UI.facet: [ { id: 'idIdentification', 
                   type: #IDENTIFICATION_REFERENCE, 
                   label: '자재 상세 정보', 
                   position: 10 } ]  
    
  @UI.lineItem: [{ position: 10 }]         -- Fiori 리스트의 10번째 컬럼
  @UI.selectionField: [{ position: 10 }] -- 상단 조회 조건 필드
  @UI.identification: [ { position: 10 } ] // 상세 화면에 필드를 배치합니다.
  key matnr as Material,
  
  @UI.lineItem: [{ position: 20 }]
  @UI.identification: [ { position: 20 } ]
  maktx as Description,
  
  @UI.lineItem: [{ position: 30 }]
  @UI.selectionField: [{ position: 20 }]
  @UI.identification: [ { position: 30 } ]
  mtart as MaterialType_Ref,
  
  @UI.lineItem: [{ position: 40 }]
  @UI.identification: [ { position: 40 } ]
  meins as Unit,
  
  @UI.lineItem: [ { position: 50 } ]
    @UI.identification: [ { position: 50 } ]
  created_at as CreatedAt
    
}