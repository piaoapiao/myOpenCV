//
//  ViewController.m
//  openCV3
//
//  Created by wgdadmin on 12-12-1.
//  Copyright (c) 2012年 wgdadmin. All rights reserved.
//
#import <opencv2/highgui/cap_ios.h>
using namespace cv;
#import "ViewController.h"


@interface ViewController ()
-(Mat)cvMatFromUIImage:(UIImage *)image;
-(Mat)cvMatGrayFromUIImage:(UIImage *)image;
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
@end

@implementation ViewController
@synthesize imageView;
@synthesize imageView2;
@synthesize button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = [UIImage imageNamed:@"fruits.jpg"];;

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (IBAction)actionStart:(id)sender;
{
//    [self.videoCamera start];

    static int i = 0;
    if(i%2 == 0)
    {
        //imageView.image = temp2;
        UIImage *tempImage = [UIImage imageNamed:@"fruits.jpg"];
        
        cv::Mat tempMat = [self cvMatFromUIImage:tempImage];
        cv::Mat dstMat ;
        cv::cvtColor(tempMat, dstMat, CV_BGR2GRAY);
 
            bitwise_not(dstMat, dstMat);
        
        tempImage = [self UIImageFromCVMat:dstMat];
        self.imageView2.image = tempImage;
    }
    else
    {
        imageView2.image = nil;
    }
    i++;
   // imageView2.image =[UIImage imageNamed:@"fruits.jpg"];
 
    
}


#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    // Do some OpenCV stuff with the image
    
//    Mat image_copy;
//    cvtColor(image, image_copy, CV_BGRA2BGR);
//    
//    // invert image
//    bitwise_not(image_copy, image_copy);
//    cvtColor(image_copy, image, CV_BGR2BGRA);
}
#endif

static UIImage* MatToUIImage(const cv::Mat& m) {
CV_Assert(m.depth() == CV_8U);
NSData *data = [NSData dataWithBytes:m.data length:m.elemSize()*m.total()];
CGColorSpaceRef colorSpace = m.channels() == 1 ?
CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();
CGDataProviderRef provider = CGDataProviderCreateWithCFData(( CFDataRef)data);
// Creating CGImage from cv::Mat
CGImageRef imageRef = CGImageCreate(m.cols, m.cols, m.elemSize1()*8, m.elemSize()*8,
                                    m.step[0], colorSpace, kCGImageAlphaNoneSkipLast|kCGBitmapByteOrderDefault,
                                    provider, NULL, false, kCGRenderingIntentDefault);
UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
CGImageRelease(imageRef); CGDataProviderRelease(provider);
CGColorSpaceRelease(colorSpace);
    return finalImage;
}

static void UIImageToMat(const UIImage* image, cv::Mat& m) {
CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
CGFloat cols = image.size.width, rows = image.size.height;
m.create(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
CGContextRef contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows, 8,
                                                m.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
CGContextRelease(contextRef); CGColorSpaceRelease(colorSpace);
}


- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}


-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(( CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
@end
