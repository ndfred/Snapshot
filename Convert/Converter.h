#import <Foundation/Foundation.h>

@interface Converter : NSObject

- (id)initWithSnapshotFilePath:(NSString *)snapshotFilePath;
- (void)convertToPSDFileAtPath:(NSString *)PSDFilePath;

@end
