//
//  PinEntryViewController.h
//  PinEntry
//
//  Created by Farcaller on 21.10.10.
//  Copyright 2010 Codeneedle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEPinEntryController.h"

@interface PinEntryViewController : UIViewController <PEPinEntryControllerDelegate>
{
	int mypin;
}

- (IBAction)newPin;
- (IBAction)changePin;
- (IBAction)verifyPin;

@end

