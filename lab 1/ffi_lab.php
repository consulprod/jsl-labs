<?php
 
// create definitions
echo 'start ffi' . '<br />';
try{
$bubble = FFI::cdef(
"void bubble_sort(char [], int);",
"./libbubble.so");
}catch(Exception $e){
  echo $e;
}

echo 'build <br />';

// create FFI\CData array
$max = 16;
$arr = FFI::new('char[' . $max . ']');

// populate array with random string  values
$a = range('A','Z');
for ($i = 0; $i < $max; $i++)
  $arr[$i]->cdata = $a[array_rand($a)];

// perform bubble sort
$bubble->bubble_sort($arr, $max);
foreach($arr as $item){
  echo $item . '<br />';
}
