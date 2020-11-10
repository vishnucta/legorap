@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Asset List'
define root view entity zasset_i_list
  as select from zasset_h as Asset

  /* Associations */

{
  //key mykey,
    key  asset_id,
      asset_link,
      asset_name,
      production_status,
      description,
      ready_date,
      asset_type,
      theme,
      sku,
      campaign,
      audience,
      sub_audience,
      market,
      cont_mgr,

      /*-- Admin data --*/
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,
      @Semantics.user.lastChangedBy: true
      last_changed_by,
      //@Semantics.systemDateTime.lastChangedAt: true
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at

}
