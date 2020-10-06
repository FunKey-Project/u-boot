#!/bin/sh

# Fixup inclusion of libfdt headers, which can fail in older u-boot versions
# when libfdt-devel is installed system-wide.
# The core change is equivalent to upstream commit
# e0d20dc1521e74b82dbd69be53a048847798a90a (first in v2018.03). However, the fixup
# is complicated by the fact that the underlying u-boot code changed multiple
# times in history:
# - The directory scripts/dtc/libfdt only exists since upstream commit
#   c0e032e0090d6541549b19cc47e06ccd1f302893 (first in v2017.11). For earlier
#   versions, create a dummy scripts/dtc/libfdt directory with symlinks for the
#   fdt-related files. This allows to use the same -I<path> option for both
#   cases.
# - The variable 'srctree' used to be called 'SRCTREE' before upstream commit
#   01286329b27b27eaeda045b469d41b1d9fce545a (first in v2014.04).
# - The original location for libfdt, 'lib/libfdt/', used to be simply
#   'libfdt' before upstream commit 0de71d507157c4bd4fddcd3a419140d2b986eed2
#   (first in v2010.06). Make the 'lib' part optional in the substitution to
#   handle this.

if [ ! -d scripts/dtc/libfdt ]; then
    mkdir -p scripts/dtc/libfdt
    cd scripts/dtc/libfdt
    ln -s ../../../include/fdt.h .
    ln -s ../../../include/libfdt*.h .
    ln -s ../../../lib/libfdt/libfdt_internal.h .
fi
sed -i -e 's%-I\ *\$(srctree)/lib/libfdt%-I$(srctree)/scripts/dtc/libfdt%; s%-I\ *\$(SRCTREE)\(/lib\)\?/libfdt%-I$(SRCTREE)/scripts/dtc/libfdt%' tools/Makefile
