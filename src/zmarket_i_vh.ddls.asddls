@AbapCatalog.sqlViewName: 'ZMARKETIVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Market Value Help'

@Search.searchable: true

define view ZMARKET_I_VH
  as select from zmarket_t as Market



{
      @Search.defaultSearchElement: true

  key Market.marketname as Market


}
