//
//  UltraFaceWrapper.m
//  MNNMetalTest
//
//  Created by GHLab on 2021/03/31.
//

#import "UltraFaceWrapper.h"

#include "UltraFace.hpp"

@interface UltraFaceWrapper()
{
	UltraFace* uf;
}

@end

@implementation UltraFaceWrapper

- (id)initWithModelPath:(NSString*)modelPath
{
	uf = new UltraFace([modelPath UTF8String], 320, 240);
	
	return [super init];
}

- (void)detect:(CVPixelBufferRef)pixelBuffer
{
	CVPixelBufferLockBaseAddress(pixelBuffer, 0);
	
	void * baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
	const int width = static_cast<int>(CVPixelBufferGetWidth(pixelBuffer));
	const int height = static_cast<int>(CVPixelBufferGetHeight(pixelBuffer));
	const int stride = static_cast<int>(CVPixelBufferGetBytesPerRow(pixelBuffer));

	auto *data = reinterpret_cast<unsigned char*>(baseAddress);
	
	std::vector<FaceInfo> result;
	uf->detect(data, width, height, stride, result);
	
	NSLog(@"face count : %d", result.size());
	
	CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

@end
