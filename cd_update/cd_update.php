<?php
//====================================================================================
// OCS INVENTORY REPORTS
// Copyleft Erwan GOALOU 2010 (erwan(at)ocsinventory-ng(pt)org)
// Web: http://www.ocsinventory-ng.org
//
// This code is open source and may be copied and modified as long as the source
// code is always made freely available.
// Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
//====================================================================================
if(AJAX){
           parse_str($protectedPost['ocs']['0'], $params);
           $protectedPost+=$params;
           ob_start();
           $ajax = true;
   }
   else{
           $ajax=false;
   }


   print_item_header(UPDATE);
   if (!isset($protectedPost['SHOW']))
   $protectedPost['SHOW'] = 'NOSHOW';

   $form_name="apt_update";
   $table_name=$form_name;

   $tab_options=$protectedPost;
   $tab_options['form_name']=$form_name;
   $tab_options['table_name']=$table_name;

   echo open_form($form_name);

   $sql="select id from apt_update where hardware_id=%s";
   $arg=$systemid;
   $res =mysql2_query_secure( $sql, $_SESSION['OCS']["readServer"],$arg);
   $val = mysqli_fetch_array( $res );


   echo "<form name='".$form_name."' id='".$form_name."' method='POST' action=''>";

   if (isset($val['id'])){
        $list_fields=array('App' => 'APP',
                           'Version' => 'VERSION',
                           'Update' => 'APTUPDATE');

        $list_col_cant_del=$list_fields;
        $default_fields= $list_fields;
        $queryDetails  = "SELECT * FROM apt_update WHERE (hardware_id=$systemid)";
   }

   ajaxtab_entete_fixe($list_fields,$default_fields,$tab_options,$list_col_cant_del);
   echo close_form();
   if ($ajax){
        ob_end_clean();
        tab_req($list_fields,$default_fields,$list_col_cant_del,$queryDetails,$tab_options);
        ob_start();
   }
?>
