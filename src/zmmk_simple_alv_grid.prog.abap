*&---------------------------------------------------------------------*
*& Report ZMMK_SIMPLE_ALV_GRID
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMMK_SIMPLE_ALV_GRID.

*----------------------------------------------------------------------*
DATA alv TYPE REF TO cl_salv_table.

*----------------------------------------------------------------------*
* INTERNAL TABLE definitions                                           *
*----------------------------------------------------------------------*
DATA flight_schedule TYPE STANDARD TABLE OF spfli.


START-OF-SELECTION.
PERFORM get_flight_schedule.

PERFORM initialize_alv.

PERFORM display_alv.


*&---------------------------------------------------------------------*
FORM get_flight_schedule.
*&---------------------------------------------------------------------*
  SELECT * FROM spfli INTO TABLE flight_schedule UP TO 100 ROWS.
ENDFORM.                    " GET_FLIGHT_SCHEDULE

*&---------------------------------------------------------------------*
FORM initialize_alv.
*&---------------------------------------------------------------------*
  DATA MESSAGE TYPE REF TO cx_salv_msg.

  TRY.
    cl_salv_table=>factory(
    IMPORTING
      r_salv_table = alv
    CHANGING
      t_table      = flight_schedule ).
  CATCH cx_salv_msg INTO MESSAGE.
    " error handling
  ENDTRY.
ENDFORM.                    " INITIALIZE_ALV

*&---------------------------------------------------------------------*
FORM display_alv.
*&---------------------------------------------------------------------*
  alv->display( ).
ENDFORM.                    " DISPLAY_ALV

************************************************************************
* SUBROUTINES - END                                                    *
************************************************************************
