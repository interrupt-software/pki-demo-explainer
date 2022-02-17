<?php

$myfile = fopen("00_env_boostrap_vars.bash", "w") or die("Unable to open file!");

$root_ca_name = preg_replace("/\s/", '-', $_POST["root-name"]);

if($root_ca_name === NULL or $root_ca_name == '') {
    $root_ca_name = "hashicat";
}

$name = "export RootName=" . $root_ca_name . "\n";
fwrite($myfile, $name);
fclose($myfile);

echo "
<table>
    <tr>
        <td>" . "Root CA name: "  . "</td>
        <td>" . $root_ca_name . "</td>
    </tr>
</table>
";

?>