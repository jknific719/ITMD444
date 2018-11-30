<?php
//conection:

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

$sql = "CREATE TABLE IF NOT EXISTS requests
(
  id INT NOT NULL AUTO_INCREMENT,
  uuid PRIMARY KEY(id)
  name VARCHAR(255) NOT NULL,
  email VARCHAR(200) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  s3rawurl VARCHAR(255) NOT NULL,
  s3finishedurl VARCHAR(255) NOT NULL,
  status INT NOT NULL
)";

$mysqli->close();
?>
