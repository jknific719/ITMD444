<?php

require '/home/ubuntu/vendor/autoload.php';
use Aws\Sqs\SqsClient;
$sqs = new Aws\Sqs\SqsClient([
    'version' => 'latest',
    'region'  => 'us-east-2'
]);

#list the SQS Queue URL
$listQueueresult = $sqs->listQueues([

]);
$queueurl = $listQueueresult['QueueUrls'][0];

$receivemessageresult = $sqs->receiveMessage([
    'MaxNumberOfMessages' => 1,
    'QueueUrl' => $queueurl,
    'VisibilityTimeout' => 60,
    'WaitTimeSeconds' => 5
]);
# Exits script if no message was found
if (!$receivemessageresult) {
  exit(0);
}
$receiptHandle = $receivemessageresult['Messages'][0]['ReceiptHandle'];
$uuid = $receivemessageresult['Messages'][0]['Body'] . "\n";
# Now in your data base do a select * from records where uuid=$uuid;
# What will this give you?  S3 URL for the raw bucket
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
$sql = "SELECT `s3rawurl` FROM requests WHERE uuid='" . $uuid . "'";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$filePath = $row['s3rawurl']

$sql = "SELECT `email` FROM requests WHERE uuid='" . $uuid . "'";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$email = $row['email']

$sql = "SELECT `phone` FROM requests WHERE uuid='" . $uuid . "'";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$tel = $row['phone']
# $mysqli->close();
$keyName = basename($filePath);
$bucket = "mp2finished";
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
  shell_exec("mogrify -colorspace Gray $tempFilePath");
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
$sql = "UPDATE requests SET status = '1', s3finisedurl = '$s3url'  WHERE uuid='$uuid'";
$mysqli->query($sql);
$mysqli->close();
use Aws\Sns\SnsClient;
$sns = SnsClient::factory(array(
'region'  => 'us-east-1',
'version' => 'latest'
));
$topic = $sns->listTopics(array());
$topic_arn = $topic->get("TopicArn");

$telsub = $sns->subscribe(array(
    'TopicArn' => $topic_arn,
    'Protocol' => 'sms',
    'Endpoint' => $tel
));
$emailsub = $sns->subscribe(array(
    'TopicArn' => $topic_arn,
    'Protocol' => 'email',
    'Endpoint' => $email
));
$result = $sns->publish(array(
    'TopicArn' => $topic_arn,
    // Message is required
    'Message' => "Here is your image: $s3url"
  ));
$deletemessageresult = $sqs->deleteMessage([
    'QueueUrl' => $queueurl, // REQUIRED
    'ReceiptHandle' => $receiptHandle, // REQUIRED
]);

?>
