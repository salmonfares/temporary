# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/Project-LegionOS/manifest.git -b 11 -g default,-mips,-darwin,-notdefault
git clone https://github.com/Kneba/local_manifests.git --depth 1 -b master .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch legion_X00TD-userdebug
export BUILD_USERNAME=kneba
export BUILD_HOSTNAME=venom-carnage
export ALLOW_MISSING_DEPENDENCIES=true
export TZ=Asia/Tokyo #put before last build command
make legion

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
