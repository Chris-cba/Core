CREATE OR REPLACE PACKAGE BODY nm3_msv_util AS
--------------------------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3_msv_util.pkb-arc   3.0   Jan 16 2015 11:08:08   Mike.Huitson  $
--       Module Name      : $Workfile:   nm3_msv_util.pkb  $
--       Date into PVCS   : $Date:   Jan 16 2015 11:08:08  $
--       Date fetched Out : $Modtime:   Jan 16 2015 10:14:48  $
--       PVCS Version     : $Revision:   3.0  $
--
--   Product upgrade script
--
--------------------------------------------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------------------------------------------
--
g_body_sccsid     CONSTANT  VARCHAR2(30) := '"$Revision:   3.0  $"';
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
--------------------------------------------------------------------------------------------------------------------
-- Get the value of a specific field from the style definition
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_style_value (pi_style  IN VARCHAR2
                         ,pi_field  IN VARCHAR2
             ,pi_type   IN VARCHAR2 DEFAULT 'MARKER'
             )
RETURN VARCHAR2
IS
  lv_pos  NUMBER;
  lv_str  nm3type.max_varchar2;
  --
BEGIN
  lv_pos := INSTR(pi_style, pi_field);
  --
  IF lv_pos > 0 THEN
    --
    lv_str := SUBSTR(pi_style, lv_pos + LENGTH(pi_field));
    --
    IF INSTR(lv_str, ';') = 0 THEN
      lv_str := SUBSTR(lv_str, 1, LENGTH(lv_str));
    ELSE
      lv_str := SUBSTR(lv_str, 1, INSTR(lv_str, ';') - 1);
    END IF;
    --
  END IF;
  --
  RETURN lv_str;
  --
EXCEPTION WHEN OTHERS THEN
  lv_str  :=  CASE pi_type
          WHEN 'MARKER' THEN '16'
          WHEN 'TEXT'   THEN '12'
          ELSE '25'
        END;
  --
  RETURN lv_str;
  --
END get_style_value;
--
--------------------------------------------------------------------------------------------------------------------
-- MARKER Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_marker_style_size (pi_style_name  IN  MDSYS.sdo_styles_table.name%TYPE
                ,po_width   OUT NUMBER
                ,po_height      OUT NUMBER)
IS
  CURSOR c_style(cp_name  MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  EXTRACTVALUE(XMLTYPE(definition), '/svg/g/@style') style
    FROM  MDSYS.sdo_styles_table style_table
    WHERE   style_table.name = cp_name
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  c_style%ROWTYPE;
  --
BEGIN
  OPEN  c_style(pi_style_name);
  --
  FETCH c_style INTO lr_style;
  --
  CLOSE c_style;
  --
  po_width := TO_NUMBER(NVL(get_style_value(lr_style.style, 'width:', 'MARKER'), 16));
  --
  po_height := TO_NUMBER(NVL(get_style_value(lr_style.style, 'height:', 'MARKER'), 16));
  --
EXCEPTION WHEN OTHERS THEN
  po_width  := 16;
  po_height := 16;
  --
  IF error_msg_gbl IS NULL THEN
      error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || pi_style_name;
  ELSE
      error_msg_gbl := error_msg_gbl || ', ' ||pi_style_name;
  END IF;
  --
END get_marker_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- AREA Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_area_style_size (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                ,width    OUT NUMBER
                ,height   OUT NUMBER
                )
IS
--
BEGIN
  width  := 80;
  height := 40;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_area_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- COLOR Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_color_style_size  (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                ,width    OUT NUMBER
                ,height   OUT NUMBER
                )
IS
--
BEGIN
  width  := 80;
  height := 25;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_color_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- LINE Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_line_style_size (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                ,width    OUT NUMBER
                ,height   OUT NUMBER
                )
IS
--
BEGIN
  width  := 80;
  height := 25;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_line_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- TEXT Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_text_style_size (style_name   IN  MDSYS.sdo_styles_table.name%TYPE
                ,font_size    OUT NUMBER
                ,letter_spacing OUT NUMBER
                )
IS
  CURSOR get_text_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  textstyle.style, textstyle.letter_spacing
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/svg/g'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
            style   VARCHAR2(4000)  PATH '@style',
            letter_spacing NUMBER     PATH '@letter-spacing'
            ) textstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_text_style%ROWTYPE;
