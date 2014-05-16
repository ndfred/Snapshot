#import <Foundation/Foundation.h>
#import "Converter.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [[[Converter alloc] initWithSnapshotFilePath:@"/Users/frd/Library/Application Support/iPhone Simulator/7.1/Applications/C6518D3C-E026-4480-820E-1315E23A06C0/tmp/dump.plist"] convertToPSDFileAtPath:@"/Users/frd/Code/Snapshot/snapshot.psd"];
    }
    return 0;
}
