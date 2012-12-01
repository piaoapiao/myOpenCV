//
//  ViewController.h
//  openCV3
//
//  Created by wgdadmin on 12-12-1.
//  Copyright (c) 2012年 wgdadmin. All rights reserved.
//
//#import <opencv2/highgui/cap_ios.h>
//using namespace cv;
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UIImageView* imageView;
     IBOutlet UIImageView* imageView2;
    IBOutlet UIButton* button;
  //  CvVideoCamera* videoCamera;
}


//@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIImageView* imageView2;
@property (nonatomic, retain) UIButton* button;


- (IBAction)actionStart:(id)sender;


@end
