#import "CALayer+SnapshotRepresentation.h"
#import <UIKit/UIKit.h>

@implementation CALayer (SnapshotRepresentation)

- (NSDictionary *)snapshotRepresentation {
    NSMutableDictionary *snapshotRepresentation = [NSMutableDictionary new];
    UIImage *contentsImage = [self contentsImage];
    UIImage *snapshotImage = [self snapshotImage];

    snapshotRepresentation[@"frame"] = NSStringFromCGRect(self.frame);
    snapshotRepresentation[@"bounds"] = NSStringFromCGRect(self.bounds);
    snapshotRepresentation[@"layer"] = [[self class] description];

    if ([self.delegate isKindOfClass:[UIView class]]) {
        snapshotRepresentation[@"view"] = [[(UIView *)self.delegate class] description];
    }

    // TODO: support transform
    // TODO: support content mode
    // TODO: support rounded rects
    // TODO: support layer shadow / shadow path
    // TODO: support layer mask
    // TODO: support alpha

    if (contentsImage) {
        snapshotRepresentation[@"contents"] = UIImagePNGRepresentation(contentsImage);
    }

    if (snapshotImage) {
        snapshotRepresentation[@"snapshot"] = UIImagePNGRepresentation(snapshotImage);
    }

    if ([self.sublayers count]) {
        snapshotRepresentation[@"children"] = [self.sublayers valueForKey:@"snapshotRepresentation"];
    }

    return [snapshotRepresentation copy];
}

- (UIImage *)snapshotImage {
    CGRect bounds = self.bounds;
    UIImage *snapshotImage = nil;

    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
    [self renderInContext:UIGraphicsGetCurrentContext()];
    snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return snapshotImage;
}

- (UIImage *)contentsImage {
    id contents = self.contents;

    if (contents) {
        if (![contents isKindOfClass:[UIImage class]]) {
            if (CFGetTypeID((__bridge CFTypeRef)contents) == CGImageGetTypeID()) {
                contents = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)contents];
            } else {
                // TODO: support CABackingStore
                CFStringRef description = CFCopyDescription((__bridge CFTypeRef)contents);

                NSLog(@"Ignoring backing store: %@", description);
                CFRelease(description);
                contents = nil;
            }
        }
    }

    return contents;
}

@end
