REPORT zprg_generate_leaves.

DATA: lt_leaves TYPE STANDARD TABLE OF zleave_req.

START-OF-SELECTION.

  lt_leaves = VALUE #(
    ( mandt = sy-mandt req_id = 'LR1001' emp_id = 'EMP_101' leave_days = 3  status = 'P' )
    ( mandt = sy-mandt req_id = 'LR1002' emp_id = 'EMP_102' leave_days = 7  status = 'P' )
    ( mandt = sy-mandt req_id = 'LR1003' emp_id = 'EMP_103' leave_days = 4  status = 'P' )
    ( mandt = sy-mandt req_id = 'LR1004' emp_id = 'EMP_104' leave_days = 12 status = 'P' )
  ).

  MODIFY zleave_req FROM TABLE @lt_leaves.

  IF sy-subrc = 0.
    COMMIT WORK.
    WRITE: / 'Success: 4 Dummy Leave Requests Inserted into ZLEAVE_REQ!'.
  ELSE.
    ROLLBACK WORK.
    WRITE: / 'Error: Data insertion failed!'.
  ENDIF.
