@AbapCatalog.sqlViewName: 'ZASSETIVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Asset Value Help'

@Search.searchable: true

define view ZASSET_I_VH
  as select from zasset_i_list as Asset



{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['AssetName']
  key asset_id   as AssetID,
      @Semantics.text: true
      asset_name as AssetName


}
