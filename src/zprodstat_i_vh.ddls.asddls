@AbapCatalog.sqlViewName: 'ZPRODSTATIVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Market Value Help'

@Search.searchable: true

// Use of DB DD07T isnt permitted , cannot access domain ZPRODSTATUS

define view ZPRODSTAT_I_VH
  as select from zprodstat_t as ProdStat



{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['StatName']
  key production_status as ProdStatus,
      @Semantics.text: true
      status_name       as StatName

}
