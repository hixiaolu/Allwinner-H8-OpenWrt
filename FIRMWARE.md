# Allwinner H8 OpenWrt 固件使用说明

本文档提供了 Allwinner H8 OpenWrt 固件的详细使用说明，包括账户信息、刷入方法和基本配置。

## 固件信息

- 设备支持: Orange Pi One (Allwinner H8) 及其他基于 H8 的开发板
- 内存支持: 自动检测 1GB/2GB RAM
- 存储支持: EMMC/NAND

## 登录信息

- 默认 IP 地址: `192.168.1.1`
- 默认用户名: `root`
- 默认密码: 无密码，首次登录需设置密码

## 刷入方法

### 准备工作

1. 下载最新的固件文件 `openwrt-[RAM大小]-emmc-burn.img`
2. 准备一张至少 4GB 的 SD 卡或 U 盘
3. 下载刷写工具:
   - Windows: [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/) 或 [balenaEtcher](https://www.balena.io/etcher/)
   - Linux: 可以使用 `dd` 命令
   - macOS: [balenaEtcher](https://www.balena.io/etcher/)

### SD 卡刷入步骤

1. 将 SD 卡连接到电脑
2. 使用刷写工具将固件镜像写入 SD 卡:
   - **Windows (Win32DiskImager)**:
     - 打开 Win32DiskImager
     - 选择固件镜像文件
     - 选择 SD 卡盘符
     - 点击 "Write" 按钮开始刷写
   - **Windows/macOS (balenaEtcher)**:
     - 打开 balenaEtcher
     - 点击 "Flash from file" 选择固件镜像
     - 选择 SD 卡
     - 点击 "Flash!" 开始刷写
   - **Linux**:
     ```bash
     sudo dd if=openwrt-[RAM大小]-emmc-burn.img of=/dev/sdX bs=4M status=progress
     ```
     (将 `/dev/sdX` 替换为您的 SD 卡设备)

3. 刷写完成后，将 SD 卡插入设备并启动

### EMMC 刷入步骤

如果您的设备有 EMMC 存储，并且您希望将系统刷入 EMMC 以获得更好的性能和稳定性:

1. 先按照上述步骤将系统刷入 SD 卡并启动
2. 登录系统 (SSH 或串口连接)
3. 执行以下命令将系统从 SD 卡复制到 EMMC:
   ```bash
   dd if=/dev/mmcblk0 of=/dev/mmcblk1 bs=4M status=progress
   ```
   (注意: 设备名称可能因设备而异，请确认 SD 卡是 mmcblk0，EMMC 是 mmcblk1)
4. 完成后关机，取出 SD 卡，重新启动设备即可从 EMMC 启动

## 首次登录配置

1. 将电脑连接到设备的网络接口
2. 设置电脑 IP 为 192.168.1.x 网段 (例如 192.168.1.100)
3. 打开浏览器访问 `http://192.168.1.1`
4. 首次登录时，系统会要求设置密码
5. 设置密码后，即可进入 OpenWrt 管理界面

## 网络配置

### 基本网络设置

1. 登录 OpenWrt 管理界面
2. 进入 "网络" -> "接口" 页面
3. 点击 "LAN" 接口进行编辑:
   - 可以修改 IP 地址
   - 可以配置 DHCP 服务器
   - 可以设置 DNS 服务器

### 无线网络设置 (如果有无线网卡)

1. 进入 "网络" -> "无线" 页面
2. 点击 "添加" 创建新的无线网络
3. 配置 SSID、加密方式和密码
4. 保存并应用设置

## 硬件特性

### 自动检测 RAM 大小

系统会自动检测设备的 RAM 大小 (1GB 或 2GB)，并根据 RAM 大小优化系统参数。

### EMMC 存储支持

系统会自动检测并挂载 EMMC 存储设备，提供更好的存储性能和稳定性。

## 常见问题

### 无法访问管理界面

- 检查网络连接是否正常
- 确认电脑 IP 地址设置正确
- 尝试 ping 192.168.1.1 测试连通性

### 系统性能问题

- 1GB RAM 设备可能在运行大量应用时出现性能瓶颈
- 建议根据实际需求安装软件包，避免系统资源不足

### 刷入 EMMC 失败

- 确认设备支持 EMMC 存储
- 检查 EMMC 设备是否被正确识别
- 尝试使用其他刷入方法或工具

## 技术支持

如有任何问题或需要技术支持，请通过以下方式联系:

- GitHub Issues: [https://github.com/hixiaolu/Allwinner-H8-OpenWrt/issues](https://github.com/hixiaolu/Allwinner-H8-OpenWrt/issues)
- 提交问题时请提供详细的设备信息和问题描述

## 许可证

本项目采用 MIT 许可证