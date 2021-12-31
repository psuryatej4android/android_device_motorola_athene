/*
   Copyright (c) 2014, The Linux Foundation. All rights reserved.
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.
   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdlib.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>
#include <stdio.h>

#include "android-base/properties.h"
#include "property_service.h"
#include "vendor_init.h"

using android::base::SetProperty;

static void num_sims(void);
static void target_ram(void);

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void property_override_dual(char const system_prop[], char const vendor_prop[], char const value[])
{
    property_override(system_prop, value);
    property_override(vendor_prop, value);
}

void vendor_load_properties()
{

    std::string platform;
    std::string device_boot;
    std::string sku;
    std::string radio;
    std::string device;
    std::string carrier;

    platform = android::base::GetProperty("ro.board.platform", "");
    if (platform != ANDROID_TARGET)
        return;

    device_boot = android::base::GetProperty("ro.boot.device", "");
    SetProperty("ro.hw.device", device_boot.c_str());

    sku = android::base::GetProperty("ro.boot.hardware.sku", "");

    carrier = android::base::GetProperty("ro.boot.carrier", "");

    radio = android::base::GetProperty("ro.boot.radio", "");
    SetProperty("ro.hw.radio", radio.c_str());

    /* Common for all models */
    property_override("ro.build.product", "athene");
    target_ram();
    num_sims();

    if (device_boot == "athene_13mp") {
        /* Moto G4 (XT162x) */
        property_override_dual("ro.product.device", "ro.product.vendor.device", "athene");
        property_override_dual("ro.product.model", "ro.product.vendor.model", "Moto G4");
        SetProperty("ro.telephony.default_network", "10");
    } else {
        /* Moto G4 Plus (XT164x) */
        property_override_dual("ro.product.device", "ro.product.vendor.device", "athene_f");
        property_override_dual("ro.product.model", "ro.product.vendor.model", "Moto G4 Plus");
        SetProperty("ro.telephony.default_network", "10,0");
    }

   if (sku == "XT1625" || sku == "XT1644") {
       SetProperty("net.tethering.noprovisioning", "true");
        SetProperty("persist.radio.is_wps_enabled", "true");
        SetProperty("ro.radio.imei.sv", "4");
        SetProperty("tether_dun_required", "0");
   }

    if (sku == "XT1621" || sku == "XT1622" || sku == "XT1640" || sku == "XT1642" || sku == "XT1643") {
        if (radio == "India") {
            SetProperty("ro.radio.imei.sv", "9");
            SetProperty("persist.radio.is_wps_enabled", "true");
        } else {
            SetProperty("ro.radio.imei.sv", "3");
        }
    }

    if (sku == "XT1626" || sku == "XT1641") {
        SetProperty("ro.radio.imei.sv", "2");
        SetProperty("persist.radio.is_wps_enabled", "true");
        SetProperty("persist.radio.pb.max.match", "10");
    }
}

/* Target-Specific Dalvik Heap & HWUI Configuration */
static void target_ram(void) {
    std::string ram;

    ram = android::base::GetProperty("ro.boot.ram", "");

    if (ram == "2GB") {
        SetProperty("dalvik.vm.heapstartsize", "16m");
        SetProperty("dalvik.vm.heapgrowthlimit", "192m");
        SetProperty("dalvik.vm.heapsize", "512m");
        SetProperty("dalvik.vm.heaptargetutilization", "0.75");
        SetProperty("dalvik.vm.heapminfree", "2m");
        SetProperty("dalvik.vm.heapmaxfree", "8m");
    } else {
        SetProperty("dalvik.vm.heapstartsize", "8m");
        SetProperty("dalvik.vm.heapgrowthlimit", "288m");
        SetProperty("dalvik.vm.heapsize", "768m");
        SetProperty("dalvik.vm.heaptargetutilization", "0.75");
        SetProperty("dalvik.vm.heapminfree", "512k");
        SetProperty("dalvik.vm.heapmaxfree", "8m");
    }
}

static void num_sims(void) {
    std::string dualsim;

    dualsim = android::base::GetProperty("ro.boot.dualsim", "");

    SetProperty("ro.hw.dualsim", dualsim.c_str());

    if (dualsim == "true") {
        SetProperty("persist.radio.multisim.config", "dsds");
        SetProperty("ro.telephony.ril.config", "simactivation");
    } else {
        SetProperty("persist.radio.multisim.config", "");
    }
}
