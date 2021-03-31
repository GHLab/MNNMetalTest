//
//  UltraFaceWrapper.h
//  MNNMetalTest
//
//  Created by GHLab on 2021/03/31.
//

#ifndef UltraFaceWrapper_h
#define UltraFaceWrapper_h

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

@interface UltraFaceWrapper : NSObject

- (id)initWithModelPath:(NSString*)modelPath;
- (void)detect:(CVPixelBufferRef)pixelBuffer;

@end

#endif /* UltraFaceWrapper_h */
