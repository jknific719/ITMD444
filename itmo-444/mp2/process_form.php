<?php
  $name = $_GET["name"];
  $email = $_GET["email"];
  $tel = $_GET["telnum"];
	$filePath = $_GET["imgurl"];
	require 'vendor/autoload.php';
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
  include 'db_add.php';
?>
