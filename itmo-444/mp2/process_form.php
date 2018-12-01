<?php
  $name = $_GET["name"];
  $email = $_GET["email"];
  $tel = $_GET["telnum"];
	$filePath = $_GET["imgurl"];
	require '/home/ubuntu/vendor/autoload.php';
	$bucket = "mp2raw";
	$keyName = basename($filePath);
	use Aws\S3\S3Client;
	use Aws\S3\Exception\S3Exception;
  $s3 = new Aws\S3\S3Client([
      'version' => 'latest',
      'region' => 'us-east-2'
  ]);
	try {
		if (!file_exists('/tmp/tmpfile')) {
			mkdir('/tmp/tmpfile');
		}
		$tempFilePath = '/tmp/tmpfile/' . basename($filePath);
		$tempFile = fopen($tempFilePath, "w") or die("Error: Unable to open file.");
		$fileContents = file_get_contents($filePath);
		$tempFile = file_put_contents($tempFilePath, $fileContents);

		$s3->putObject(
			array(
				'Bucket' => $bucket,
				'Key' => $keyName,
				'SourceFile' => $tempFilePath,
        'ACL' => 'public-read'
			)
		);
	} catch (S3Exception $e) {
		echo $e->getMessage();
	} catch (Exception $e) {
		echo $e->getMessage();
	}

$s3url = "https://$bucket.s3.amazonaws.com/$keyName";

# End S3 raw upload
# Start SQS queue & uuid generation

$sqs = new Aws\Sqs\SqsClient([
    'version' => 'latest',
    'region'  => 'us-east-2'
]);

#list the SQS Queue URL
$listQueueresult = $sqs->listQueues([

]);
$queueurl = $listQueueresult['QueueUrls'][0];
$uuid = uniqid();
$sendmessageresult = $sqs->sendMessage([
    'DelaySeconds' => 30,
    'MessageBody' => $uuid,
    'QueueUrl' => $queueurl
]);

# End SQS queue & uuid generation
# Start MySQL/RDS table insert

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
    (name, uuid, email, phone, s3rawurl, status)
    VALUES ('$name', '$uuid', '$email', '$tel', '$s3url','0')";
    if ($mysqli->query($sql)) {
        printf("Values added to requests table.\n");
    }
  $mysqli->close();

?>
