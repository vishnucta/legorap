@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View for Content Manager'
@UI: {
 headerInfo: { typeName: 'Asset', typeNamePlural: 'Assets', title: { type: #STANDARD, value: 'AssetID' } } }

@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZASSET_C_LIST_CMGR
  as projection on zasset_i_list
{


       
       @ObjectModel.text.element: ['AssetName']
  key  asset_id          as AssetID,


       asset_name        as AssetName,


       asset_link        as AssetPortalLink,


       production_status as ProductionStatus,


       description       as Description,

       ready_date        as ReadyDate,

       asset_type        as AssetType,

       theme             as Theme,

       sku               as SKU,

       campaign          as Campaign,

       audience          as Audience,

       sub_audience      as SubAudience,

       market            as Market,

       cont_mgr          as ContentManager,


       last_changed_at   as LastChangedAt

}
