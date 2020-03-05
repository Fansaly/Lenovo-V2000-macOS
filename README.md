[小黑](http://www.lenovo.com.cn/product/50081.html "LENOVO 小新 V2000 Bigger 版") | 型号
:-: | -
主板 | Lenovo Lancer 5A5 `BIOS Version: 9BCN29WW`
主板芯片组 | Intel Lynx Point-LP `南桥`, Intel Haswell `北桥`
CPU | Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz `可睿频至 3.1GHz`
集显 | Intel HD Graphics 4400 `Haswell-ULT GT2`
独显 | NVIDIA GeForce 840M
声卡 | Conexant CX20751/2
有线 | Realtek RTL8168/8111 PCI-E `Realtek RTL8168GU`
无线和蓝牙| Intel 3160 AC &nbsp;--<sup>更换为</sup>-->&nbsp; Broadcom BCM4352 802.11AC
触控板 | ELAN

### 概述
本指南旨在 **Lenovo V2000 Bigger** 笔记本电脑上，步步为营地安装 **macOS Catalina**。

已将原本的无线网卡替换成了 Broadcom BCM94352Z (DW1560)。

此款笔记本电脑的 BIOS 中含有 WiFi 白名单，在更换无线网卡之前，依照 [该指南(英文)](https://www.tonymacx86.com/threads/guide-lenovo-g50-70-and-z50-70-bios-whitelist-removal.187340/) 攻克它。

### BIOS 设置
恢复 BIOS 到默认状态后，再设置：
- UEFI Boot: Enabled
- Secure Boot: Disabled
- Legacy Boot (but UEFI first) (这样在启动时可以有效地减少“花屏”)

提醒：可保持独立显卡在 BIOS 中的启用状态。它将会在运行 macOS 时，被 Hotpatch 编译的 AML 自动禁用。

### 准备 USB、开始安装
1. 打开 `Disk Utility` 将 U盘 抹成 **GUID** 分区方案下的 **APFS** 或 **Mac OS 扩展(日志式)** 分区格式。
> 参考 [![apple logo](logos/apple.svg)](#) [如何抹掉 Mac 磁盘](https://support.apple.com/zh-cn/HT208496)
2. 使用下面的 `createinstallmedia` 命令创建用于引导安装 macOS 的 U盘。其中 `USB_Volume` 为你的 U盘 卷名。
```sh
sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/USB_Volume
```
> 参考 [![apple logo](logos/apple.svg)](#) [如何创建可引导的 macOS 安装器](https://support.apple.com/zh-cn/HT201372)
3. 安装 CloverBootloader 到 U盘，可从 [![Github logo](logos/github.svg)](#) [CloverBootloader](https://github.com/CloverHackyColor/CloverBootloader/releases) 下载最新版本的 CloverBootloader。
4. 将 `RealtekRTL8111.kext` 复制到 U盘 `EFI/CLOVER/kexts/Other`，作为必要的网络支持。
> `RealtekRTL8111.kext` 可从 [![Bitbucket logo](logos/bitbucket.svg)](#) [OS-X-Realtek-Network](https://bitbucket.org/RehabMan/os-x-realtek-network/downloads/) 下载获得
5. 将 `ApplePS2SmartTouchPad.kext` 复制到 U盘 `EFI/CLOVER/kexts/Other`，以驱动键盘和 ELAN 触控板。
> `ApplePS2SmartTouchPad.kext` 位于本仓库的 `Kexts` 目录中
6. 使用本仓库中的 `config.install.plist` 作为安装 macOS 时，U盘 的 `EFI/CLOVER/config.plist`。

### 完成安装后
使用 U盘 的 Clover 引导进入刚安装好的 macOS，  
同样，再次安装 CloverBootloader 到笔记本硬盘。  
接着，依照以下步骤，来完善 macOS。

0. 接入网线，打开 Terminal，安装开发者工具：
```sh
xcode-select --install
```
> 此时会收到系统会提示，根据提示完成安装
1. 下载此项目：
```sh
git clone https://github.com/Fansaly/Lenovo-V2000-macOS
cd Lenovo-V2000-macOS
```
2. 下载 工具、kext 和 hotpatch：
```sh
make download
```
> 可输入 `make download-tools` `make download-kexts` `make download-hotpatch-bplan` 分别单独下载
3. 解压缩上一步下载的文件：
```sh
make unarchive
```
4. 编译生成 DSDT/SSDT aml 文件：
```sh
make
```
5. 安装 DSDT/SSDT aml、kexts 和 drivers：
```sh
make install
```
> 可输入 `make install-aml` `make install-kexts` `make install-drivers` 分别单独安装
6. 手动替换 Clover 的 config.plist：
```sh
efi_dir=$(make mount)
cp config.plist ${efi_dir}/EFI/ClOVER
```
> 替换完成后，应该自定义 **SMBIOS** 中的 **Serial Number**、**Board Serial Number**、**SmUUID**，等等

下载、安装和更新，依赖于 `Config/config.plist`。

### Makefile 其它功能
```sh
make mount              # 挂载 EFI 分区
make backup             # 备份 EFI/CLOVER
make update-kexts       # 检查 kexts 的更新
make upgrade-kexts      # 升级 kexts（下载/安装）
make update-kextcache   # 更新系统 kext 缓存
make update-repo        # 更新本地项目
```
提醒：应当始终保持**本地项目**和 **kexts** 为最新。

### EFI/CLOVER/drivers/UEFI
  - Recommended
    - **FSInject.efi**
  - File System
    - **ApfsDriverLoader.efi**
    - **VBoxHfs.efi**
  - Memory fix
    - **AptioMemoryFix.efi**
  - Custom
    - **VirtualSmc.efi** `由 make install-drivers 安装（无需额外操作）`

&nbsp;

### 电源管理
注意，Hackintosh 不支持 _**写入到磁盘**_ 或 _**S4**_ 的休眠模式。需要禁用它：
```sh
sudo pmset -a hibernatemode 0
sudo rm /var/vm/sleepimage
sudo mkdir /var/vm/sleepimage
```
即使我们巧妙地使用了一个同名的目录来帮助我们禁用它，但是每当系统更新后往往会重新启用它，因此每次系统更新完成之后都需要检查并禁用它。

&nbsp;

### 已知问题
**音频**：在初次安装或者新增、更新 kext 之后，声卡可能不工作。
> 修复方法：正常重启（如果需要，可以重启多次）

&nbsp;

### 致谢
acidanthera, lvs1974, RehabMan, the-braveknight, vit9696, etc.
