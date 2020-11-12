*//&----------------------------------------------------------------------*
*//& ABAP Class Name    lhc_asset,lcl_save
*//&----------------------------------------------------------------------*
*//-----------------------------------------------------------------------*
*//* Class         : lhc_asset,lcl_save
*//* Title         : Local Class part of Behavior Implementation
*//* Create Date   : 10-Nov-2020
*//* Release       : ABAP Platform 1908 (755)
*//* Author        : Vishnu P/vishnucta@gmail.com(p1940421247)
*//* TR            :
*//*----------------------------------------------------------------------*
*//* Description   : Local Class part of Behavior Implementation
*//*-----------------------------------------------------------------------*
*//* CHANGE HISTORY
*//*-----------------------------------------------------------------------*
*//*Date       | User ID      |Description                   |Change Label *
*//*-----------------------------------------------------------------------*
*//*10-Nov-2020| p1940421247       | Initial                      |        *
*//*-----------------------------------------------------------------------*

CLASS lhc_asset DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.
    CLASS-DATA:
                 oref   TYPE REF TO cx_root .

  PRIVATE SECTION.

    METHODS copy_asset FOR MODIFY IMPORTING keys FOR ACTION asset~createAssetByTemplate RESULT result.
    METHODS set_production_accept FOR MODIFY IMPORTING keys FOR ACTION asset~acceptAsset RESULT result.
    METHODS set_production_denied FOR MODIFY IMPORTING keys FOR ACTION asset~rejectAsset RESULT result.
    METHODS validate_asset FOR VALIDATE ON SAVE IMPORTING keys FOR asset~validateAsset.
    METHODS validate_ready_date FOR VALIDATE ON SAVE IMPORTING keys FOR asset~validateReadyDate.
    METHODS get_features FOR FEATURES IMPORTING keys REQUEST    requested_features FOR asset    RESULT result.
    ...

ENDCLASS.