BEGIN
  OPEN get_text_style(style_name);
  --
  FETCH get_text_style INTO lr_style;
  --
  CLOSE get_text_style;
  --
  font_size := TO_NUMBER(NVL(get_style_value(lr_style.style, 'font-size:', 'TEXT'), 12));
  --
  letter_spacing := TO_NUMBER(NVL(lr_style.letter_spacing, 0));
  --
EXCEPTION WHEN OTHERS THEN
  font_size     := 12;
  letter_spacing  := 0;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_text_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- Equal Bucket Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_equal_bucket_style_size   (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                    ,width    OUT NUMBER
                    ,height   OUT NUMBER
                    )
IS
  CURSOR get_equal_bucket_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  equalbucketstyle.styles, equalbucketstyle.nbuckets, equalbucketstyle.low, equalbucketstyle.high
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/BucketStyle/Buckets'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
            styles   VARCHAR2(4000)  PATH '@styles',
            nbuckets NUMBER      PATH '@nbuckets',
            low    VARCHAR2(4000)  PATH '@low',
            high   VARCHAR2(4000)  PATH '@high'
            ) equalbucketstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_equal_bucket_style%ROWTYPE;
  style   MDSYS.sdo_styles_table.name%TYPE;
  --
  comma_pos NUMBER;
  temp_width  NUMBER  := 0;
  temp_height NUMBER  := 0;
  --
BEGIN
  OPEN get_equal_bucket_style(style_name);
  --
  FETCH get_equal_bucket_style INTO lr_style;
  --
  CLOSE get_equal_bucket_style;
  --
  WHILE (INSTR(lr_style.styles, ',') > 0) OR lr_style.styles IS NOT NULL LOOP
    comma_pos := INSTR(lr_style.styles, ',');
    --
    IF comma_pos != 0 THEN
      style       := SUBSTR(lr_style.styles, 1, comma_pos - 1);
      lr_style.styles := SUBSTR(lr_style.styles, comma_pos + 1);
    ELSE
      style       := lr_style.styles;
      lr_style.styles := NULL;
    END IF;
    --
    get_style_size(style, width, height);
    --
    IF width > temp_width THEN
      temp_width := width;
    END IF;
    --
    IF height > temp_height THEN
      temp_height := height;
    END IF;
  END LOOP;
  --
  height := (temp_height + 2)*lr_style.nbuckets + 25;
  --
  IF LENGTH(lr_style.low) < LENGTH(lr_style.high) THEN
    width  :=  10*LENGTH(lr_style.high) + temp_width + 25;
  ELSE
    width  :=  10*LENGTH(lr_style.low) + temp_width + 25;
  END IF;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_equal_bucket_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- Ranged Bucket Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_ranged_bucket_style_size  (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                    ,width    OUT NUMBER
                    ,height   OUT NUMBER
                    )
IS
  font_size     NUMBER  := 10;
  letter_spacing    NUMBER  := 0;
  temp_font_size    NUMBER  := 0;
  temp_letter_spacing NUMBER  := 0;
  max_label_size    NUMBER  := 0;
  num_of_buckets    NUMBER  := 0;
  temp_width      NUMBER  := 0;
  temp_height     NUMBER  := 0;
  --
  CURSOR get_ranged_bucket_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  rangedbucketstyle.style, rangedbucketstyle.label, rangedbucketstyle.label_style
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/BucketStyle/Buckets/RangedBucket'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
            style   VARCHAR2(4000)  PATH '@style',
            label     VARCHAR2(4000)  PATH '@label',
            label_style VARCHAR2(4000)  PATH '@label_style'
            ) rangedbucketstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_ranged_bucket_style%ROWTYPE;
  --
