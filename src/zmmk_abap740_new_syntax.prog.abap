REPORT zmmk_abap740_new_syntax.


**********************************************************************
* 17. FOR Operator
**********************************************************************

DATA: inp TYPE c LENGTH 20 VALUE 'xyabc123',
      itab TYPE TABLE OF c1.

      DATA(no_char) = strlen( inp ).

    itab = VALUE #(

        for i = 0 UNTIL i >= no_char (  inp+i(1) )

    ).


    LOOP at itab INTO DATA(ls).

        WRITE:/ | Value of row { sy-tabix } is { ls }|.

    ENDLOOP.


**********************************************************************
* 16. VALUE expression
**********************************************************************

*TYPES: BEGIN OF ty_po,
*        ebeln TYPE ebeln,
*        lifnr TYPE lifnr,
*        risk TYPE flag,
*       END OF ty_po.
*
*TYPES: tt_po TYPE STANDARD TABLE OF ty_po WITH DEFAULT KEY.
*
*DATA: itab TYPE STANDARD TABLE OF ty_po.

* 1. VALUE with #
*  # means the field name and type would be delivered from LHS
*  itab table will be structure of the rows in VALUE #


*itab = VALUE #(
*    ( ebeln = 11 lifnr = 'Vendor1' risk = '' )
*    ( ebeln = 21 lifnr = 'Vendor2' risk = 'X' )
*    ( ebeln = 31 lifnr = 'Vendor3' risk = 'X' )
*
*).
*
*cl_demo_output=>display( itab ).


* 2. VALUE with NO #
* VALUE without # means the structure would be delivered from RHS table TYPE (tt_po)

*DATA(run_table) = VALUE tt_po(
*
*    ( ebeln = 11 lifnr = 'Vendor1' risk = '' )
*    ( ebeln = 21 lifnr = 'Vendor2' risk = 'X' )
*    ( ebeln = 31 lifnr = 'Vendor3' risk = 'X' )
*
*).
*cl_demo_output=>display( run_table ).

**********************************************************************
* 15. DATE Conversion
**********************************************************************
*
*DATA p_date TYPE sy-datum VALUE '20201108'.
*
*WRITE :/ |Original date { p_date }|.
*WRITE :/ |ISO Format { p_date DATE = ISO }|.
*WRITE :/ |User format { p_date DATE = USER }|.

*Result
*Original date 20201108
*ISO Format 2020-11-08
*User format 08.11.2020


**********************************************************************
* 14. ALPHA
**********************************************************************

*DATA(lv_matnr) = '000000000018366377'.
*
*WRITE:/ | Before conversion { lv_matnr }|.
*lv_matnr = | { lv_matnr ALPHA = OUT }  |.
*WRITE:/ | After Alpha conversion OUT, { lv_matnr }|.
*lv_matnr = | { lv_matnr ALPHA = IN }  |.
*WRITE:/ | After Alpha conversion IN, { lv_matnr }|.

*Result
* Before conversion 000000000018366377
* After Alpha conversion OUT,  18366377
* After Alpha conversion IN,  00000000001836637

**********************************************************************
* 13. Conditional Boolean BOOLC Functions
**********************************************************************

*SELECT po~ebeln , po~ebelp, po~matnr, po~werks AS po_werks, po~brtwr, plant~werks, plant~land1, plant~regio
*INTO TABLE @DATA(li_po)
*FROM ekpo as po
*INNER JOIN t001w as plant
*ON po~werks = plant~werks.
*
*LOOP AT li_po INTO DATA(ls_po).
*
*
*    IF boolc( ls_po-brtwr > 5000 AND ls_po-regio = '07') = ABAP_TRUE.
*        WRITE :/ |PO { ls_po-ebeln } Region { ls_po-regio } Value { ls_po-brtwr } is very Risky |.
*
*    ENDIF.
*ENDLOOP.
*

**********************************************************************
* 12. Possible to use RIGHT OUTER JOIN
**********************************************************************

*SELECT p~werks, v~bwkey INTO TABLE @DATA(li_valuation)
*FROM t001k AS v
*RIGHT OUTER JOIN t001w AS p ON v~bwkey = p~werks.


**********************************************************************
* 11.CASE Operation can be used in SELECT queries
**********************************************************************

