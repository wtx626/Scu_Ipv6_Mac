#!/bin/sh 
#清除IPV6路由表
sudo route delete -inet6 default
sudo ifconfig gif0 destroy
#取本地的ip地址，网卡名不一样的自己看着改
#下面的isatap隧道地址写死了，如果你是别的学校的可以自己改那个222.22.32.161...(应该都看得懂
#再啰嗦一句 ipv6头可以在Windows下获取一次然后得出。。。前面是固定的，后面是你的内网IP地址- -

EN0_IP=`/sbin/ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}'` 
EN1_IP=`/sbin/ifconfig en1 | grep inet | grep -v inet6 | awk '{print $2}'`
EN2_IP=`/sbin/ifconfig en2 | grep inet | grep -v inet6 | awk '{print $2}'` 
EN4_IP=`/sbin/ifconfig en4 | grep inet | grep -v inet6 | awk '{print $2}'` 

if [ -n "$EN0_IP" ]; then
    LOCAL_IP=$EN0_IP 
elif [ -n "$EN1_IP" ];then
    LOCAL_IP=$EN1_IP 
elif [ -n "$EN2_IP" ];then
    LOCAL_IP=$EN2_IP  
elif [ -n "$EN4_IP" ];then
    LOCAL_IP=$EN4_IP 
fi 
echo $LOCAL_IP


if [ -n "$LOCAL_IP" ]; then 
    #sudo /sbin/ifconfig gif0 tunnel $LOCAL_IP 202.115.39.98 
    #sudo /sbin/ifconfig gif0 inet6 2001:250:2003:2010:200:5efe:$LOCAL_IP prefixlen 64 
    #sudo /sbin/route delete -inet6 default
    #sudo /sbin/route add -inet6 default 2001:da8:200:900e::1 
	sudo ifconfig gif0 create
	sudo ifconfig gif0 tunnel $LOCAL_IP 202.115.39.98
	#sudo ifconfig gif0 inet6 2001:250:2003:2010:200:5efe:$LOCAL_IP prefixlen 64
	sudo ipconfig set gif0 MANUAL-V6 2001:250:2003:2010:200:5efe:$LOCAL_IP 64
	sudo route add -inet6 ::/0 -interface gif0
	#sudo route add -inet6 default 2001:da8:200:900e::1 
fi