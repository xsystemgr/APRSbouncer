#!/usr/bin/perl
use Config::Simple;
use Net::Telnet;

$cfg = new Config::Simple('APRSclient.conf');

$callsign = $cfg->param('Callsign');
if (! $callsign) {
   printf("Callsign not defined. Please check config file!\n");
   exit 1;
}
$server = $cfg->param('Server');
if (! $server) {
   printf("Server not defined. Please check config file!\n");
   exit 2;
}
$port = $cfg->param('Port');
if (! $port) {
   printf("Port not defined. Please check config file!\n");
   exit 3;
}
$user = $cfg->param('Username');
if (! $user) {
   printf("Username not defined. Please check config file!\n");
   exit 4;
}
$passcode = $cfg->param('Passcode');
if (! $passcode) {
   printf("Passcode not defined. Please check config file!\n");
   exit 5;
}

my $session = new Net::Telnet(Timeout => '60');
$session->errmode('return');
$session->Net::Telnet::open(Host => $server, Port => $port);
print $session "user $user pass $passcode vers APRSclient 0.1 filter b/$callsign*\n";
while () {
   $from_buffer = $session->getline();
   print $from_buffer;
   $msg = $session->errmsg;
   recon() if ($msg);
}

sub recon {
   print "Error: $msg\n";
   $session->close();
   $session->Net::Telnet::open(Host => $server, Port => $port);
   print $session "user $user pass $passcode vers APRSclient 0.1 filter b/$callsign*\n";
}
