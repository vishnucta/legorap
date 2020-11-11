CLASS lhc_asset DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS copy_asset FOR MODIFY IMPORTING keys FOR ACTION asset~createAssetByTemplate RESULT result.
    ...

ENDCLASS.

CLASS lhc_asset IMPLEMENTATION.
  ...

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
*    DATA : lw_guid TYPE string.

*    CALL FUNCTION 'GENERAL_GET_RANDOM_STRING'
*      EXPORTING
*        number_chars  = 32
*      IMPORTING
*        random_string = lw_guid.

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