** 1.    SIMPLE CASE statement
*
*SELECT ebeln, ebelp, matnr, werks,
*CASE loekz
*WHEN ' ' THEN 'Active'
*WHEN 'X' THEN 'Deleted'
*ELSE 'Doubtful'
*END AS status
*FROM ekpo INTO TABLE @DATA(li_po) UP TO 20 ROWS.
*
*IF sy-subrc EQ 0.
*
*  LOOP AT li_po INTO DATA(lwa).
*
*    WRITE:/ lwa-ebeln, lwa-status.
*
*  ENDLOOP.
*ENDIF.
*
*
** 2.    SEARCH CASE statement
*
*SELECT ebeln, ebelp, matnr, werks,
*
*CASE loekz
*    WHEN ' ' THEN 'Active'
*    WHEN 'X' THEN 'Deleted'
*    ELSE 'Doubtful'
*END AS status,
*
*CASE
*    WHEN brtwr > 5000 THEN 'Extra Sensitive PO'
*    WHEN brtwr > 1000 THEN 'Sensitive PO'
*    ELSE 'Normal PO'
*END AS po_sensitivity
*
*FROM ekpo INTO TABLE @DATA(li_po_2) UP TO 20 ROWS.
*
*IF sy-subrc EQ 0.
*
*  LOOP AT li_po_2 INTO DATA(lwa_2).
*
*    WRITE:/ lwa_2-ebeln, lwa_2-status, lwa_2-po_sensitivity.
*
*  ENDLOOP.
*ENDIF.


**********************************************************************
* 10. COALESCE functions - return first NON-NULL value from argument
*     Example:
*    Plant = RU5B Valuation = RU5B  Coaleace RU5B
*    Plant =  Valuation = RU81  Coaleace RU81
***********************************************************************
*
*SELECT p~werks, v~bwkey, COALESCE( p~werks, v~bwkey ) AS coal_plant
*INTO TABLE @DATA(li_valuation_plant) FROM t001k AS v
*LEFT OUTER JOIN t001w AS p ON v~bwkey = p~werks.
*
*WRITE:/ 'Done'.
*
*LOOP AT li_valuation_plant INTO DATA(lwa).
*
*WRITE:/ | Plant = { lwa-werks } Valuation = { lwa-bwkey }  Coaleace { lwa-coal_plant } |.
*
*ENDLOOP.


**********************************************************************
* 9.Usage of CEIL, FLOOR functions
*   CEIL - Next integer value, CEIL - Previous integer value
**********************************************************************
*
*DATA: lv_discount TYPE p LENGTH 4 DECIMALS 4 VALUE '0.912' .
*
*SELECT ebeln, werks, brtwr, brtwr * @lv_discount  AS dis_price,
*    CEIL( brtwr * @lv_discount ) AS ceil_price,
*    FLOOR( brtwr * @lv_discount ) AS floor_price
*    UP TO 10 rows from ekpo into table @data(li_po).
*
*IF sy-subrc EQ 0.
*
*    LOOP AT li_po INTO data(wa_po).
*        WRITE:/ wa_po-ebeln.
*        WRITE:/ |Original price { wa_po-brtwr } , Discount price { wa_po-dis_price }|.
*        WRITE:/ |Ceil price { wa_po-ceil_price } , Floor price { wa_po-floor_price }|.
*    ENDLOOP.
*
*
*ENDIF.


**********************************************************************
* 8. Arithmetic Expression can be performed in SELECT Query
**********************************************************************

*DATA: lv_discount TYPE p LENGTH 2 DECIMALS 2 VALUE '0.9' .
*
*SELECT ebeln, werks, brtwr, brtwr * @lv_discount  AS dis_price UP TO 10 rows from ekpo into table @data(li_po).
*IF sy-subrc EQ 0.
*
*    LOOP AT li_po INTO data(wa_po).
*        WRITE:/ wa_po-ebeln.
*        WRITE:/ |Original price { wa_po-brtwr } Discount price { wa_po-dis_price }|.
*    ENDLOOP.
*
*
*ENDIF.


**********************************************************************
* 7.HAVING Clause can be used for the Aggregated Columns
**********************************************************************

