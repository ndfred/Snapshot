#import "Converter.h"
#import <CoreGraphics/CoreGraphics.h>
#import "FMPSD.h"
#import "FMPSDLayer.h"

static CGRect CGRectFromString(NSString *string) {
    // {{35, 159}, {250, 250}}
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    CGRect frame;

    [scanner scanString:@"{{" intoString:nil];
    [scanner scanDouble:&frame.origin.x];
    [scanner scanString:@", " intoString:nil];
    [scanner scanDouble:&frame.origin.y];
    [scanner scanString:@"}, {" intoString:nil];
    [scanner scanDouble:&frame.size.width];
    [scanner scanString:@", " intoString:nil];
    [scanner scanDouble:&frame.size.height];

    return frame;
}

@interface Converter ()

@property NSString *snapshotFilePath;
@property FMPSD *psd;

@end

@implementation Converter

- (id)initWithSnapshotFilePath:(NSString *)snapshotFilePath {
    self = [super init];

    if (self != nil) {
        self.snapshotFilePath = snapshotFilePath;
    }

    return self;
}

- (void)convertToPSDFileAtPath:(NSString *)PSDFilePath {
    FMPSD *psd = [FMPSD new];
    NSArray *windows = [NSArray arrayWithContentsOfFile:self.snapshotFilePath];

    if ([windows count] == 0) {
        return;
    }

    CGRect mainWindowBounds = CGRectFromString([windows objectAtIndex:0][@"bounds"]);

    psd.height = mainWindowBounds.size.height;
    psd.width = mainWindowBounds.size.width;
    self.psd = psd;

    for (NSDictionary *window in [windows reverseObjectEnumerator]) {
        [self dumpLayer:window];
    }

    [psd writeToFile:[NSURL fileURLWithPath:PSDFilePath]];
}

- (void)dumpLayer:(NSDictionary *)layer {
    CGRect frame = CGRectFromString(layer[@"frame"]);
    FMPSDLayer *psdLayer = [FMPSDLayer layerWithSize:frame.size psd:self.psd];
    NSData *snapshotData = layer[@"snapshot"];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)snapshotData);
    CGImageRef image = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);

    NSLog(@"%@", layer[@"view"]);
    [psdLayer setFrame:frame];
    [psdLayer setImage:image];
    CFRelease(image);
    CFRelease(dataProvider);
    [self.psd.baseLayerGroup addLayerToGroup:psdLayer];
}

@end
