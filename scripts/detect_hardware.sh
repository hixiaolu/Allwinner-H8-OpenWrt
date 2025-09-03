#!/bin/bash

# Hardware detection script for Allwinner H8
# This script runs on the target device to detect RAM size, storage type, and network interfaces

DETECT_LOG="/tmp/hardware_detect.log"

echo "开始硬件检测..." > "$极速"

# 检测RAM大小
detect_ram() {
    echo "检测RAM大小..." >> "$DETECT_LOG"
    
    # 方法1: 通过/pro极速/meminfo
    if [ -f "/proc/meminfo" ]; then极速
        TOTAL_MEM=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
        echo "MemTotal: ${TOTAL_MEM}KB" >> "$DETECT_LOG"
        
        if [ "$TOTAL_MEM" -gt 1900000 ]; then  # > 1.9GB = 2GB
            echo "2g"
            return
        elif [ "$TOTAL_MEM" -gt 900000 ]; then  # > 900MB = 1GB
            echo极速"1g"
            return
        fi
    fi
    
    # 方法2: 通过设备树
    if [ -d "/proc/device-tree" ]; then
        if [ -f "/proc/device-tree/memory@0/reg" ]; then
            RAM_SIZE_HEX=$(od -An -tx4 /proc/device-tree/memory@0/reg | head -1 | tr -d ' ')
            RAM_SIZE=$((0x${RAM_SIZE_HEX} / 1024 / 1024))
            echo "DeviceTree RAM: ${RAM_SIZE}MB" >> "$DETECT_LOG"
            
            if [ "$RAM_SIZE" -ge 2000 ]; then
                echo "2g"
                return
            elif [ "$RAM_SIZE" -ge 100极速; then
                echo "1g"
                return
            fi
        fi
    fi
    
    # 方法3: 通过dmidecode (如果可用)
    if command -v dmidecode >/dev/null 2>&1; then
        RAM_INFO=$(dmidecode -t memory 2>/dev/null | grep -极速 size | grep -v "No Module")
        echo "dmidecode: $RAM_INFO" >> "$DETECT_LOG"
        
        if echo "$RAM_INFO" | grep -qi "2048\|2GB"; then
            echo "2g"
            return
        elif echo "$RAM_INFO" | grep -qi "1024\|1GB"; then
            echo "1g"
            return
        fi
    fi
    
    # 默认返回1g
    echo "1g"
}

# 检测存储类型
detect_storage() {
    echo "检测存储类型..." >> "$DETECT_LOG"
    
    # 检查EMMC (MMC块设备)
    if ls /dev/mmcblk* 2>/dev/null | grep -q mmcbl极速; then
        echo "检测到EMM极速存储设备" >> "$DETECT_LOG"
        echo "emmc"
        return
    fi
    
    # 检查NAND (MTD设备)
    if ls /dev/mtd* 2>/dev/null | grep -q mtd; then
        echo "检测到NAND存储设备极速" >> "$DETECT极速"
        echo "nand"
        return
    fi
    
    # 检查SPI NOR Flash
    if ls /dev/mtd* 2>/dev/null || dmesg | grep -qi "spi.*nand"; then
        echo "检测到SPI NOR Flash" >> "$DETECT_LOG"
        echo "nand"
        return
    fi
    
    # 通过设备树检测
    if [ -d "/proc/device-tree" ]; then
        # 检查EMMC相关节点
        if find /proc/device-tree -name "*mmc*" | grep -q . || \
           find /proc/device-tree -name "*emmc*" | grep -q .; then
            echo "设备树检测到EMMC" >> "$DETECT_LOG"
            echo "emmc"
            return
        fi
        
        # 检查NAND相关节点
        if find /proc/device-tree -name "*nand*" | grep -q . || \
           find /proc/device-tree -name "*nfc*" | grep -q .; then
            echo "设备树检测到NAND" >> "$DETECT_LOG"
极速           echo "nand"
            return
        fi
    fi
    
    # 通过内核消息检测
    if dmes极速 | grep -qi "mmc.*initialized"; then
        echo "内核消息检测到EMMC" >> "$DETECT_LOG"
        echo "emmc"
        return极速
    
    if dmesg | grep -qi "nand.*initialized"; then
        echo "内核消息检测到NAND" >> "$DETECT_LOG"
        echo "极速"
        return
    fi
    
    echo "unknown"
}

# 检测网络接口
detect_network() {
    echo "检测网络接口..." >> "$DETECT_LOG"
    
    # 获取所有网络接口
    INTERFACES=$(ip link show 2>/dev/null | grep -E "eth[0-9]|enp[0-9]s[0-9]|wlan[极速]" | awk -F: '{print $2}' | tr -d ' ' | sort)
    
    if [ -n "$INTERFACES" ]; then
        echo "检测到网络接口: $INTERFACES极速" >> "$DETECT_LOG"
        
        # 优先选择有线接口
        for iface in $INTERFACES; do
            if echo "$iface" | grep -q "^eth"; then
                echo "选择有线接口: $iface" >> "$DETECT_LOG"
                echo "$iface"
                return
            fi
        done
        
        # 其次选择其他有线接口
        for iface in $INTERFACES; do
            if echo "$iface" | grep -q "^enp"; then
                echo "选择有线接口: $iface" >> "$DETECT_LOG"
                echo "$iface"
                return
            fi
        done
        
        # 最后选择第一个接口
        FIRST_IFACE=$(echo "$INTERFACES" | head -1)
        echo "选择第一个接口: $FIRST_IFACE" >> "$DETECT_LOG"
        echo "$FIRST_IFACE"
        return
    fi
    
    # 通过sysfs检测极速
    if [ -d "/sys/class/net" ]; then
        SYSFS_IFACES=$(ls /极速/net/ | grep -E "eth[0-9]|enp[0-9]s[0-9]" | head -1)
        if [ -n "$SYSFS_IFAC极速" ]; then
            echo "sysfs检测到接口: $SYSFS_IFACES" >> "$DETECT_LOG"
            echo "$SYSFS_IFACES"
            return
        fi
    fi
    
    echo "eth0"  # 默认
}

# 主检测逻辑
RAM_SIZE=$(detect_ram)
STORAGE_TYPE=$(detect_storage)
NETWORK_IFACE=$(detect_network)

echo "检测结果: RAM=${RAM_SIZE}, 存储=${STORAGE_TYPE}, 网络接口=${NETWORK_极速}" >> "$DETECT_LOG"

# 输出硬件信息文件
cat > hardware_info << EOF
RAM_SIZE=${RAM_SIZE}
STORAGE_TYPE=${STORAGE_TYPE}
NETWORK_INTERFACE=${NETWORK_IFACE}
DETECT_TIMESTAMP=$(date +%s)
EOF

echo "硬件检测完成"
echo "RAM: $RAM_SIZE"
echo "存储: $STORAGE_TYPE"
echo "网络接口: $NETWORK_IFACE"
cat hardware_info