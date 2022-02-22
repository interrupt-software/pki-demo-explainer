<?php

$myfile = fopen("/var/www/html/bash/00_env_root_ca_vars.bash", "w") or die("Unable to open file!");

$root_ca_name = preg_replace("/\s/", '-', $_POST["root-ca-name"]);
$root_ca_cn   = preg_replace("/\s/", '-', $_POST["root-ca-cn"]);
$root_ca_ttl  = preg_replace("/\s/", '-', $_POST["root-ca-ttl"]);

if($root_ca_name === NULL or $root_ca_name == '') {
    $root_ca_name = "hashicat";
}

if($root_ca_cn === NULL or $root_ca_cn == '') {
    $root_ca_cn = "hashicat.io";
}

if($root_ca_ttl === NULL or $root_ca_ttl == '') {
    $root_ca_ttl = "24h";
}

$var1 = "export RootName=\"" . $root_ca_name . "\"\n";
$var2 = "export CommonName=\"" . $root_ca_cn . "\"\n";
$var3 = "export CA_ttl=\"" . $root_ca_ttl . "\"\n";

fwrite($myfile, $var1);
fwrite($myfile, $var2);
fwrite($myfile, $var3);

fclose($myfile);

echo "
<table>
    <tr>
        <td>" . "Root CA name: "  . "</td>
        <td>" . $root_ca_name . "</td>
    </tr>
    <tr>
        <td>" . "Root CA Common Name: "  . "</td>
        <td>" . $root_ca_cn . "</td>
    </tr>
    <tr>
        <td>" . "Root CA TTL: "  . "</td>
        <td>" . $root_ca_ttl . "</td>
    </tr>
</table>
";

?>