//
//  PinEntryViewController.m
//  PinEntry
//
//  Created by Farcaller on 21.10.10.
//  Copyright 2010 Codeneedle. All rights reserved.
//

#import "PinEntryViewController.h"

@implementation PinEntryViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if( (self = [super initWithCoder:aDecoder]) ) {
		mypin = 1234;
	}
	return self;
}

- (IBAction)newPin
{
	PEPinEntryController *c = [PEPinEntryController pinCreateController];
	c.pinDelegate = self;
	[self presentViewController:c animated:YES completion:0];
}

- (IBAction)changePin
{
	PEPinEntryController *c = [PEPinEntryController pinChangeController];
	c.pinDelegate = self;
	[self presentViewController:c animated:YES completion:0];
}

- (IBAction)verifyPin
{
	PEPinEntryController *c = [PEPinEntryController pinVerifyController];
	c.pinDelegate = self;
	[self presentViewController:c animated:YES completion:0];
}

- (BOOL)pinEntryController:(PEPinEntryController *)c shouldAcceptPin:(NSUInteger)pin
{
	// Verify the pin, return NO if it's incorrect. Otherwise hide the controller and return YES
	if(pin == mypin) {
		NSLog(@"Pin is valid!");
		if(c.verifyOnly == YES) {
			// Used for pinVerifyController, we should not hide pinChangeController yet
			[self dismissViewControllerAnimated:YES completion:0];
		}
		return YES;
	} else {
		NSLog(@"Pin is not valid (use %d)!", mypin);
		return NO;
	}
}

- (void)pinEntryController:(PEPinEntryController *)c changedPin:(NSUInteger)pin
{
	// Update your info to new pin code
	mypin = pin;
	NSLog(@"New pin is set to %d", pin);
	[self dismissViewControllerAnimated:YES completion:0];
}

- (void)pinEntryControllerDidCancel:(PEPinEntryController *)c
{
	NSLog(@"Pin change cancelled!");
	[self dismissViewControllerAnimated:YES completion:0];
}

@end
