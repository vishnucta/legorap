//-----------------------------------------------------------------------*
//* View Name     : ZASSET_I_VH
//* Title         : Value Help View for Assets 
//* Create Date   : 12-Nov-2020
//* Release       : ABAP Platform 1809 (754)
//* Author        : Vishnu P/vishnucta@gmail.com(p1940421247)
//*----------------------------------------------------------------------*
//* Description   : Value Help View for Assets 
//*
//*
//*
//*-----------------------------------------------------------------------*
//* CHANGE HISTORY
//*-----------------------------------------------------------------------*
//*Date        | User ID      |Description                   |Change Label *
//*-----------------------------------------------------------------------*
//* 12-Nov-2020|p1940421247   | Initial                      |             *
//*            |              |                              |             *
//*            |              |                              |             *
//*-----------------------------------------------------------------------*

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
