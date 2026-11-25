# 以下内容添加至 uci-defaults 文件的 echo "All done!" 下方
# ================= 首次开机自动扩容：p2 -> 4096 MiB =================
DISK=/dev/mmcblk0
PART=/dev/mmcblk0p2
TARGET=4096
DONE=/etc/.rootfs-4g
P1DONE=/etc/.rootpt-4g

log() { logger -t growfs "$1" 2>/dev/null; echo "growfs: $1" > /dev/kmsg 2>/dev/null; }

part_end() {
	parted -s -m "$DISK" unit MiB print 2>/dev/null |
		awk -F: '$1 == "2" { gsub(/MiB/, "", $3); print int($3) }'
}

# 已完成：只体检，不再改动
if [ -e "$DONE" ]; then
	KB=$(df -k / 2>/dev/null | awk 'NR==2 { print $2 }')
	if [ "${KB:-0}" -lt 3500000 ]; then
		log "ERROR: / is ${KB}K, resize did not take effect; try: rm $DONE $P1DONE"
	fi
	exit 0
fi

# 预检
for c in parted losetup resize2fs e2fsck; do
	command -v "$c" >/dev/null 2>&1 || { log "ERROR: $c not found, add it to the image"; exit 1; }
done
[ -b "$DISK" ] && [ -b "$PART" ] || { log "ERROR: $DISK or $PART missing"; exit 1; }
modprobe loop 2>/dev/null

# 阶段 1：分区只增不减，以磁盘实际结果判断成功
if [ ! -e "$P1DONE" ]; then
	CUR=$(part_end)
	if [ "${CUR:-0}" -lt $((TARGET - 8)) ]; then
		log "step 1/2: resizepart 2 -> ${TARGET} MiB (now ${CUR:-?})"
		parted -s -f "$DISK" unit MiB resizepart 2 "$TARGET" >/dev/null 2>&1
		CUR=$(part_end)
	fi
	if [ "${CUR:-0}" -ge $((TARGET - 8)) ]; then
		sync
		touch "$P1DONE" || exit 1
		cp /tmp/setup.log /root/setup.log 2>/dev/null
		sync
		reboot
	fi
	log "ERROR: p2 ends at ${CUR:-?} MiB, expected ${TARGET}; retry next boot"
	exit 1
fi

# 阶段 2：扩 ext4
log "step 2/2: resize ext4 on $PART"
touch "$DONE" || exit 1
cp /tmp/setup.log /root/setup.log 2>/dev/null
mount -o remount,ro / || { rm -f "$DONE"; log "ERROR: cannot remount / ro"; exit 1; }

LOOP=$(losetup -f 2>/dev/null)
[ -n "$LOOP" ] || { mount -o remount,rw /; rm -f "$DONE"; log "ERROR: no free loop device"; exit 1; }
losetup "$LOOP" "$PART" || { mount -o remount,rw /; rm -f "$DONE"; log "ERROR: losetup failed"; exit 1; }

e2fsck -f -y "$LOOP" >/dev/null 2>&1; RC=$?
if [ $((RC & ~3)) -ne 0 ]; then
	losetup -d "$LOOP" 2>/dev/null
	log "ERROR: e2fsck rc=$RC, not resizing"
	reboot
fi

resize2fs -f "$LOOP" >/dev/null 2>&1; RC=$?
if [ "$RC" -ne 0 ]; then
	losetup -d "$LOOP" 2>/dev/null
	log "ERROR: resize2fs rc=$RC (rm $DONE $P1DONE and reboot to retry)"
	reboot
fi

e2fsck -f -y "$LOOP" >/dev/null 2>&1
losetup -d "$LOOP" 2>/dev/null
sync
reboot