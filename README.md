It was impossible to build https://github.com/foxel/onion-omega-cc-docker/tree/master in 2023, so I've decided to re-create the Docker builder for Onion platform.
### build container:

```shell
docker build -t onion_builder .
```

### run container:
```shell
docker run -t -i -v $PWD/build_volume:/build_volume onion_builder /bin/bash
```

### Compilation steps:
It's necessary to update m4 package to 1.4.19 version or patch `./build_dir/host/m4-1.4.18/lib/c-stack.c`:
```c
#include <signal.h>
#if ! HAVE_STACK_T && ! defined stack_t
typedef struct sigaltstack stack_t;
#endif
#ifndef SIGSTKSZ
# define SIGSTKSZ 16384
//#elif HAVE_LIBSIGSEGV && SIGSTKSZ < 16384
/* libsigsegv 2.6 through 2.8 have a bug where some architectures use
   more than the Linux default of an 8k alternate stack when deciding
   if a fault was caused by stack overflow.  */
//# undef SIGSTKSZ
//# define SIGSTKSZ 16384
#endif
```

Proper fixup:
https://github.com/openwrt/openwrt/commit/aa2d61eced0f63105fe663f65d4fc542c6da4aed#diff-e99b937718df0a2d738dfaed68a3ea88025e1e0f865c6e4b23a906e8cb11e8b9


```shell
https://docs.onion.io/omega2-docs/cross-compiling.html
```