BEGIN
  OPEN get_ranged_bucket_style(style_name);
  --
  LOOP
    FETCH get_ranged_bucket_style INTO lr_style;
    EXIT WHEN get_ranged_bucket_style%NOTFOUND;
    --
    get_style_size(lr_style.style, width, height);
    --
    IF width > temp_width THEN
      temp_width := width;
    END IF;
    --
    IF height > temp_height THEN
      temp_height := height;
    END IF;
    --
    IF lr_style.label IS NOT NULL THEN
      IF LENGTH(lr_style.label) > max_label_size THEN
        max_label_size := LENGTH(lr_style.label);
      END IF;
    END IF;
    --
    IF lr_style.label_style IS NOT NULL THEN
      get_style_size(lr_style.label_style, font_size, letter_spacing);
      --
      IF font_size > temp_font_size THEN
        temp_font_size := font_size;
      END IF;
      --
      IF letter_spacing > temp_letter_spacing THEN
        temp_letter_spacing := letter_spacing;
      END IF;
    END IF;
  END LOOP;
  --
  IF font_size > temp_height THEN
    temp_height := font_size;
  END IF;
  --
  num_of_buckets := get_ranged_bucket_style%ROWCOUNT;
  --
  CLOSE get_ranged_bucket_style;
  --
  height := (temp_height + 2)*num_of_buckets + 25;
  width  := font_size*max_label_size + temp_letter_spacing + temp_width + 25;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_ranged_bucket_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- Collection Bucket Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_coll_bucket_style_size(style_name IN  MDSYS.sdo_styles_table.name%TYPE
                  ,width    OUT NUMBER
                  ,height   OUT NUMBER
                  )
IS
  font_size     NUMBER  := 10;
  letter_spacing    NUMBER  := 0;
  temp_font_size    NUMBER  := 0;
  temp_letter_spacing NUMBER  := 0;
  max_label_size    NUMBER  := 0;
  num_of_buckets    NUMBER  := 0;
  temp_width      NUMBER  := 0;
  temp_height     NUMBER  := 0;
  --
  CURSOR get_collection_bucket_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  collectionbucketstyle.style, collectionbucketstyle.label, collectionbucketstyle.label_style
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/BucketStyle/Buckets/CollectionBucket'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
            style   VARCHAR2(4000)  PATH '@style',
            label     VARCHAR2(4000)  PATH '@label',
            label_style VARCHAR2(4000)  PATH '@label_style'
            ) collectionbucketstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_collection_bucket_style%ROWTYPE;
  --
BEGIN
  OPEN get_collection_bucket_style(style_name);
  --
  LOOP
    FETCH get_collection_bucket_style INTO lr_style;
    EXIT WHEN get_collection_bucket_style%NOTFOUND;
    --
    get_style_size(lr_style.style, width, height);
    --
    IF width > temp_width THEN
      temp_width := width;
    END IF;
    --
    IF height > temp_height THEN
      temp_height := height;
    END IF;
    --
    IF lr_style.label IS NOT NULL THEN
      IF LENGTH(lr_style.label) > max_label_size THEN
        max_label_size := LENGTH(lr_style.label);
      END IF;
    END IF;
    --
    IF lr_style.label_style IS NOT NULL THEN
      get_style_size(lr_style.label_style, font_size, letter_spacing);
      --
      IF font_size > temp_font_size THEN
        temp_font_size := font_size;
      END IF;
      --
      IF letter_spacing > temp_letter_spacing THEN
        temp_letter_spacing := letter_spacing;
      END IF;
    END IF;
  END LOOP;
  --
  IF font_size > temp_height THEN
    temp_height := font_size;
  END IF;
  --
  num_of_buckets := get_collection_bucket_style%ROWCOUNT;
  --
  CLOSE get_collection_bucket_style;
  --
  height := (temp_height + 2)*num_of_buckets + 25;
  width  := font_size*max_label_size + temp_letter_spacing + temp_width + 25;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_coll_bucket_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- ColorScheme Equal Bucket Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_colsch_eql_bkt_style_size (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                    ,width    OUT NUMBER
                    ,height   OUT NUMBER
                    )
