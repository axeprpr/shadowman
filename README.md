## 一些运维的脚本，不便集成到系统中。放在这里

## 使用说明

下载最新的版本并安装。会多出来一个命令sd

第一个入参支持两种：
1. 一种是服务、工具的开启，停止。
2. 一种是直接执行某个脚本

举例，开启autossh功能：
```
sd -s autossh enable
```

举例，执行io_bench：
```
sd -c io_bench
```

目前支持的服务：
1. frpc
2. autossh
3. fileserver

目前支持的脚本：
1. io_bench
2. sys_info
3. port_test