#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# 这个文件在feeds安装后执行
#

# 修改默认IP
# sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# 修改主机名
sed -i 's/OpenWrt/AllwinnerH8/g' package/base-files/files/bin/config_generate

# 修改默认主题
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 添加硬件检测脚本到启动项
mkdir -p package/base-files/files/etc/init.d/
cat > package/base-files/files/etc/init.d/hardware_detect << 'EOF'
#!/bin/sh /etc/rc.common

START=99
STOP=99

start() {
    echo "启动硬件检测..."
    /bin/sh /usr/bin/detect_hardware.sh &
}

stop() {
    echo "停止硬件检测..."
}
EOF

chmod +x package/base-files/files/etc/init.d/hardware_detect

# 复制硬件检测脚本
mkdir -p package/base-files/files/usr/bin/
cp ../scripts/detect_hardware.sh package/base-files/files/usr/bin/
chmod +x package/base-files/files/usr/bin/detect_hardware.sh