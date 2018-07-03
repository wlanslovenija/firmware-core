#!/bin/bash -x

openwrt_version="$1"
openwrt_target="$2"
openwrt_subtarget="$3"
work_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )
platform_dir="${work_dir}/openwrt"
build_dir="${work_dir}/build"
download_dir="${build_dir}/openwrt"

if [[ -z "${openwrt_version}" || -z "${openwrt_target}" || -z "${openwrt_subtarget}" ]]; then
  echo "ERROR: Usage: $0 <version> <target> <subtarget>"
  exit 1
fi

# Check for proper working directory
if [[ ! -d  ${platform_dir} ]]; then
  echo "ERROR: Invalid working directory!"
  exit 1
fi

# Set the base URL for all downloads
base_url="https://downloads.openwrt.org"

# Set the target specific URL
if [ "$1" != "snapshot" ]; then
	target_url="${base_url}/releases/${openwrt_version}/targets/${openwrt_target}/${openwrt_subtarget}"
else
	target_url="${base_url}/snapshots/targets/${openwrt_target}/${openwrt_subtarget}"
fi

mkdir -p ${download_dir}

# Get imagebuilder & SDK archive section
cd ${download_dir}

# Get imagebuilder filename
imagebuilder_filename=$( curl -s -L "${target_url}" | grep openwrt-imagebuilder | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' )

# Download the imagebuilder
echo "Downloading imagebuilder for ${openwrt_target}-${openwrt_subtarget}"
curl -O "{$target_url}/{$imagebuilder_filename}"

# Get SDK filename
SDK_filename=$( curl -s -L "${target_url}" | grep openwrt-sdk | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' )

# Download the SDK
echo "Downloading SDK for ${openwrt_target}-${openwrt_subtarget}"
curl -O "{$target_url}/{$SDK_filename}"

# Make imagebuilder directory
mkdir -p imagebuilder-${openwrt_target}-${openwrt_subtarget}

# Extract the imagebuilder
echo "Extracting imagebuilder for ${openwrt_target}-${openwrt_subtarget}"
tar xf $imagebuilder_filename --strip-components=1 -C imagebuilder-${openwrt_target}-${openwrt_subtarget}

# Make SDK directory
mkdir -p SDK-${openwrt_target}-${openwrt_subtarget}

# Extract the SDK
echo "Extracting SDK for ${openwrt_target}-${openwrt_subtarget}"
tar xf $SDK_filename --strip-components=1 -C SDK-${openwrt_target}-${openwrt_subtarget}

# Delete imagebuilder and SDK archives
rm $imagebuilder_filename
rm $SDK_filename

# Wlan SI custom package building section
cd SDK-${openwrt_target}-${openwrt_subtarget}

# Add Wlan SI OPKG feed
echo "src-git routing_wlansi https://github.com/wlanslovenija/firmware-packages-opkg.git" >> feeds.conf.default

# Disable default options