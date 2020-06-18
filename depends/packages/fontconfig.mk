package=fontconfig
$(package)_version=2.12.5
$(package)_download_path=https://www.freedesktop.org/software/fontconfig/release/
$(package)_file_name=$(package)-$($(package)_version).tar.bz2
$(package)_sha256_hash=E10CCF1E26B0968F61D81037AF1147FEA28E86BFD159FFD8CFD5A486DA126CE4
$(package)_dependencies=freetype expat

define $(package)_set_vars
  $(package)_config_opts=--disable-docs --disable-static
endef

define $(package)_config_cmds
  $($(package)_autoconf)
endef

# 2.12.1 uses CHAR_WIDTH which is reserved and clashes with some glibc versions, but newer versions of fontconfig
# have broken makefiles which needlessly attempt to re-generate headers with gperf.
# Instead, change all uses of CHAR_WIDTH, and disable the rule that forces header re-generation.
# This can be removed once the upstream build is fixed.
define $(package)_build_cmds
  sed -i 's/CHAR_WIDTH/CHARWIDTH/g' fontconfig/fontconfig.h src/fcobjshash.gperf src/fcobjs.h src/fcobjshash.h && \
  sed -i 's/fcobjshash.h: fcobjshash.gperf/fcobjshash.h:/' src/Makefile && \
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef
