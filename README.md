Pin Entry Classes
=================

PinEntry is a small library that provides support for 4-digit pin code entries.

PENumpadView
------------

Custom UIView that implements look&feel of iOS numpad keyboard with support for additional buttion in lower left corner.

When positioning the view, best frame is `CGRectMake(0, 244, 320, 216)`. That's the frame you get when using `[[PENumpadView alloc] init];`

### Customizing PENumpadView

Use the property **detailButton** to specify the look of the optional button.

	@property (nonatomic, readwrite, assign) NSUInteger detailButon

* _PEKeyboardDetailNone_: no button (no events generated on tap)
* _PEKeyboardDetailDone_: "DONE" button
* _PEKeyboardDetailNext_: "NEXT" button
* _PEKeyboardDetailDot_: "." button
* _PEKeyboardDetailEdit_: "EDIT" button

### Handling events

To handle key presses you need to implement `PENumpadViewDelegate`:

	- (void)keyboardViewDidEnteredNumber:(int)num

Message is sent when digit key is tapped, `num` contains the value in 0..9 range.

	- (void)keyboardViewDidBackspaced

Message is sent when backspace is tapped.

	- (void)keyboardViewDidOptKey

Message is sent when **detailButon** is something other than _PEKeyboardDetailNone_ and the lower left button is tapped.

If you define **PINENTRY_KEYBOARD_SENDS_NOTIFICATIONS**, each tap would also generate **kPinEntryKeyboardEvent** notification, where `object` is the PENumpadView, and `detailInfo` contains the key **kPinEntryKeyboardCode** with NSNumber value. 0..9 correspond to digit keys, -1 – lower left button, -2 – backspace.

PEViewController
----------------

The view controller that implements pin entry. You can use it as modal controller or present in navigation stack.

### Customizing PEViewController

You can set up the prompt using **prompt** property:

	@property (nonatomic, readwrite, copy) NSString *prompt

The promt is displaed just above the pin boxes.

### Handling pin code entry

As soon as user enters 4 digits and taps "DONE", PEViewController sends `pinEntryControllerDidEnteredPin:` message to its `delegate`:

	- (void)pinEntryControllerDidEnteredPin:(PEViewController *)controller

You can then get access to `pin` property that holds **string** representation of the pin code. Here's a sample implementation of pin processing:

	- (void)pinEntryControllerDidEnteredPin:(PEViewController *)controller
	{
		if([controller.pin intValue] == 1234) {
			// ...
		}
	}

### Clearing input

You can use `resetPin` method to clear the current pin code, to make your PEViewController instance re-usable.

PinEntryController
------------------

A complete implementation of navigation stack, required to ask user for a pin code, update a pin code or create new pin code.

### Verifying a pin code

	- (void)verifyPin
	{
		PEPinEntryController *c = [PEPinEntryController pinVerifyController];
		c.pinDelegate = self;
		[self presentModalViewController:c animated:YES];
	}
	
	- (BOOL)pinEntryController:(PEPinEntryController *)c shouldAcceptPin:(NSUInteger)pin
	{
		// Verify the pin, return NO if it's incorrect. Otherwise hide the controller and return YES
		if(pin == mypin) {
			NSLog(@"Pin is valid!");
			return YES;
		} else {
			NSLog(@"Pin is not valid (use %d)!", mypin);
			return NO;
		}
	}

### Set the pin code (initial, without verify)

	- (void)setPin
	{
		PEPinEntryController *c = [PEPinEntryController pinCreateController];
		c.pinDelegate = self;
		[self presentModalViewController:c animated:YES];
	}
	
	- (void)pinEntryController:(PEPinEntryController *)c changedPin:(NSUInteger)pin
	{
		// Update your info to new pin code
		NSLog(@"New pin is set to %d", pin);
		[self dismissModalViewControllerAnimated:YES];
	}

### Change pin code (with verification of current pin, can be cancelled)

	- (void)chagePin
	{
		PEPinEntryController *c = [PEPinEntryController pinChangeController];
		c.pinDelegate = self;
		[self presentModalViewController:c animated:YES];
	}
	
	- (BOOL)pinEntryController:(PEPinEntryController *)c shouldAcceptPin:(NSUInteger)pin
	{
		// Verify the pin, return NO if it's incorrect
		if(pin == mypin) {
			NSLog(@"Pin is valid!");
			// Do NOT not hide pinChangeController yet
			return YES;
		} else {
			NSLog(@"Pin is not valid (use %d)!", mypin);
			return NO;
		}
	}

	- (void)pinEntryController:(PEPinEntryController *)c changedPin:(NSUInteger)pin
	{
		// Update your info to new pin code
		NSLog(@"New pin is set to %d", pin);
		[self dismissModalViewControllerAnimated:YES];
	}

	- (void)pinEntryControllerDidCancel:(PEPinEntryController *)c
	{
		NSLog(@"Pin change cancelled!");
		[self dismissModalViewControllerAnimated:YES];
	}

TODO
====

* Add i18n support
* Add retina images
