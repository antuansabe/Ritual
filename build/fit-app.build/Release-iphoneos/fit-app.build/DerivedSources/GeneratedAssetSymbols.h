#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "historialBackground" asset catalog image resource.
static NSString * const ACImageNameHistorialBackground AC_SWIFT_PRIVATE = @"historialBackground";

/// The "loginBackground" asset catalog image resource.
static NSString * const ACImageNameLoginBackground AC_SWIFT_PRIVATE = @"loginBackground";

/// The "profileBackground" asset catalog image resource.
static NSString * const ACImageNameProfileBackground AC_SWIFT_PRIVATE = @"profileBackground";

/// The "registroBackground" asset catalog image resource.
static NSString * const ACImageNameRegistroBackground AC_SWIFT_PRIVATE = @"registroBackground";

#undef AC_SWIFT_PRIVATE
