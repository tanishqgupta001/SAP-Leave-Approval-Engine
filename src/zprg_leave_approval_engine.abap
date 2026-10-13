REPORT zprg_leave_approval_engine.

" 1. Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_status TYPE ztg_de_lv_status DEFAULT 'P'.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

" 2. Internal Table Declaration
  DATA: lt_leaves TYPE STANDARD TABLE OF zleave_req.

" 3. Fetching Pending Records via Open SQL
  SELECT *
    FROM zleave_req
    WHERE status = @p_status
    ORDER BY req_id ASCENDING
    INTO TABLE @lt_leaves.

  IF sy-subrc <> 0.
    MESSAGE 'No leave requests found for the selected status!' TYPE 'I'.
    EXIT.
  ENDIF.

" 4. Business Logic via Field-Symbols (In-Place Memory Pointer)
  LOOP AT lt_leaves ASSIGNING FIELD-SYMBOL(<lfs_leave>).
    IF <lfs_leave>-leave_days <= 5.
      <lfs_leave>-status = 'A'. " Approved
    ELSE.
      <lfs_leave>-status = 'R'. " Rejected
    ENDIF.
  ENDLOOP.

" 5. Persistence via SAP LUW
  UPDATE zleave_req FROM TABLE @lt_leaves.

  IF sy-subrc = 0.
    COMMIT WORK.
  ELSE.
    ROLLBACK WORK.
    MESSAGE 'Database update failed!' TYPE 'E'.
    EXIT.
  ENDIF.

" 6. OO-ALV Display
  DATA: lo_alv TYPE REF TO cl_salv_table.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = lt_leaves ).

      DATA(lo_columns) = lo_alv->get_columns( ).
      lo_columns->set_optimize( abap_true ).

      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->display( ).

    CATCH cx_salv_msg.
      MESSAGE 'Error initializing ALV' TYPE 'E'.
  ENDTRY.