*TABLES: ekpo.
*SELECT-OPTIONS s_werks FOR ekpo-werks.
*
*SELECT werks, ebeln,
*    MAX( brtwr ) AS max_price,
*    SUM( brtwr ) AS tot_price,
*    AVG( brtwr ) AS avg_price
*FROM ekpo INTO TABLE @DATA(it_po) GROUP BY werks, ebeln
*HAVING werks IN @s_werks.
*
*LOOP AT it_po INTO data(wa_po).
*
*    WRITE:/ | For PO: { wa_po-ebeln }|.
*    WRITE:/ | Max Price: { wa_po-max_price } Total Price: { wa_po-tot_price } Average Price: { wa_po-avg_price } |.
*
*ENDLOOP.



**********************************************************************
* 6. Aggregate functions like SUM, AVG, MIN, MAX etc (existing) using GROUP BY Clause
**********************************************************************
*SELECT werks,
*MAX( brtwr ) AS max_price,
*SUM( brtwr ) AS tot_price,
*AVG( brtwr ) AS avg_price
*FROM ekpo INTO TABLE @DATA(it_po) GROUP BY werks. " ebeln, werks
*
*IF sy-subrc EQ 0.
*
*ENDIF.


**********************************************************************
* 5. CLIENT SPECIFIED syntax replaced by USING CLIENT ‘client’
**********************************************************************

*SELECT mandt, werks, regio, name1 UP TO 10 ROWS INTO TABLE @data(it_plant)
*FROM t001w CLIENT SPECIFIED WHERE mandt = '240'.


*SELECT mandt, werks, regio, name1 UP TO 10 ROWS INTO TABLE @data(it_plant)
*FROM t001w USING CLIENT '240'.




**********************************************************************
* 4. Concatenation can be done using Pipe | | Operator
**********************************************************************
*i. Multiple strings concatenation can be done using && operator
*
*ii. Variables can be passed in concatenation operation using  { }  curly braces
*
*iii. Single Quotes (‘), Double Quotes (“) can be used as it is in || operator


**SELECT mandt, werks, regio, name1 UP TO 10 ROWS FROM t001w INTO TABLE @data(it_plant).
**
**IF sy-subrc EQ 0.
**
**   LOOP AT it_plant INTO data(wa_plant).
**
*** OLD WAY of concatenate strings
***    CONCATENATE wa_plant-werks '->' wa_plant-name1 INTO wa_plant-name1.
***    WRITE:/ wa_plant-name1.
**
*** NEW WAY of concatenate strings
**
**    WRITE:/ | { wa_plant-werks } -> { wa_plant-name1 } |.
**    WRITE :/ | This is loop { sy-tabix }|.
*    WRITE :/ | This is loop| && | { sy-tabix }| .
**
**    ENDLOOP.
**
**
**ENDIF.
**
*

**********************************************************************

**********************************************************************
* 3. Comma (,)Queries in SELECT and Mandatory to Escape Host variables using @ symbol
**********************************************************************
*
*SELECT mandt, werks, regio, name1 UP TO 10 ROWS FROM t001w INTO TABLE @data(it_plant).
*IF sy-subrc EQ 0.
*
*ENDIF.
**********************************************************************

**********************************************************************
* 2. String Literals in SELECT Queries
**********************************************************************

*TABLES: t001w.
*SELECT-OPTIONS: s_werks FOR t001w-werks.
*
*SELECT SINGLE 'Valid plant' FROM t001w INTO @data(lv_validity) WHERE werks IN @s_werks.
*IF sy-subrc NE 0.
*    lv_validity =  'Invalid plant !'.
*ENDIF.
*
*WRITE:/ lv_validity.
*
** If the plant is valid it will print Valid plant.
** In case of true the string 'Valid plant' is copied to lv_validity
***********************************************************************

**********************************************************************
* 1. In line data declaration
**********************************************************************

*DATA: it_mara TYPE TABLE OF mara.
*
*SELECT * FROM mara INTO TABLE it_mara UP TO 10 ROWS.

* Example of in line data declaration

*SELECT * FROM mara INTO TABLE @data(it_mara) UP TO 10 rows.
*
*LOOP AT it_mara INTO data(wa_mara).
*
*ENDLOOP.
*
*WRITE 'Done'.
**********************************************************************
