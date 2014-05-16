#import <UIKit/UIKit.h>

@interface UIWindow (SnapshotRepresentation)

+ (NSArray *)allWindowsSnapshotRepresentation;

- (NSDictionary *)snapshotRepresentation;

@end