IS
  CURSOR get_colsch_eql_bkt_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  colscheqlbktstyle.high, colscheqlbktstyle.nbuckets
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/ColorSchemeStyle/Buckets'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              high    VARCHAR2(4000)  PATH '@high',
              nbuckets  NUMBER      PATH '@nbuckets'
            ) colscheqlbktstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_colsch_eql_bkt_style%ROWTYPE;
  --
BEGIN
  OPEN get_colsch_eql_bkt_style(style_name);
  --
  FETCH get_colsch_eql_bkt_style INTO lr_style;
  --
  CLOSE get_colsch_eql_bkt_style;
  --
  height := 25*lr_style.nbuckets + 25;
  width  := 10*LENGTH(lr_style.high) + 225;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_colsch_eql_bkt_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- ColorScheme Ranged Bucket Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_colsch_rngd_bkt_style_size(style_name IN  MDSYS.sdo_styles_table.name%TYPE
                    ,width    OUT NUMBER
                    ,height   OUT NUMBER
                    )
IS
  max_label_size  NUMBER  := 0;
  num_of_buckets  NUMBER  := 0;
  --
  CURSOR get_colsch_rngd_bkt_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  colschrngdbktstyle.label
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/ColorSchemeStyle/Buckets/RangedBucket'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              label   VARCHAR2(4000)  PATH '@label'
            ) colschrngdbktstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_colsch_rngd_bkt_style%ROWTYPE;
  --
BEGIN
  OPEN get_colsch_rngd_bkt_style(style_name);
  --
  LOOP
    FETCH get_colsch_rngd_bkt_style INTO lr_style.label;
    EXIT WHEN get_colsch_rngd_bkt_style%NOTFOUND;
    --
    IF LENGTH(lr_style.label) > max_label_size THEN
      max_label_size := LENGTH(lr_style.label);
    END IF;
    --
  END LOOP;
  --
  num_of_buckets := get_colsch_rngd_bkt_style%ROWCOUNT;
  --
  CLOSE get_colsch_rngd_bkt_style;
  --
  height := 25*num_of_buckets + 25;
  width  := 10*max_label_size + 225;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_colsch_rngd_bkt_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- ColorScheme Collection Bucket Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_colsch_coll_bkt_style_size(style_name IN  MDSYS.sdo_styles_table.name%TYPE
                    ,width    OUT NUMBER
                    ,height   OUT NUMBER
                    )
IS
  max_label_size  NUMBER  := 0;
  num_of_buckets  NUMBER  := 0;
  --
  CURSOR get_colsch_coll_bkt_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  colschcollbktstyle.label
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/ColorSchemeStyle/Buckets/CollectionBucket'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              label   VARCHAR2(4000)  PATH 'text()'
            ) colschcollbktstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_colsch_coll_bkt_style%ROWTYPE;
  --
BEGIN
  OPEN get_colsch_coll_bkt_style(style_name);
  --
  LOOP
    FETCH get_colsch_coll_bkt_style INTO lr_style.label;
    EXIT WHEN get_colsch_coll_bkt_style%NOTFOUND;
    --
    IF LENGTH(lr_style.label) > max_label_size THEN
      max_label_size := LENGTH(lr_style.label);
    END IF;
    --
  END LOOP;
  --
  num_of_buckets := get_colsch_coll_bkt_style%ROWCOUNT;
  --
  CLOSE get_colsch_coll_bkt_style;
  --
  height := 25*num_of_buckets + 25;
  width  := 10*max_label_size + 225;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_colsch_coll_bkt_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- DotDensity Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_dotdensity_style_size (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                  ,width    OUT NUMBER
                  ,height   OUT NUMBER
                  )
IS
  CURSOR get_dotdensity_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  dotdensitystyle.dotwidth, dotdensitystyle.dotheight
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/DotDensityStyle'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              dotwidth  NUMBER  PATH '@DotWidth',
              dotheight   NUMBER  PATH '@DotHeight'
        ) dotdensitystyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_dotdensity_style%ROWTYPE;
  --
