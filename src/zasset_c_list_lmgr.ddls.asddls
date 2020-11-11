@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View for Local Market Manager'
@UI: {
 headerInfo: { typeName: 'Asset', typeNamePlural: 'Assets', title: { type: #STANDARD, value: 'AssetID' } } }

@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZASSET_C_LIST_LMGR
  as projection on zasset_i_list
{
       

       
       
  key  asset_id          as AssetID,
       
       
       asset_name        as AssetName,
       
       
       asset_link        as AssetPortalLink,

       
       production_status as ProductionStatus,

       
       description       as Description,
       
       ready_date        as ReadyDate,
       
       asset_type        as AssetType,
       
       theme as Theme,
       
       sku as SKU,
       
       campaign as Campaign,
       
       audience as Audience,
       
       sub_audience as SubAudience,
       
       market as Market,
       
       cont_mgr as ContentManager,

       
       last_changed_at   as LastChangedAt

}where production_status != 'A'
