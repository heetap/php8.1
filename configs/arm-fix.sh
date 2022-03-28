#!/bin/bash

patch /usr/src/php/ext/sockets/config.m4 -i- <<EOF
@@ -67,6 +67,9 @@
   AC_CACHE_CHECK([if ancillary credentials uses ucred],[ac_cv_ucred],
   [
     AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
 #include <sys/socket.h>
   ]], [[struct ucred u = {.gid = 0};]])],
       [ac_cv_ucred=yes], [ac_cv_ucred=no])
EOF
