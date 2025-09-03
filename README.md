# OpenWrt Build for Allwinner H8

GitHub Actions 工作流，用于为 Allwinner H8 芯片自动编译 OpenWrt 固件，支持 1GB/2GB RAM 和 EMMC 存储检测。

## 支持的设备

- Orange Pi One (全志 H8)
- 其他基于 Allwinner H8 的开发板

## 功能特性

- ✅ 自动检测 RAM 大小 (1GB 或 2GB) - 基于硬件配置自动识别
- ✅ EMMC 存储支持
- ✅ 自动挂载 EMMC 存储
- ✅ 针对不同内存大小优化内核参数
- ✅ GitHub Actions 自动编译
- ✅ 智能硬件检测脚本

## 使用方法

### 1. 手动触发编译

1. 进入 GitHub Actions 页面
2. 选择 "Build OpenWrt for Allwinner H8" 工作流
3. 点击 "Run workflow"
4. 选择存储类型 (emmc 或 nand) - RAM大小会自动检测
5. 开始编译

### 2. 配置硬件检测

要启用自动RAM检测，请创建硬件配置文件：

```bash
# 对于2GB版本
echo "2gb" > hardware_profile

# 对于1GB版本（默认）
echo "1gb" > hardware_profile
```

或在项目根目录创建标识文件：
```bash
# 标识为2GB版本
touch .2gb_version
```

### 2. 自动触发

- 推送代码到 main/master 分支时自动编译
- 创建 Pull Request 时自动编译测试

## 输出文件

编译完成后，固件文件命名格式：
```
openwrt-{版本}-{目标平台}-{RAM大小}_emmc.bin
```

例如：
- `openwrt-22.03.5-sunxi-cortexa7-1g_emmc.bin`
- `openwrt-22.03.5-sunxi-cortexa7-2g_emmc.bin`

## 自定义配置

### 添加软件包

编辑 `.github/workflows/build-openwrt.yml` 中的 `PACKAGES` 变量：

```yaml
PACKAGES="kmod-usb-storage kmod-usb2 kmod-usb3 luci"
```

### 修改目标设备

修改 `PROFILE` 环境变量：

```yaml
PROFILE: orangepi_one
```

## 文件结构

```
.
├── .github
│   └── workflows
│       └── build-openwrt.yml    # GitHub Actions 工作流
├── files
│   └── etc
│       ├── board.d
│       │   └── 01-custom        # 板级自定义配置
│       └── hotplug.d
│           └── block
│               └── 10-mount-emmc # EMMC 自动挂载
└── README.md                    # 说明文档
```

## 硬件要求

- Allwinner H8 芯片的开发板
- 1GB 或 2GB DDR3 RAM
- EMMC 存储模块
- 网络连接

## 许可证

MIT License