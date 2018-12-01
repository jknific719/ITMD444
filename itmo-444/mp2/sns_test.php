<?php
require '/home/vagrant/vendor/autoload.php';
use Aws\Sns\SnsClient;

$client = SnsClient::factory(array(
'region'  => 'us-east-1'
));

$topic_arn = $client->createTopic(array(
    'Name' => 'img_proc',
));
$result = $client->subscribe(array(
    // TopicArn is required
    'TopicArn' => $topic_arn,
    // Protocol is required
    'Protocol' => 'sms',
    'Endpoint' => '18476247618',
));
$result = $client->publish(array(
    'TopicArn' => $topic_arn,
    'TargetArn' => $topic_arn,
    // Message is required
    'Message' => 'Hey Nerd'
  );
?>