BEGIN
  OPEN get_dotdensity_style(style_name);
  --
  FETCH get_dotdensity_style INTO lr_style; --dot_width, dot_height;
  --
  CLOSE get_dotdensity_style;
  --
  height := 4*(lr_style.dotheight + 10);
  width  := 4*(lr_style.dotwidth + 10);
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_dotdensity_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- Variable Marker Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_varmarker_style_size (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                  ,width    OUT NUMBER
                  ,height   OUT NUMBER
                  )
IS
  max_label_size    NUMBER      := 0;
  num_of_buckets    NUMBER      := 0;
  --
  CURSOR get_varmarker_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  varmarkerstyle.basemarker, varmarkerstyle.startsize, varmarkerstyle."increment"
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/VariableMarkerStyle'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              basemarker  VARCHAR2(32)  PATH '@basemarker',
              startsize   NUMBER      PATH '@startsize',
              "increment" NUMBER      PATH '@increment'
        ) varmarkerstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  CURSOR get_varmarker_bucket_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  varmarkerstyle.label, varmarkerstyle.low, varmarkerstyle.high
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/VariableMarkerStyle/Buckets/RangedBucket'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              label   VARCHAR2(4000)  PATH '@label',
              low   VARCHAR2(4000)  PATH '@low',
              high  VARCHAR2(4000)  PATH '@high'
        ) varmarkerstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style_vm   get_varmarker_style%ROWTYPE;
  lr_style_vmb  get_varmarker_bucket_style%ROWTYPE;
  --
BEGIN
  OPEN get_varmarker_style(style_name);
  --
  FETCH get_varmarker_style INTO lr_style_vm;
  --
  CLOSE get_varmarker_style;
  --
  --
  OPEN get_varmarker_bucket_style(style_name);
  --
  LOOP
    FETCH get_varmarker_bucket_style INTO lr_style_vmb;
    EXIT WHEN get_varmarker_bucket_style%NOTFOUND;
    --
    IF lr_style_vmb.label IS NOT NULL THEN
      IF LENGTH(lr_style_vmb.label) > max_label_size THEN
        max_label_size := LENGTH(lr_style_vmb.label);
      END IF;
    ELSE
      IF LENGTH(lr_style_vmb.low) > LENGTH(lr_style_vmb.high)THEN
        max_label_size := LENGTH(lr_style_vmb.low);
      ELSE
        max_label_size := LENGTH(lr_style_vmb.high);
      END IF;
    END IF;
  END LOOP;
  --
  num_of_buckets := get_varmarker_bucket_style%ROWCOUNT;
  --
  CLOSE get_varmarker_bucket_style;
  --
  height := (lr_style_vm.startsize*num_of_buckets) + lr_style_vm."increment"*(num_of_buckets*(num_of_buckets - 1))/2 + (3*num_of_buckets);
  width  := 2*(max_label_size + 25) + lr_style_vm.startsize + lr_style_vm."increment"*num_of_buckets;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_varmarker_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- BarChart Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_barchart_style_size   (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                  ,width    OUT NUMBER
                  ,height   OUT NUMBER
                  )
IS
  num_of_bars NUMBER  := 0;
  --
  CURSOR get_barchart_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  barchartstyle.width, barchartstyle.height
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/BarChartStyle'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              width   NUMBER  PATH '@width',
              height  NUMBER  PATH '@height'
        ) barchartstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  CURSOR get_barchart_bar_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  barchartstyle.name
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/BarChartStyle/Bar'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              name  VARCHAR2(4000)  PATH '@name'
        ) barchartstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style_b  get_barchart_style%ROWTYPE;
  lr_style_bb get_barchart_bar_style%ROWTYPE;
  --
