CLASS zcl_abap_select_distinct DEFINITION
*Count number of words and number of unique characters in each word

  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abap_select_distinct IMPLEMENTATION.

METHOD if_oo_adt_classrun~main.

    DATA(sentence) = 'ABAP is excellent programming language'.
    SPLIT  condense( sentence )  AT | | INTO TABLE DATA(words).

    out->write( |Number of words: { lines( words ) }| ).

    LOOP AT words ASSIGNING FIELD-SYMBOL(<word>).

        DATA(characters) = VALUE ABAP_SORTORDER_tab( FOR char = 0 THEN char + 1 UNTIL char = strlen( <word> ) ( name = <word>+char ) ) .
        SELECT DISTINCT * FROM @characters AS characters INTO TABLE @DATA(unique_characters).
        out->write( |Number of unique characters in the word: { <word> } - { lines( unique_characters ) } | ).

    ENDLOOP.



ENDMETHOD.

ENDCLASS.
