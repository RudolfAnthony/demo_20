#!/system/bin/sh

OUTPUT_FILE="/storage/emulated/0/DeviceInfo.txt"

echo "正在获取设备信息..." >&2

rm -f "$OUTPUT_FILE"

{
echo "====================================="
echo "Android Device Information"
echo "====================================="
echo ""

echo "[1] 基本设备信息"
echo "-------------------------------------"
echo "[1.1] 设备品牌: $(getprop ro.product.brand)"
echo "[1.2] 设备型号: $(getprop ro.product.model)"
echo "[1.3] 设备名称: $(getprop ro.product.name)"
echo "[1.4] 设备代号: $(getprop ro.product.device)"
echo "[1.5] 主板: $(getprop ro.product.board)"
echo "[1.6] 硬件: $(getprop ro.hardware)"
echo "[1.7] 制造商: $(getprop ro.product.manufacturer)"
echo ""

echo "[2] Android系统信息"
echo "-------------------------------------"
echo "[2.1] Android版本: $(getprop ro.build.version.release)"
echo "[2.2] API级别: $(getprop ro.build.version.sdk)"
echo "[2.3] 构建ID: $(getprop ro.build.id)"
echo "[2.4] 构建类型: $(getprop ro.build.type)"
echo "[2.5] 构建标签: $(getprop ro.build.tags)"
echo "[2.6] 构建指纹: $(getprop ro.build.fingerprint)"
echo "[2.7] 安全补丁级别: $(getprop ro.build.version.security_patch)"
echo "[2.8] 基带版本: $(getprop gsm.version.baseband)"
echo ""

echo "[3] 硬件信息"
echo "-------------------------------------"
echo "[3.1] CPU架构: $(getprop ro.product.cpu.abi)"
echo "[3.2] CPU架构2: $(getprop ro.product.cpu.abi2)"
echo "[3.3] 支持的ABI: $(getprop ro.product.cpu.abilist)"
echo "[3.4] CPU信息:"
cat /proc/cpuinfo | grep -E "processor|model name|Hardware|Features" | sed 's/^/    /'
echo "[3.5] 内存信息:"
cat /proc/meminfo | head -10 | sed 's/^/    /'
echo "[3.6] 存储信息:"
df -h | grep -E "/data|/system|/storage" | sed 's/^/    /'
echo ""

echo "[4] 网络信息"
echo "-------------------------------------"
echo "[4.1] WiFi状态: $(getprop wifi.interface)"
echo "[4.2] 移动数据状态: $(getprop gsm.radio.available)"
echo "[4.3] 网络类型: $(getprop gsm.network.type)"
echo "[4.4] 运营商: $(getprop gsm.operator.alpha)"
echo "[4.5] WiFi SSID: $(dumpsys wifi | grep "mNetworkInfo" | grep -o "SSID.*" 2>/dev/null || echo "不可用")"
echo ""

echo "[5] 显示信息"
echo "-------------------------------------"
echo "[5.1] 屏幕分辨率: $(dumpsys window displays | grep -E "cur=" | head -1)"
echo "[5.2] 显示密度: $(getprop ro.sf.lcd_density)"
echo "[5.3] 屏幕方向: $(dumpsys input | grep -i "orientation" | head -1)"
echo ""

echo "[6] 电池信息"
echo "-------------------------------------"
dumpsys battery | sed 's/^/[6.1] /'
echo ""

echo "[7] 传感器信息"
echo "-------------------------------------"
echo "[7.1] 可用传感器:"
dumpsys sensorservice | grep -A 20 "Sensors List:" | grep -E "name|vendor|version" | sed 's/^/    /'
echo ""

echo "[8] 应用和包信息"
echo "-------------------------------------"
echo "[8.1] 已安装包数量: $(pm list packages | wc -l)"
echo "[8.2] 系统应用:"
pm list packages -s | head -20 | sed 's/^/    /'
echo "    ... (仅显示前20个)"
echo ""

echo "[9] 系统属性"
echo "-------------------------------------"
echo "[9.1] 完整系统属性 (部分):"
getprop | head -50 | sed 's/^/    /'
echo "    ... (仅显示前50个)"
echo ""

echo "[10] 其他信息"
echo "-------------------------------------"
echo "[10.1] 启动时间: $(cat /proc/uptime)"
echo "[10.2] 内核版本: $(uname -a)"
echo "[10.3] Shell环境: $SHELL"
echo "[10.4] 用户: $(whoami)"
echo "[10.5] Root权限: $(if [ $(id -u) -eq 0 ]; then echo "是"; else echo "否"; fi)"
echo ""

echo "====================================="
echo "信息获取完成: $(date)"
echo "====================================="

} > "$OUTPUT_FILE"

echo "设备信息已保存到: $OUTPUT_FILE"
echo "共获取 $(grep -c '\[' "$OUTPUT_FILE") 条信息"
