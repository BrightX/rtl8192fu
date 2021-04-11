# Realtek 8192FU Linux USB无线网卡驱动

原始代码来源于: [Internet Archive](https://archive.org/details/realtek-8192fu) 

点击这里：[下载原文件](https://ia801706.us.archive.org/zip_dir.php?path=/18/items/realtek-8192fu.zip) 

---


> 原始文档里说支持Linux内核版本`2.6.18 ~ 5.1`。
> 依据我目前测试情况来看，支持`Ubuntu Server 18.04.5`(内核`4.15`)。但不支持`Ubuntu Desktop 18.04.5`(内核`5.4`)，也不支持`CentOS 7`(内核`3.10`)和`CentOS 8`(内核`4.18`)。
> 目前只测试了以上几种环境(均为`x86_64`架构)，其它情况没有测试。


## 使用方式

支持的环境：

* **Ubuntu Server 18.04.5** 内核`4.15` 
* **Centos 7** 内核`3.10` 
* **Kali 2019.2** 内核`4.18` 

安装内核环境

```bash
# ubuntu、kali 用户通过以下命令安装
sudo apt install -y linux-headers-$(uname -r)
# centos 用户通过以下命令安装
sudo yum install -y kernel-headers kernel-devel
```

安装编译器：

```bash
# ubuntu、kali 用户通过以下命令安装
sudo apt install gcc make
# centos 用户通过以下命令安装
sudo yum install gcc make
```

然后进入驱动代码目录：

```bash
cd rtl8192fu
```

编译并安装：

```bash
make

sudo make install
```

装载到内核模块：

```bash
sudo modprobe 8192fu
```

**注意**：USB网卡上的`LED`指示灯可能不会闪烁，但是设备这时候可以使用了。

安装USB工具：

```bash
# ubuntu 用户通过以下命令安装
sudo apt install usbutils
# centos 用户通过以下命令安装
sudo yum install usbutils
```

查看USB接口列表：

```bash
lsusb
```

查看USB设备信息：

```bash
usb-devices | grep "Vendor=0bda ProdID=f192" -B2 -A5
```

**关键信息看最后一行**: `Driver=rtl8192fu` 则说明该设备已经跟驱动匹配上了；`Driver=(none)` 则说明没有找到设备对应的驱动。

驱动跟设备匹配成功的情况：

```bash
T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  5 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=f192 Rev=02.00
S:  Manufacturer=Realtek
S:  Product=802.11n  WLAN Adapter
S:  SerialNumber=60EE5CBDFDE9
C:  #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 8 Cls=ff(vend.) Sub=ff Prot=ff Driver=rtl8192fu
```

驱动匹配失败的情况：

```bash
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=f192 Rev=02.00
S:  Manufacturer=Realtek
S:  Product=802.11n  WLAN Adapter
S:  SerialNumber=60EE5CBDFDE9
C:  #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 8 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
```

成功之后，就可以去配置无线网络了。

驱动的卸载：

```bash
sudo rmmod rtl8192fu
cd rtl8192fu/
sudo make uninstall
```

### 对 `dkms`的支持

> 每次内核更新之后，驱动都需要手动重新编译安装，可能比较麻烦。
>
> 使用`dkms`，可以在更新内核时自动完成驱动的编译和安装。

安装内核环境

```bash
# ubuntu、kali 用户通过以下命令安装
sudo apt install -y linux-headers-$(uname -r)
# centos 用户通过以下命令安装
sudo yum install -y kernel-headers kernel-devel
```

安装`dkms` 

```bash
# ubuntu、kali 用户通过以下命令安装
sudo apt install build-essential dkms -y
# centos 用户通过以下两条命令安装
sudo yum install epel-release -y
sudo yum install dkms -y
```

使用：

```bash
# 进入驱动源码目录
cd rtl8192fu/
# 使用 dkms安装驱动
sudo ./dkms-install.sh

# 如果需要卸载驱动的话可以使用以下命令
sudo ./dkms-remove.sh
```

装载驱动到内核模块：

```bash
sudo modprobe 8192fu
```

