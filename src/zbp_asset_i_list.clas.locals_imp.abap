CLASS lhc_asset DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS copy_asset FOR MODIFY IMPORTING keys FOR ACTION asset~createAssetByTemplate RESULT result.
    METHODS set_production_accept FOR MODIFY IMPORTING keys FOR ACTION asset~acceptAsset RESULT result.
    METHODS set_production_denied FOR MODIFY IMPORTING keys FOR ACTION asset~rejectAsset RESULT result.

    ...

ENDCLASS.

CLASS lhc_asset IMPLEMENTATION.
  ...



  METHOD set_production_accept.

  ENDMETHOD.

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

  METHOD copy_asset.

    SELECT MAX( asset_id ) FROM zasset_h INTO @DATA(lv_asset_id).

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
                             ( asset_id      = 'Sample ID'
                               asset_name      = row-asset_name
                               production_status    = row-production_status
                                ) ). " Open


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

CLASS lcl_save DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

ENDCLASS.


CLASS lcl_save IMPLEMENTATION.

  METHOD save_modified.

    " (1) Get instance data of all instances that have been created
    IF create-asset IS NOT INITIAL.


    ENDIF.

    IF update-asset IS NOT INITIAL.
      LOOP AT update-asset ASSIGNING FIELD-SYMBOL(<fs_asset>).

      ENDLOOP..

    ENDIF.
  ENDMETHOD.

ENDCLASS.
