*&---------------------------------------------------------------------*
*& Report ZMMK_COMPARE_INT_TABLES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMMK_COMPARE_INT_TABLES.



CLASS demo DEFINITION.
  PUBLIC SECTION.
  CLASS-METHODS main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.

    TYPES: BEGIN OF LINE,
      col1 TYPE I,
      col2 TYPE I,
    END OF LINE.

    DATA: itab TYPE TABLE OF LINE WITH EMPTY KEY,
          jtab TYPE TABLE OF LINE WITH EMPTY KEY.

    DATA(out) = cl_demo_output=>new( ).

    itab = VALUE #( FOR j = 1 UNTIL j > 3
    ( col1 = j col2 = j ** 2 ) ).

    jtab = itab.

    itab = VALUE #( BASE itab
    ( col1 = 10 col2 = 20 ) ).

    IF itab > jtab.
      out->write( 'ITAB >  JTAB' ).
    ENDIF.

    jtab = VALUE #( BASE jtab
    ( col1 = 10 col2 = 20 ) ).

    IF itab = jtab.
      out->write( 'ITAB =  JTAB' ).
    ENDIF.

    itab = VALUE #( BASE itab
    ( col1 = 30 col2 = 80 ) ).

    IF jtab <= itab.
      out->write( 'JTAB <= ITAB' ).
    ENDIF.

    jtab = VALUE #( BASE jtab
    ( col1 = 50 col2 = 60 ) ).

    IF itab <> jtab.
      out->write( 'ITAB <> JTAB' ).
    ENDIF.

    IF itab < jtab.
      out->write( 'ITAB <  JTAB' ).
    ENDIF.

    out->display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
demo=>main( ).
