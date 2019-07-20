#!/system/bin/sh
# Loony kernel post boot script
# Moto G4 (athene) - msm8952

arch=`uname -m`
ram_size=`cat /proc/meminfo | grep MemTotal`
ram=${ram_size:16:8}

echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus

# HMP scheduler settings
echo 3 > /proc/sys/kernel/sched_window_stats_policy
echo 3 > /proc/sys/kernel/sched_ravg_hist_size

# HMP task packing settings
echo 20 > /proc/sys/kernel/sched_small_task
echo 30 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_load
echo 30 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_load
echo 30 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_load
echo 30 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_load
echo 30 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_load
echo 30 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_load
echo 30 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_load
echo 30 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_load

echo 3 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_nr_run

echo 0 > /sys/devices/system/cpu/cpu0/sched_prefer_idle
echo 0 > /sys/devices/system/cpu/cpu1/sched_prefer_idle
echo 0 > /sys/devices/system/cpu/cpu2/sched_prefer_idle
echo 0 > /sys/devices/system/cpu/cpu3/sched_prefer_idle
echo 0 > /sys/devices/system/cpu/cpu4/sched_prefer_idle
echo 0 > /sys/devices/system/cpu/cpu5/sched_prefer_idle
echo 0 > /sys/devices/system/cpu/cpu6/sched_prefer_idle
echo 0 > /sys/devices/system/cpu/cpu7/sched_prefer_idle

# Turn off scheduler boost
echo 0 > /proc/sys/kernel/sched_boost

# Disable thermal & BCL core_control to update interactive gov settings
echo 0 > /sys/module/msm_thermal/core_control/enabled

# Enable governor for perf cluster
echo 1 > /sys/devices/system/cpu/cpu0/online
echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "0 1344000:20000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
echo 90 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
echo 40000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
echo 160000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
echo "80 960000:85 1344000:90 1516800:95" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
echo 499200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1516000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

# Enable governor for power cluster
echo 1 > /sys/devices/system/cpu/cpu4/online
echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo "0 998400:20000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
echo 90 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
echo 160000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
echo 806400 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
echo "80 806400:85 998400:90 1209600:95" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
echo 403200 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq

# Bring up all cores online
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu5/online
echo 1 > /sys/devices/system/cpu/cpu6/online
echo 1 > /sys/devices/system/cpu/cpu7/online

# HMP scheduler (big.Little cluster related) settings
echo 93 > /proc/sys/kernel/sched_upmigrate
echo 83 > /proc/sys/kernel/sched_downmigrate

# Enable sched guided freq control
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
echo 50000 > /proc/sys/kernel/sched_freq_inc_notify
echo 50000 > /proc/sys/kernel/sched_freq_dec_notify

# Enable core control
echo 2 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/max_cpus
echo 70 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
echo 45 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
echo 100 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster

# Re-enable thermal & BCL core_control now
echo 1 > /sys/module/msm_thermal/core_control/enabled

# Enable dynamic clock gating
echo 1 > /sys/module/lpm_levels/lpm_workarounds/dynamic_clock_gating
# Enable timer migration to little cluster
echo 1 > /proc/sys/kernel/power_aware_timer_migration

# Set GPU default power level to 240MHz
echo 4 > /sys/class/kgsl/kgsl-3d0/default_pwrlevel

# Set memory parameters
echo 1 > /sys/module/process_reclaim/parameters/enable_process_reclaim
echo 70 > /sys/module/process_reclaim/parameters/pressure_max
echo 30 > /sys/module/process_reclaim/parameters/swap_opt_eff
echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
if [ "$arch" == "aarch64" ] && [ $ram -gt 2097152 ]; then
	echo 10 > /sys/module/process_reclaim/parameters/pressure_min
	echo 1024 > /sys/module/process_reclaim/parameters/per_swap_size
	echo "18432,23040,27648,32256,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree
	echo 81250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
elif [ "$arch" == "aarch64" ] && [ $ram -le 2097152 ]; then
	echo 10 > /sys/module/process_reclaim/parameters/pressure_min
	echo 1024 > /sys/module/process_reclaim/parameters/per_swap_size
	echo "14746,18432,22118,25805,40000,55000" > /sys/module/lowmemorykiller/parameters/minfree
	echo 81250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
else
	echo 50 > /sys/module/process_reclaim/parameters/pressure_min
	echo 512 > /sys/module/process_reclaim/parameters/per_swap_size
	echo "15360,19200,23040,26880,34415,43737" > /sys/module/lowmemorykiller/parameters/minfree
	echo 53059 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
fi

# Set zram - 1 GB
/system/bin/swapoff /dev/block/zram0
echo lzo > /sys/block/zram0/comp_algorithm
echo 1 > /sys/block/zram0/reset
echo 0 > /sys/block/zram0/disksize
echo 8 > /sys/block/zram0/max_comp_streams
echo 1073741824 > /sys/block/zram0/disksize
echo 0 > /proc/sys/vm/page-cluster
echo 100 > /proc/sys/vm/swappiness
/system/bin/mkswap /dev/block/zram0
/system/bin/swapon /dev/block/zram0 -p 32758

# Enable B service adj transition for 2GB or less memory
if [ $ram -le 2097152 ]; then
	setprop ro.vendor.qti.sys.fw.bservice_enable true
	setprop ro.vendor.qti.sys.fw.bservice_limit 5
	setprop ro.vendor.qti.sys.fw.bservice_age 5000

	# Enable Delay Service Restart
	setprop ro.vendor.qti.am.reschedule_service true
fi

# Post-setup services
echo 1 > /sys/block/mmcblk0/queue/iostats
echo 128 > /sys/block/mmcblk0/bdi/read_ahead_kb
echo 128 > /sys/block/mmcblk0/queue/read_ahead_kb
echo 128 > /sys/block/mmcblk0/queue/nr_requests
echo 10 > /sys/block/mmcblk0/queue/iosched/slice_idle
echo 128 > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
echo 128 > /sys/block/mmcblk0rpmb/queue/read_ahead_kb
setprop sys.post_boot.parsed 1
setprop vendor.post_boot.parsed 1

# Let kernel know our image version/variant/crm_version
if [ -f /sys/devices/soc0/select_image ]; then
	image_version="10:"
	image_version+=`getprop ro.build.id`
	image_version+=":"
	image_version+=`getprop ro.build.version.incremental`
	image_variant=`getprop ro.product.name`
	image_variant+="-"
	image_variant+=`getprop ro.build.type`
	oem_version=`getprop ro.build.version.codename`
	echo 10 > /sys/devices/soc0/select_image
	echo $image_version > /sys/devices/soc0/image_version
	echo $image_variant > /sys/devices/soc0/image_variant
	echo $oem_version > /sys/devices/soc0/image_crm_version
fi

# Parse misc partition path and set property
misc_link=$(ls -l /dev/block/bootdevice/by-name/misc)
real_path=${misc_link##*>}
setprop persist.vendor.mmi.misc_dev_path $real_path