BEGIN
  OPEN get_barchart_style(style_name);
  --
  FETCH get_barchart_style INTO lr_style_b;
  --
  CLOSE get_barchart_style;
  --
  --
  OPEN get_barchart_bar_style(style_name);
  --
  LOOP
    FETCH get_barchart_bar_style INTO lr_style_bb;
    EXIT WHEN get_barchart_bar_style%NOTFOUND;
  END LOOP;
  --
  num_of_bars := get_barchart_bar_style%ROWCOUNT;
  --
  CLOSE get_barchart_bar_style;
  --
  height := lr_style_b.height + 25;
  width  := num_of_bars*lr_style_b.width + 25;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_barchart_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- PieChart Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_piechart_style_size   (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                  ,width    OUT NUMBER
                  ,height   OUT NUMBER
                  )
IS
  max_size    NUMBER      := 1;
  num_of_slices NUMBER      := 0;
  num_of_rows   NUMBER      := 0;
  min_width   NUMBER      := 72;
  min_height    NUMBER      := 60;
  --
  CURSOR get_piechart_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  piechartstyle.name
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/PieChartStyle/PieSlice'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              name  VARCHAR2(4000)  PATH '@name'
        ) piechartstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_piechart_style%ROWTYPE;
  --
BEGIN
  OPEN get_piechart_style(style_name);
  --
  LOOP
    FETCH get_piechart_style INTO lr_style;
    EXIT WHEN get_piechart_style%NOTFOUND;
    --
    IF LENGTH(lr_style.name) > max_size THEN
      max_size := LENGTH(lr_style.name);
    END IF;
  END LOOP;
  --
  num_of_slices := get_piechart_style%ROWCOUNT;
  CLOSE get_piechart_style;
  --
  IF max_size > 1 THEN
    IF num_of_slices <= 3 THEN
      min_width  := 72 + (max_size - 2)*18;
    ELSE
      min_width  := 256 + (max_size - 2)*36;
    END IF;
  END IF;
  --
  IF num_of_slices > 6 THEN
    num_of_rows := ROUND(num_of_slices/3);
    --
    IF (num_of_rows*3) < num_of_slices THEN
      num_of_rows := num_of_rows + 1;
    END IF;
    --
    min_height := 20*num_of_rows;
  END IF;
  height := min_height;
  width  := min_width;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_piechart_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- Variable PieChart Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_varpiechart_style_size  (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                    ,width    OUT NUMBER
                    ,height   OUT NUMBER
                    )
IS
  max_label_size  NUMBER      := 0;
  num_of_buckets  NUMBER      := 0;
  --
  CURSOR get_varpiechart_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  varpiechartstyle.startradius, varpiechartstyle."increment"
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/VariablePieChartStyle'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              startradius NUMBER  PATH '@startradius',
              "increment" NUMBER  PATH '@increment'
        ) varpiechartstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
    --
  CURSOR get_varpiechart_buckets(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  varpiechartstyle.label
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/VariablePieChartStyle/Buckets/RangedBucket'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              label VARCHAR2(4000)  PATH '@label'
        ) varpiechartstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style_vp   get_varpiechart_style%ROWTYPE;
  lr_style_vpb  get_varpiechart_buckets%ROWTYPE;
  --
BEGIN
  OPEN get_varpiechart_style(style_name);
  --
  FETCH get_varpiechart_style INTO lr_style_vp;
  --
  CLOSE get_varpiechart_style;
  --
  OPEN get_varpiechart_buckets(style_name);
  --
  LOOP
    FETCH get_varpiechart_buckets INTO lr_style_vpb;
    EXIT WHEN get_varpiechart_buckets%NOTFOUND;
    --
    IF LENGTH(lr_style_vpb.label) > max_label_size THEN
      max_label_size := LENGTH(lr_style_vpb.label);
    END IF;
  END LOOP;
  --
  num_of_buckets := get_varpiechart_buckets%ROWCOUNT;
  CLOSE get_varpiechart_buckets;
  --
  height := 2*(lr_style_vp.startradius*num_of_buckets) + 2*(lr_style_vp."increment"*(num_of_buckets*(num_of_buckets - 1))/2) + 3*num_of_buckets;
  width  := 2*(max_label_size + 25) + lr_style_vp.startradius + (lr_style_vp."increment"*num_of_buckets);
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_varpiechart_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- Collection Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_collection_style_size (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                  ,width    OUT NUMBER
                  ,height   OUT NUMBER
                  )
