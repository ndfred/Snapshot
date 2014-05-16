#import "UIWindow+SnapshotRepresentation.h"
#import "CALayer+SnapshotRepresentation.h"

@interface UIWindow (PrivateWindows)

+ (NSArray *)allWindowsIncludingInternalWindows:(BOOL)internalWindows onlyVisibleWindows:(BOOL)onlyVisibleWindows;

@end

@implementation UIWindow (SnapshotRepresentation)

+ (NSArray *)allWindowsSnapshotRepresentation {
    NSArray *windows = nil;

    if ([self respondsToSelector:@selector(allWindowsIncludingInternalWindows:onlyVisibleWindows:)]) {
        windows = [self allWindowsIncludingInternalWindows:YES onlyVisibleWindows:YES];
    } else {
        windows = [[UIApplication sharedApplication] windows];
    }

    return [windows valueForKey:@"snapshotRepresentation"];
}

- (NSDictionary *)snapshotRepresentation {
    return [self.layer snapshotRepresentation];
}

@end
