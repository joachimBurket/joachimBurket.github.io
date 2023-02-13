---
title: logrotate configurations
tags: sysadmin linux logs
---

Some details about interesting configs of logrotate.

<!--more-->

Useful documentation:
* Man page: https://linux.die.net/man/8/logrotate
* Github repo: https://github.com/logrotate/logrotate

As its name suggests, logrotate is an tool that rotates log. If not rotated, the logs on a server will grow indefinitly, which will be a problem for your not infinite storage.

## Installing logrotate

Logrotate could be already installed in the server. Test it with:

```bash
logrotate --version
```

If logrotate is not installed:

```bash
sudo yum install logrotate
```

Logrotate configuration file is placed in `/etc/logrotate.conf`. It contains the default behaviour of logrotate.

Logrotate is generally runned daily by [cron](https://en.wikipedia.org/wiki/Cron):

```bash
cat /etc/cron.daily/logrotate
```

## Logrotate configuration file

In order to rotate some logs, create a logrotate configuration file in `/etc/logrotate.d/<my-app>`. Here is an example of logrotate config file:

```
# Rotate this log file. It can also be a wildcard. E.g. /var/log/myapp/*.log
/var/log/myapp.log
{
    missingok
    notifempty
    weekly
    maxsize 100M
    rotate 4
    compress
    delaycompress
    dateext
    sharedscripts
    postrotate
        /usr/bin/systemctl kill -s HUP rsyslog.service >/dev/null 2>&1 || true
    endscript
}
```

Here are some useful configuration parameters:

* `missingok`: Don't log an error in logrotate logs if the log file is missing
* `notifempty`: Don't rotate if the log file is empty
* `weekly`: Rotate the file once a week
* `maxsize 100M`: If the file's size exceed 100M, rotate the file. Even if the rotation period (in this case 'weekly') isn't reached
* `rotate 4`: Number of rotation (in this case, keeps 4 rotation files, and removes the older)
* `compress`: Compress the rotation files with gzip
* `delaycompress`: Postpone the compression of the previous log file to the next rotation cycle. This can prevent loosing some logs when doing the compression
* `dateext`: Add a date extension (YYYYMMDD) to the rotation files. The format can be configured with `dateformat` option
* `sharedscripts`: Tells logrotate to run the *prerotate* and *postrotate* only once, even if multiple log files are rotated
* `postrotate/endscript`: Execute the lines between `postrotate` and `endscript` with `/bin/sh` after the log file is rotated
* `copytruncate`: Truncate the original log file in place after creating a copy, instead of moving the old log file and optionally creating a new one. It can be used when some program cannot be told to close its logfile and thus might continue writing (appending) to the previous log file forever.

Because generally the programs running keep the log file opened while they are running, they need to be told to re-open them when the log file is rotated. Otherwise, after the log file is rotated, the service will continue to write to this one. That's the utility of the postrotate script.
Generally, programs will listen to the HUP signal, and re-open the files when they receive it (but it depends on the program).
If the program is writing the logs through `syslog`, it's to the syslog service that the HUP signal must be sent.
If it's not possible to make the program reload the log file, the `copytruncate` configuration can be set.
{:.info}


