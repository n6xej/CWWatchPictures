//
//  InterfaceController.m
//  CWWatchPictures WatchKit Extension
//
//  Created by Christopher Worley on 5/15/15.
//  Copyright (c) 2015 Christopher Worley. All rights reserved.
//

#import "InterfaceController.h"
#import "ImageController.h"
#import "MHCameraRoll.h"


@interface InterfaceController()
@property (nonatomic, strong) MHCameraRoll *cameraRoll;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *interfaceTable;
@end


@implementation InterfaceController
{
	NSInteger imageCount;
}


- (instancetype)init {
	self = [super init];
	
	if (self) {
		self.cameraRoll = [[MHCameraRoll alloc] init];
		self.cameraRoll.fileTypes = MHCameraRollFileTypesAll;
		self.cameraRoll.thumbStyle = MHCameraRollThumbStyleSmallSquare;
		
		[self.cameraRoll loadCameraRollWithSuccess:^{
			imageCount = [self.cameraRoll imageCount];
			
			if (imageCount > 50)
			{
				imageCount = 50;
			}
			[self loadTableRows];
			
		} unauthorized:^{
			// unauthorized state: access to camera roll was denied by the user so
			// we should show an unauthorized state with text explaining how to
			// re-authorize the app to use camera roll.
		}];
		
	}
	
	return self;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)loadTableRows {
	[self.interfaceTable setNumberOfRows:imageCount withRowType:@"default"];
	
	for (int i=0;i<imageCount; i++) {
		
		[self.cameraRoll thumbAtIndex:i completionHandler:^(UIImage *thumb) {
			ImageController *vc = [self.interfaceTable rowControllerAtIndex:i];
			[vc.myImage setImage:thumb];
		}];
	}
}

@end



