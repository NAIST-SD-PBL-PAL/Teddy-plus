This docker-compose config is tested on Docker version 20.10.2, build 2291f61 and docker-compose version 1.27.4, build 40524192. 

In princple, all newer versions should work properly. 

Make sure you have all the files from this directory and Docker and docker-compose must be installed.

To use bind mount, replace your own directory path : `/home/yourpath/results:/home/teddy/results` 

To run against a particular git repository, simple run command `./master.sh {URL} {Interval}`. Interval is optional.

example `./master.sh https://github.com/horovod/horovod.git '-a 2021-02-01 -b 2021-02-07'`
