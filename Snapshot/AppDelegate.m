#import "AppDelegate.h"
#import "ViewController.h"
#import "UIWindow+SnapshotRepresentation.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window = window;
    window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self snapshot];
    });

    return YES;
}

- (void)snapshot {
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"dump.plist"];

    [[UIWindow allWindowsSnapshotRepresentation] writeToFile:filePath atomically:YES];
    NSLog(@"Snapshot is available at %@", filePath);
}

@end
