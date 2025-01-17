# $NetBSD: options.mk,v 1.27 2024/04/07 07:31:19 wiz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.cairo
PKG_SUPPORTED_OPTIONS=	lzo x11 xcb
.if exists(/System/Library/Frameworks/Quartz.framework)
PKG_SUPPORTED_OPTIONS+=	quartz
PKG_SUGGESTED_OPTIONS+=	quartz
.else
PKG_SUGGESTED_OPTIONS=	x11 xcb
.endif
PKG_SUGGESTED_OPTIONS+=	lzo

.include "../../mk/bsd.options.mk"

PLIST_VARS+=	x11 xcb quartz

.if !empty(PKG_OPTIONS:Mlzo)
.include "../../archivers/lzo/buildlink3.mk"
.endif

###
### X11 and XCB support (XCB implies X11)
###
.if !empty(PKG_OPTIONS:Mx11) || !empty(PKG_OPTIONS:Mxcb)
PLIST.x11=		yes
.include "../../x11/libX11/buildlink3.mk"
.include "../../x11/libXext/buildlink3.mk"
.include "../../x11/libXrender/buildlink3.mk"
MESON_ARGS+=		-Dxlib=enabled
.  if !empty(PKG_OPTIONS:Mxcb)
PLIST.xcb=	yes
.    include "../../x11/libxcb/buildlink3.mk"
MESON_ARGS+=		-Dxcb=enabled
.  else
MESON_ARGS+=		-Dxcb=disabled
.  endif
.else
MESON_ARGS+=		-Dxlib=disabled
MESON_ARGS+=		-Dxcb=disabled
.endif

###
### Quartz backend
###
# Quartz backend interacts badly with our library stack. The most
# notable issue is that when quartz-font is enabled, cairo will never
# use fontconfig but instead uses CoreGraphics API to find fonts in
# system-default font paths; as a result, any fonts installed with
# pkgsrc will never be found. OTOH fontconfig by default searches for
# fonts in MacOS X system-default paths too so sticking with it will
# not be a problem.
.if !empty(PKG_OPTIONS:Mquartz)
PLIST.quartz=		yes
WARNINGS+=		"You have enabled Quartz backend. No fonts installed with pkgsrc will be found."
MESON_ARGS+=		-Dquartz=enabled
.else
MESON_ARGS+=		-Dquartz=disabled
.endif