CLASS lhc_asset IMPLEMENTATION.
  ...

  "Feature control Implementation for Action
  METHOD get_features.
    "%control-<fieldname> specifies which fields are read from the entities

    READ ENTITY zasset_i_list FROM VALUE #( FOR keyval IN keys
                                                      (  %key                    = keyval-%key
                                                         %control-production_status = if_abap_behv=>mk-on
                                                        ) )
                                RESULT DATA(lt_asset_result).

    "Return that controls the feature %features-%action-<action name>
    result = VALUE #( FOR ls_asset IN lt_asset_result
                       ( %key                           = ls_asset-%key
                         %features-%action-rejectAsset = COND #( WHEN ls_asset-production_status = 'A'
                                                                    THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                      ) ).
  ENDMETHOD.
  "Handler method for data validation
  METHOD validate_ready_date.
    " (1) Read relevant asset instance data
    READ ENTITIES OF zasset_i_list IN LOCAL MODE
    ENTITY asset
     FIELDS ( asset_id ready_date )
     WITH CORRESPONDING #(  keys )
    RESULT DATA(lt_asset).

    " (2) Raise msg for past ready date
    LOOP AT lt_asset INTO DATA(ls_asset).
      IF ls_asset-ready_date < cl_abap_context_info=>get_system_date( ) AND ls_asset-ready_date IS NOT INITIAL.

        APPEND VALUE #(  asset_id = ls_asset-ready_date ) TO failed-asset.
        APPEND VALUE #(  asset_id = ls_asset-ready_date
                         %msg = new_message( id        = 'ZASSET_CM'
                                             number    = '004'
                                             v1        = ls_asset-ready_date
                                             severity  = if_abap_behv_message=>severity-error )
                         %element-ready_date = if_abap_behv=>mk-on )
          TO reported-asset.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
  " Handler Method for Asset validation
  METHOD validate_asset.

    DATA lv_numpart TYPE i.
    DATA lv_charpart(3) TYPE c.



    " (1) Read relevant asset instance data
    READ ENTITIES OF zasset_i_list IN LOCAL MODE
    ENTITY asset
     FIELDS ( asset_id asset_name )
     WITH CORRESPONDING #(  keys )
    RESULT DATA(lt_asset).


    " (2) Raise msg for Invalid asset id , name and link and validate the Asset ID Format
    LOOP AT lt_asset INTO DATA(ls_asset).


      IF ls_asset-asset_id IS NOT INITIAL.
        "Extraction of character from Asset ID
        lv_charpart = ls_asset-asset_id+0(3).
        " If Asset ID  doesnt have first 3 Character as AID
        IF lv_charpart NE 'AID'.
          APPEND VALUE #(  asset_id = ls_asset-asset_id ) TO failed-asset.
          APPEND VALUE #(  asset_id = ls_asset-asset_id
                           %msg = new_message( id        = 'ZASSET_CM'
                                               number    = '006'
                                               v1        = ls_asset-asset_id
                                               severity  = if_abap_behv_message=>severity-error )
                           %element-asset_id = if_abap_behv=>mk-on )
            TO reported-asset.
        ENDIF.

        "Try catch statement while type casting from String to Integer
        TRY.
            lv_numpart = ls_asset-asset_id+3(5).
          CATCH cx_root INTO oref.
            "If typecasting fails trigger a user error
            APPEND VALUE #(  asset_id = ls_asset-asset_id ) TO failed-asset.
            APPEND VALUE #(  asset_id = ls_asset-asset_id
                             %msg = new_message( id        = 'ZASSET_CM'
                                                 number    = '005'
                                                 v1        = ls_asset-asset_id
                                                 severity  = if_abap_behv_message=>severity-error )
                             %element-asset_id = if_abap_behv=>mk-on )
              TO reported-asset.
        ENDTRY.
      ENDIF.

      "If User enters Empty Asset ID
      IF ls_asset-asset_id IS INITIAL.

        APPEND VALUE #(  asset_id = ls_asset-asset_id ) TO failed-asset.
        APPEND VALUE #(  asset_id = ls_asset-asset_id
                         %msg = new_message( id        = 'ZASSET_CM'
                                             number    = '001'
                                             v1        = ls_asset-asset_id
                                             severity  = if_abap_behv_message=>severity-error )
                         %element-asset_id = if_abap_behv=>mk-on )
          TO reported-asset.
        "If user enters empty Asset Name
      ELSEIF ls_asset-asset_name IS INITIAL.
        APPEND VALUE #(  asset_id = ls_asset-asset_name ) TO failed-asset.
        APPEND VALUE #(  asset_id = ls_asset-asset_name
                         %msg = new_message( id        = 'ZASSET_CM'
                                             number    = '002'
                                             v1        = ls_asset-asset_name
                                             severity  = if_abap_behv_message=>severity-error )
                         %element-asset_name = if_abap_behv=>mk-on )
          TO reported-asset.
        "If User enters empty Asset Link
      ELSEIF ls_asset-asset_link IS INITIAL.
        APPEND VALUE #(  asset_id = ls_asset-asset_link ) TO failed-asset.
        APPEND VALUE #(  asset_id = ls_asset-asset_link
                         %msg = new_message( id        = 'ZASSET_CM'
                                             number    = '003'
                                             v1        = ls_asset-asset_link
                                             severity  = if_abap_behv_message=>severity-error )
                         %element-asset_link = if_abap_behv=>mk-on )
          TO reported-asset.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.


  METHOD set_production_accept.

  ENDMETHOD.

  "Method the Archive the confidential Assets
  METHOD set_production_denied.




    " Modify in local mode
    MODIFY ENTITIES OF zasset_i_list IN LOCAL MODE
           ENTITY asset
              UPDATE FROM VALUE #( FOR key IN keys ( asset_id = key-asset_id
                                                     production_status = 'A' " Archived
                                                     %control-production_status = if_abap_behv=>mk-on ) )
           FAILED   failed
           REPORTED reported.

    " Read changed data for action result
    READ ENTITIES OF zasset_i_list IN LOCAL MODE
         ENTITY asset
         FROM VALUE #( FOR key IN keys (  asset_id = key-asset_id
                                          %control = VALUE #(
                                            asset_id       = if_abap_behv=>mk-on
                                            asset_link     = if_abap_behv=>mk-on
                                            asset_name      = if_abap_behv=>mk-on
                                            asset_type        = if_abap_behv=>mk-on
                                            audience     = if_abap_behv=>mk-on

                                            campaign   = if_abap_behv=>mk-on
                                            cont_mgr  = if_abap_behv=>mk-on
                                            description     = if_abap_behv=>mk-on

                                          ) ) )
         RESULT DATA(lt_asset).

    result = VALUE #( FOR asset IN lt_asset ( asset_id = asset-asset_id
                                                %param    = asset
                                              ) ).

  ENDMETHOD.
  "Handler method for Copying the Asset for template creation . Disable for now in Behavior
  METHOD copy_asset.

    "Read the entity in Local mode a get the current instance of BO
    READ ENTITIES OF zasset_i_list IN LOCAL MODE
      ENTITY asset
         FIELDS ( asset_id
                  asset_name
                  production_status )
           WITH CORRESPONDING #( keys )
         RESULT    DATA(lt_read_result)
         FAILED    failed
         REPORTED  reported.

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    DATA lt_create TYPE TABLE FOR CREATE zasset_i_list\\asset.


    lt_create = VALUE #( FOR row IN  lt_read_result INDEX INTO idx
                             ( asset_id      = row-asset_id
                               asset_name      = row-asset_name
                               production_status    = row-production_status
                                ) ). " Open

    "Create the template value to the persistence table
    MODIFY ENTITIES OF zasset_i_list IN LOCAL MODE
        ENTITY asset
           CREATE FIELDS (    asset_id
                  asset_name
                  production_status )
           WITH lt_create
         MAPPED   mapped
         FAILED   failed
         REPORTED reported.


    result = VALUE #( FOR create IN  lt_create INDEX INTO idx
                             ( %cid_ref = keys[ idx ]-%cid_ref
                               %key     = keys[ idx ]-asset_id
                               %param   = CORRESPONDING #(  create ) ) ) .


  ENDMETHOD.
  ...

ENDCLASS.

"Local Template Class which can be used for Managed Save Option
CLASS lcl_save DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

ENDCLASS.


CLASS lcl_save IMPLEMENTATION.

  METHOD save_modified.

    " (1) Get instance data of all instances that have been created
    "IF create-asset IS NOT INITIAL.


    "ENDIF.

*    IF update-asset IS NOT INITIAL.
*      LOOP AT update-asset ASSIGNING FIELD-SYMBOL(<fs_asset>).
*
*      ENDLOOP..
*
*    ENDIF.
  ENDMETHOD.

ENDCLASS.
