$NetBSD: patch-tools_install.py,v 1.2 2024/04/05 05:31:45 adam Exp $

Install man pages under the right directory.

--- tools/install.py.orig	2024-04-03 00:39:38.000000000 +0000
+++ tools/install.py
@@ -182,10 +182,7 @@ def files(options, action):
   action(options, [os.path.join(options.v8_dir, 'tools/gdbinit')], 'share/doc/node/')
   action(options, [os.path.join(options.v8_dir, 'tools/lldb_commands.py')], 'share/doc/node/')
 
-  if 'freebsd' in sys.platform or 'openbsd' in sys.platform:
-    action(options, ['doc/node.1'], 'man/man1/')
-  else:
-    action(options, ['doc/node.1'], 'share/man/man1/')
+  action(options, ['doc/node.1'], os.environ.get('PKGMANDIR') + '/man1/')
 
   if 'true' == options.variables.get('node_install_npm'):
     npm_files(options, action)
