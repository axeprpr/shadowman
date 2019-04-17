## shadowman
一些不便集成到系统中的脚本或者服务。放在这里

### 安装
下载最新的版本并安装。会多出来一个命令sd

sd -s查看当前支持的服务
```
[root@host016 ~]# sd -s
shadowman -s <service> [action]...
support services:
autossh fileserver frpc
```

sd -c查看当前支持的脚本
```
[root@host016 ~]# sd -c
shadowman -c <service> [action]...
support scripts:
io_bench port_test sys_info
```

### 服务和脚本
服务应用于系统。通过sd开启或关闭。脚本直接通过sd命令浏览和执行。

#### 开启authssh
```
sd -s autossh enable
```
退出当前shell并重新登陆，会多出一个assh命令，用于切换到其他环境
```
[root@host016 ~]# assh
=============== 欢迎使用 Auto SSH ===============
 [1]    host001 [root@192.222.1.1]
 [2]    host002 [root@192.222.1.2]
 [3]    host003 [root@192.222.1.3]
 [4]    host004 [root@192.222.1.4]
 [5]    host005 [root@192.222.1.5]
 [6]    host006 [root@192.222.1.6]
 [7]    host007 [root@192.222.1.7]
 [8]    host008 [root@192.222.1.8]
 [9]    host009 [root@192.222.1.9]
 [10]   host010 [root@192.222.1.10]
==================================================
 [add]  添加      [edit] 编辑      [remove] 删除
 [exit] 退出
==================================================
请输入序号或操作: ^C
```

#### 配置并开启fileserver

配置端口和目录（目录要存在）
```
sd -s fileserver config 
```

开启fileserver
```
sd -s fileserver start
```
此时web访问IP:端口，可以看到一个简单的fileserver，支持上传和下载。
warnning: 暂时不支持enable disable


#### 配置并开启frpc

查看help
```
sd -s frpc
```

配置
```
sd -s frpc config
```

开启frpc
```
sd -s frpc start
```
warnning: 暂时不支持enable disable

#### 一些脚本的执行

简单测试io（/dev/zero）
```
sd -c io_bench 
----------------------------------------------------------------------
I/O speed(1st run)   : 392 MB/s
I/O speed(2nd run)   : 398 MB/s
I/O speed(3rd run)   : 392 MB/s
Average I/O speed    : 394.0 MB/s
----------------------------------------------------------------------
[root@host016 ~]#

```

查看系统信息
```
[root@host016 ~]# sd -c sys_info
----------------------------------------------------------------------
CPU model            : Intel(R) Core(TM) i3-6100 CPU @ 3.70GHz
Number of cores      : 4
CPU frequency        : 3617.328 MHz
Total size of Disk   : 367.9 GB (248.4 GB Used)
Total amount of Mem  : 31972 MB (23284 MB Used)
Total amount of Swap : 16128 MB (1722 MB Used)
System uptime        : 1 days, 23 hour 18 min
Load average         : 1.23, 1.47, 1.54
OS                   : CentOS 7.3.1611
Arch                 : x86_64 (64 Bit)
Kernel               : 3.10.0-514.el7.x86_64
----------------------------------------------------------------------

```

端口检查
```
[root@host016 ~]# sd -c port_test 192.222.1.80:80
port_test: waiting 15 seconds for 192.222.1.80:80
port_test: 192.222.1.80:80 is available after 0 seconds
[root@host016 ~]#

```

#### 开发

##### 编译
```
git clone https://github.com/axeprpr/shadowman.git
cd shadowman
./make.sh
```
##### 代码结构
```
shadowman
├── installation
│   ├── makeself
│   │   ├── COPYING
│   │   ├── makeself.1
│   │   ├── makeself-header.sh
│   │   ├── makeself.lsm
│   │   ├── makeself.sh
│   │   ├── README.md
│   │   └── test
│   │       ├── datetest
│   │       ├── extracttest
│   │       └── tarextratest
│   ├── scripts
│   │   ├── io_bench
│   │   ├── port_test
│   │   └── sys_info
│   ├── services
│   │   ├── autossh
│   │   │   ├── autossh
│   │   │   └── config.json
│   │   ├── fileserver
│   │   │   ├── at_fileserver
│   │   │   └── at_fileserver.ini
│   │   └── frpc
│   │       ├── at_frpc
│   │       ├── at_frpc.ini
│   │       └── VERSION
│   ├── setup.sh
│   ├── shadowman.ini
│   └── shadowman.sh
├── jenkins.sh
├── make.sh
└── README.md
```

##### 增加脚本
直接放到scripts目录即可。

##### 增加服务
需要以目录的形式方到services目录。且需要在shadowman.sh里增加一个函数，配置服务action。


#### todo
frp/fileserver 需要支持开机启动。（enable/disable）
增加其他脚本或服务


