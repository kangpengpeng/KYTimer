#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KYDsLinkTimer.h"
#import "KYGCDTimer.h"
#import "KYNSTimer.h"
#import "KYTimerManager.h"
#import "KYTimerProtocol.h"

FOUNDATION_EXPORT double KYMyTimerVersionNumber;
FOUNDATION_EXPORT const unsigned char KYMyTimerVersionString[];

