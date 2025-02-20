//
//  UITextField+XPKit.m
//  XPKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 - 2015 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "UITextField+XPKit.h"
#import <objc/runtime.h>
#import <objc/objc.h>


@implementation UITextField (XPKit)

+ (UITextField *)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder color:(UIColor *)color font:(FontName)fontName size:(float)size returnType:(UIReturnKeyType)returnType keyboardType:(UIKeyboardType)keyboardType secure:(BOOL)secure borderStyle:(UITextBorderStyle)borderStyle autoCapitalization:(UITextAutocapitalizationType)capitalization keyboardAppearance:(UIKeyboardAppearance)keyboardAppearence enablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically clearButtonMode:(UITextFieldViewMode)clearButtonMode autoCorrectionType:(UITextAutocorrectionType)autoCorrectionType delegate:(id <UITextFieldDelegate> )delegate {
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
	[textField setBorderStyle:borderStyle];
	[textField setAutocorrectionType:autoCorrectionType];
	[textField setClearButtonMode:clearButtonMode];
	[textField setKeyboardType:keyboardType];
	[textField setAutocapitalizationType:capitalization];
	[textField setPlaceholder:placeholder];
	[textField setTextColor:color];
	[textField setReturnKeyType:returnType];
	[textField setEnablesReturnKeyAutomatically:enablesReturnKeyAutomatically];
	[textField setSecureTextEntry:secure];
	[textField setKeyboardAppearance:keyboardAppearence];
	[textField setFont:[UIFont fontForFontName:fontName size:size]];
	[textField setDelegate:delegate];

	return textField;
}

/*
   - (void)drawPlaceholderInRect:(CGRect)rect
   {
    [[UIColor colorWithWhite:0.400 alpha:1.000] setFill];
    [self.placeholder drawInRect:rect withFont:[self.font fontWithSize:self.font.pointSize]];
   }
 */

static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";

- (void)limitTextLength:(NSInteger)length {
	objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInteger:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(id)sender {
	NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
	NSUInteger length = [lengthNumber intValue];

	if (self.text.length > length) {
		self.text = [self.text substringToIndex:length];
	}
}

@end
