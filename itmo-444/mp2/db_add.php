<?php
require '/home/ubuntu/vendor/autoload.php';
use Aws\Rds\RdsClient;
$rds = new Aws\Rds\RdsClient([
     'version' => 'latest',
     'region' => 'us-east-2'
 ]);

$result = $rds->describeDBInstances([
    'DBInstanceIdentifier' => 'mp2database'
]);
$rdsIP = $result['DBInstances'][0]['Endpoint']['Address'];
$mysqli = mysqli_connect($rdsIP,"mrvl","excelsior","requestdata") or die("Error " . mysqli_error($mysqli));
# 0 = not done, 1 = done for status
$sql = "INSERT INTO requests
  (name, email, phone, s3rawurl, status)
  VALUES ($name, $email, $tel, $s3url, 0)";
  if ($mysqli->query($sql)) {
      printf("Values added to requests table.\n");
  }
$mysqli->close();

 ?>
