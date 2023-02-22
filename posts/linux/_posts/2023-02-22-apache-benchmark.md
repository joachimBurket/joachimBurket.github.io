---
title: Apache Benchmark
tags: sysadmin linux
---

Some details about Apache Benchmark tool.

<!--more-->

Useful documentation:
* Man page: [https://httpd.apache.org/docs/2.4/programs/ab.html]([https://linux.die.net/man/8/logrotate](https://httpd.apache.org/docs/2.4/programs/ab.html))

[Apache Benchmark](https://httpd.apache.org/docs/2.4/programs/ab.html) (also named **ab**) is a tool for benchmarking HTTP servers. It is very useful to simulate load on a server and see how it reacts.

## Installation

To install ab on Linux:

```bash
# On debian based distrib
sudo apt install apache2-utils

# On fedora/centos/rhel distrib
sudo yum install httpd-tools
```

Check the installed version

```bash
ab -V
```

## Usage

Here is the usage of `ab`:

```bash
ab [options] [http[s]://]hostname[:port]/path
```

The Hostname/IP **must** end with a trailing slash!{:.info}

The most useful options of `ab` are:

* `-n <requests>`: Number of requests to perform
* `-c <concurrency>`: Number of concurrent requests to perform
* `-t <timelimit>`: Maximum number of second the benchmark will run. The benchmark will stop even if the number of requests isn't reached within this time.
* `-H <header>`: Add an HTTP header to the requests (e.g. `"Accept: application/json"`). Can be used multiple times

Get the full options list with `man ab`.

Requests examples:

```bash
# Benchmark 1000 requests, with 15 concurrent requests, during at most 10 seconds
ab -t 10 -n 1000 -c 15 https://my-server.com/

# Same benchmark, sending POST to endpoint with authentication
ab -t 10 -n 1000 -c 15 -H "Authorization: Bearer $API_TOKEN" -T "application/json" -p data.json https://my-server.com/api/v1/endpoint
```

Result example:

```bash
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking my-server.com (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Finished 500 requests


Server Software:        gunicorn
Server Hostname:        my-server.com
Server Port:            443
SSL/TLS Protocol:       TLSv1.2,ECDHE-RSA-AES128-GCM-SHA256,4096,128
Server Temp Key:        X25519 253 bits
TLS Server Name:        my-server.com

Document Path:          /api/v1/endpoint
Document Length:        39 bytes

Concurrency Level:      10
Time taken for tests:   3.129 seconds
Complete requests:      500
Failed requests:        0
Total transferred:      206000 bytes
Total body sent:        157500
HTML transferred:       19500 bytes
Requests per second:    159.80 [#/sec] (mean)
Time per request:       62.577 [ms] (mean)
Time per request:       6.258 [ms] (mean, across all concurrent requests)
Transfer rate:          64.30 [Kbytes/sec] received
                        49.16 kb/s sent
                        113.45 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        9   15   5.1     14      38
Processing:    14   46   8.9     46      87
Waiting:       14   45   9.0     46      87
Total:         25   62   9.1     61     105

Percentage of the requests served within a certain time (ms)
  50%     61
  66%     65
  75%     68
  80%     69
  90%     72
  95%     76
  98%     82
  99%     85
 100%    105 (longest request)
```