IS
  max_height    NUMBER  := 0;
  max_width   NUMBER  := 0;
  num_of_styles NUMBER  := 0;
  --
  CURSOR get_collection_style(style_name_c MDSYS.sdo_styles_table.name%TYPE) IS
    SELECT  collectionstyle.name
    FROM  MDSYS.sdo_styles_table style_table,
        XMLTABLE(
            '/AdvancedStyle/CollectionStyle/style'
            PASSING XMLTYPE(style_table.definition)
            COLUMNS
              name  VARCHAR2(32)  PATH '@name'
        ) collectionstyle
    WHERE   style_table.name = style_name_c
    AND   style_table.sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  lr_style  get_collection_style%ROWTYPE;
BEGIN
  OPEN get_collection_style(style_name);
  --
  LOOP
    FETCH get_collection_style INTO lr_style;
    EXIT WHEN get_collection_style%NOTFOUND;
    --
    get_style_size(lr_style.name, width, height);
    --
    IF width > max_width THEN
      max_width := width;
    END IF;
    --
    IF height > max_height THEN
      max_height := height;
    END IF;
  END LOOP;
  --
  num_of_styles := get_collection_style%ROWCOUNT;
  CLOSE get_collection_style;
  --
  height := max_height;
  width  := (num_of_styles)*(max_width + 25);
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || chr(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_collection_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- HeatMap Style
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_heatmap_style_size  (style_name IN  MDSYS.sdo_styles_table.name%TYPE
                  ,width    OUT NUMBER
                  ,height   OUT NUMBER
                  )
IS
--
BEGIN
  height := 50;
  width  := 100;
  --
END get_heatmap_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- Decide Style Type and Call that Procedure
--------------------------------------------------------------------------------------------------------------------
--
PROCEDURE get_style_size  (style_name IN  MDSYS.sdo_styles_table.name%TYPE
              ,width    OUT NUMBER
              ,height   OUT NUMBER
              )
IS
  style_type  MDSYS.sdo_styles_table.type%TYPE;
  num_of_tags NUMBER;
  style_def   MDSYS.sdo_styles_table.definition%TYPE;
  --
BEGIN
  SELECT  type
  INTO  style_type
  FROM  MDSYS.sdo_styles_table
  WHERE   name = UPPER(style_name)
  AND   sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
  --
  IF style_type = 'ADVANCED' THEN
    SELECT  definition
    INTO  style_def
    FROM  MDSYS.sdo_styles_table
    WHERE   name = style_name
    AND   sdo_owner = SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER');
    --
    IF INSTR(style_def, '<BucketStyle') > 0 THEN
      IF INSTR(style_def, '<RangedBucket') > 0 THEN
        style_type := 'ADV_RANGED_BUCKET_STYLE';
        get_ranged_bucket_style_size(style_name, width, height);
      ELSIF INSTR(style_def, '<CollectionBucket') > 0 THEN
        style_type := 'ADV_COLLECTION_BUCKET_STYLE';
        get_coll_bucket_style_size(style_name, width, height);
      ELSE
        style_type := 'ADV_EQUAL_BUCKET_STYLE';
        get_equal_bucket_style_size(style_name, width, height);
      END IF;
    ELSIF INSTR(style_def, '<ColorSchemeStyle') > 0 THEN
      IF INSTR(style_def, '<RangedBucket') > 0 THEN
        style_type := 'ADV_RANGED_COLORSCHEME_STYLE';
        get_colsch_rngd_bkt_style_size(style_name, width, height);
      ELSIF INSTR(style_def, '<CollectionBucket') > 0 THEN
        style_type := 'ADV_COLLECTION_COLORSCHEME_STYLE';
        get_colsch_coll_bkt_style_size(style_name, width, height);
      ELSE
        style_type := 'ADV_EQUAL_COLORSCHEME_STYLE';
        get_colsch_eql_bkt_style_size(style_name, width, height);
      END IF;
    ELSIF INSTR(style_def, '<DotDensityStyle') > 0 THEN
      style_type := 'ADV_DOTDENSITY_STYLE';
      get_dotdensity_style_size(style_name, width, height);
    ELSIF INSTR(style_def, '<VariableMarkerStyle') > 0 THEN
      style_type := 'ADV_VARIABLEMARKER_STYLE';
      get_varmarker_style_size(style_name, width, height);
    ELSIF INSTR(style_def, '<BarChartStyle') > 0 THEN
      style_type := 'ADV_BARCHART_STYLE';
      get_barchart_style_size(style_name, width, height);
    ELSIF INSTR(style_def, '<PieChartStyle') > 0 THEN
      style_type := 'ADV_PIECHART_STYLE';
      get_piechart_style_size(style_name, width, height);
    ELSIF INSTR(style_def, '<VariablePieChartStyle') > 0 THEN
      style_type := 'ADV_VARIABLEPIECHART_STYLE';
      get_varpiechart_style_size(style_name, width, height);
    ELSIF INSTR(style_def, '<CollectionStyle') > 0 THEN
      style_type := 'ADV_COLLECTION_STYLE';
      get_collection_style_size(style_name, width, height);
    ELSIF INSTR(style_def, '<HeatMapStyle') > 0 THEN
      style_type := 'ADV_HEATMAP_STYLE';
      get_heatmap_style_size(style_name, width, height);
    END IF;
    --
  ELSIF style_type = 'MARKER' THEN
    get_marker_style_size(style_name, width, height);
  ELSIF style_type = 'AREA' THEN
    get_area_style_size(style_name, width, height);
  ELSIF style_type = 'COLOR' THEN
    get_color_style_size(style_name, width, height);
  ELSIF style_type = 'LINE' THEN
    get_line_style_size(style_name, width, height);
  ELSIF style_type = 'TEXT' THEN
    get_text_style_size(style_name, width, height);
  END IF;
  --
  IF height > 1000 THEN
    height := 999;
  END IF;
  --
  IF width > 1000 THEN
    width := 999;
  END IF;
  --
  IF height = 0 OR height IS NULL THEN
    height := 25;
  END IF;
  --
  IF width = 0 OR width IS NULL THEN
    width := 25;
  END IF;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 25;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following styles: ' || CHR(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
END get_style_size;
--
--------------------------------------------------------------------------------------------------------------------
-- Function to return width and height of style as an OBJECT
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_style_size (style_name IN  MDSYS.sdo_styles_table.name%TYPE)
RETURN nm_msv_style_size
IS
  height    NUMBER      := 25;
  width   NUMBER      := 80;
  h_w_array nm_msv_style_size;
  --
BEGIN
  error_msg_gbl := NULL;
  --
  get_style_size(style_name, width, height);
  --
  IF width < 80 THEN
    width := 80;
  END IF;
  --
  IF height = 999 AND width < 500 THEN
    width := 500;
  ELSIF width < 80 THEN
    width := 80;
  END IF;
  --
  h_w_array := nm_msv_style_size(width, height, error_msg_gbl);
  --
  RETURN h_w_array;
  --
EXCEPTION WHEN OTHERS THEN
  width  := 80;
  height := 25;
  --
  IF error_msg_gbl IS NULL THEN
    error_msg_gbl := 'Encountered error/s in rendering following style/s: ' || CHR(10) || style_name;
  ELSE
    error_msg_gbl := error_msg_gbl  ||  ', ' || style_name;
  END IF;
  --
  h_w_array := nm_msv_style_size(width, height, error_msg_gbl);
  --
  RETURN h_w_array;
  --
END get_style_size;
--
--------------------------------------------------------------------------------------------------------------------
--
END nm3_msv_util;
/
