<?php

$url = "http://localhost:8091/db";
$first  = microtime( true );
$n = 100000;
for( $i = 0; $i < $n; $i++ ){
        $rc = file_get_contents( $url );        
        if(( $i % 1000 ) == 0 ){
                echo "$i : |$rc| \n";       
        }
}
$last = microtime( true );
$elapsed = $last - $first;
$perSec = $n/$elapsed;
echo "elapsed = $elapsed ; queries/sec = $perSec";

