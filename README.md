# Realtek 8192FU Linux USB无线网卡驱动

原始代码来源于: [Internet Archive](https://archive.org/details/realtek-8192fu) 

点击这里：[下载原文件](https://ia801706.us.archive.org/zip_dir.php?path=/18/items/realtek-8192fu.zip) 

---


> ~~原始文档里说支持Linux内核版本`2.6.18 ~ 5.1`。
> 但不支持 Linux 内核`5.1+`以上的版本，也不支持 `RHEL`/`CentOS` `> 7.0`以上的版本。~~

---

> 经过多次修改后，在原来的基础上，增加了对 Linux 内核`5.2 ~ 5.17` 的支持，以及对 `RHEL`/`CentOS` `7.x`/`8.x`的支持。

目前已测试的Linux发行版及结果：

* 已通过：`Red Hat server 7.0`、`CentOS 7.0~7.9/8.3/8.4/8.5`、`Rocky Linux 8.4`、`Ubuntu Server 16.04/18.04/20.04/21.04/21.10`、`Ubuntu Desktop 18.04/20.04`、`linux mint 20.1`、`kali 2021.1`、`archlinux-2021.09.01`、`archlinux-2022.04.01`；

其他未测试的，如果内核版本符合上述要求，通常情况下是可以使用的，但不能完全肯定。

## 使用方式

安装内核头文件

```bash
# ubuntu、kali 用户通过以下命令安装
sudo apt install -y linux-headers-$(uname -r)

# Arch 用户通过以下命令安装
sudo pacman -S linux-headers

# centos 用户通过以下命令安装
sudo yum install -y kernel-headers-$(uname -r) kernel-devel-$(uname -r)
# centos 7.x/8.x 的 yum 源通常只提供对最新发行版的支持，所以像CentOS 7.8等非最新发行版就需要手动到 https://vault.centos.org/7.8.2003/os/x86_64/Packages/kernel-devel-3.10.0-1127.el7.x86_64.rpm 下载rpm文件，然后进行手动安装
```

安装编译器：

```bash
# ubuntu、kali 用户通过以下命令安装
sudo apt install make gcc bc

# Arch 用户通过以下命令安装
sudo pacman -S make gcc bc

# centos 用户通过以下命令安装
sudo yum install make gcc bc elfutils-libelf-devel
```

然后进入驱动代码目录：

```bash
cd rtl8192fu
```

编译并安装：

```bash
make -j$(nproc)

sudo make install
```

装载到内核模块：

```bash
sudo modprobe 8192fu
```

**注意**：USB网卡上的`LED`指示灯可能不会闪烁，但是设备这时候可以使用了。

查看USB接口列表：

```bash
lsusb
```

如果出现`command not found`的问题就需要先安装`usbutils`：

```bash
# ubuntu 用户通过以下命令安装
sudo apt install usbutils

# Arch 用户通过以下命令安装
sudo pacman -S usbutils

# centos 用户通过以下命令安装
sudo yum install usbutils
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
sudo modprobe -r 8192fu
cd rtl8192fu/
sudo make uninstall
```

### 对 `dkms`的支持

> 每次内核更新之后，驱动都需要手动重新编译安装，可能比较麻烦。
>
> 使用`dkms`，可以在更新内核时自动完成驱动的编译和安装。

安装内核头文件

```bash
# ubuntu、kali 用户通过以下命令安装
sudo apt install -y linux-headers-$(uname -r)

# centos 用户通过以下命令安装
sudo yum install -y kernel-headers-$(uname -r) kernel-devel-$(uname -r)
# centos 7.x/8.x 的 yum 源通常只提供对最新发行版的支持，所以像CentOS 7.8等非最新发行版就需要手动到 https://vault.centos.org/7.8.2003/os/x86_64/Packages/kernel-devel-3.10.0-1127.el7.x86_64.rpm 下载rpm文件，然后进行手动安装
```

安装编译器：

```bash
# ubuntu、kali 用户通过以下命令安装
sudo apt install make gcc bc

# centos 用户通过以下命令安装
sudo yum install make gcc bc elfutils-libelf-devel
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
# 赋予可执行权限
sudo chmod a+x ./dkms-*
# 使用 dkms安装驱动
sudo ./dkms-install.sh
# 然后将驱动装载到内核模块
sudo modprobe 8192fu

# 如果需要卸载驱动的话可以使用以下命令
sudo modprobe -r 8192fu
sudo ./dkms-remove.sh
```

