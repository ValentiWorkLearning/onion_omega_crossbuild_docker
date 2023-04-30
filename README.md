# DOCKER ONION TOOLCHAIN COMPILER

It was impossible to build https://github.com/foxel/onion-omega-cc-docker/tree/master in 2023, so I've decided to re-create the Docker builder for Onion platform.

## BUILD CONTAINER

```shell
docker build -t onion_builder .
```
Toolchain configuration [config](./config) is used. Of course you can run 
inside container ```make menuconfig``` and modify settings.

## RUN CONTAINER
```shell
docker run -t -i -v $PWD/build_volume:/build_volume onion_builder /bin/bash
```

## USE BUILT TOOLCHAIN

as `build container` step has finished, you can use compiled sdk.

You can just copy it from staging_dir inside container to your root file system:

```shell
docker run -t -i -v $PWD/build_volume:/build_volume onion_builder /bin/bash
# from another console
docker container ls
# result:
# CONTAINER ID   IMAGE           COMMAND             CREATED          STATUS          PORTS     NAMES
# b55b70439615   onion_builder   "/bin/bash"         4 hours ago      Up 4 hours                dreamy_lamarr

docker cp b55b70439615:/home/workspace/omega_home/source/staging_dir ./omega_sdk
./omega_sdk/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/mipsel-openwrt-linux-gcc -v
# result:
# Reading specs from /home/igor/omega_sdk/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/../lib/gcc/mipsel-openwrt-linux-musl/7.3.0/specs
# COLLECT_GCC=./omega_sdk/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/mipsel-openwrt-linux-gcc
# COLLECT_LTO_WRAPPER=/home/igor/omega_sdk/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/../libexec/gcc/mipsel-openwrt-linux-musl/7.3.0/lto-wrapper
# Target: mipsel-openwrt-linux-musl
# Configured with: /home/workspace/omega_home/source/build_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/gcc-7.3.0/configure --with-bugurl=http://www.lede-project.org/bugs/ --with-pkgversion='OpenWrt GCC 7.3.0 r7499-44c7d0a524' --prefix=/home/workspace/omega_home/source/staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl --build=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu --target=mipsel-openwrt-linux-musl --with-gnu-ld --enable-target-optspace --disable-libgomp --disable-libmudflap --disable-multilib --disable-libmpx --disable-nls --without-isl --without-cloog --with-host-libstdcxx=-lstdc++ --with-float=soft --with-gmp=/home/workspace/omega_home/source/staging_dir/host --with-mpfr=/home/workspace/omega_home/source/staging_dir/host --with-mpc=/home/workspace/omega_home/source/staging_dir/host --disable-decimal-float --with-mips-plt --with-diagnostics-color=auto-if-env --disable-libssp --enable-__cxa_atexit --with-headers=/home/workspace/omega_home/source/staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/include --disable-libsanitizer --enable-languages=c,c++ --enable-shared --enable-threads --with-slibdir=/home/workspace/omega_home/source/staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/lib --enable-lto --with-libelf=/home/workspace/omega_home/source/staging_dir/host
# Thread model: posix
# gcc version 7.3.0 (OpenWrt GCC 7.3.0 r7499-44c7d0a524) 

```

You can also build your program inside this container. Or use copied ready to use toolchain.


## USEFULL LINKS
[fixed issues](https://github.com/openwrt/openwrt/issues/9055)

[cross compile official info](https://docs.onion.io/omega2-docs/cross-compiling.html)
