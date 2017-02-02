# Introduction:

Ce plugin permet de remonter dans OCS le nombre et la liste des mises à jour disponibles sur une machine Debian / Ubuntu.

Il est basé sur le plugin Crontab créé par Guillaume PROTET. (http://wiki.ocsinventory-ng.org/index.php?title=Plugins:Crontab/fr)


# Installation du plugin:

## Coté client:

Le fichier update_list.sh mise à jour le cache APT puis copie la liste des mise à jour disponibles dans un fichier (/tmp/update) vous devrez donc commencer par copier ce fichier sur votre client et l'ajouter dans un cron executé à la fréquence que vous souhaitez.

Copieez le fichier Apt_update.pm dans le dossier modules de votre agent OCS, sous debian /usr/share/perl5/Ocsinventory/Agent/Modules.

Ajoutez la ligne suivante des le fichier modules.conf :

use Ocsinventory::Agent::Modules::Apt_update;


## Coté serveur:

 Ajoutez une table "apt_update" sur votre base SQL:

| Field       | Type         | Null | Key | Default | Extra          |
|-------------|--------------|------|-----|-------:|---------------:|
| ID          | int(11)      | NO   | PRI | NULL    | auto_increment |
| HARDWARE_ID | int(11)      | NO   | PRI | NULL    |                |
| APP         | varchar(255) | YES  |     | NULL    |                |
| VERSION     | varchar(255) | YES  |     | NULL    |                |
| APTUPDATE   | varchar(255) | YES  |     | NULL    |                |
| number      | int(4)       | YES  |     | NULL    |                |




Copiez cd_update dans le répoértoire plugins de votre installation OCS sous debian (/usr/share/ocsinventory-reports/ocsreports/plugins/computer_detail/).

Editez le fichier /usr/local/share/perl/5.20.2/Apache/Ocsinventory/Map.pm

Pour y ajouter le routage suivant:

```
apt_update => {
mask => 0,
multi => 1,
auto => 1,
delOnReplace => 1,
sortBy => 'NUMBER',
writeDiff => 0,
cache => 0,
fields => {
 APP => {},
 VERSION => {},
 APTUPDATE => {},
 NUMBER => {}
}
},
```

Si vous souhaitez afficher le nombre de mise à jours sur votre liste "all_computers":

Editez:

/usr/share/ocsinventory-reports/ocsreports/plugins/main_sections/ms_all_computers/ms_all_computers.php

Puis ajoutez:

```
$default_fields=array_merge($default_fields2,$default_fields3);
$sql=prepare_sql_tab($list_fields,array('SUP','CHECK'));
$tab_options['ARG_SQL']=$sql['ARG'];
$queryDetails  = $sql['SQL']." from hardware h
                               LEFT JOIN accountinfo a ON a.hardware_id=h.id
                               LEFT JOIN apt_update u ON u.hardware_id=h.id";
if ($show_mac_addr){
       $queryDetails  .= "     LEFT JOIN networks n ON n.hardware_id=h.id ";
       $queryDetails  .= " AND h.IPADDR=n.IPADDRESS ";
}
```
