//
//  SCLAlertView.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
#else
#import <UIKit/UIKit.h>
#endif
#import "SCLButton.h"
#import "SCLTextView.h"

typedef NSAttributedString* (^SCLAttributedFormatBlock)(NSString *value);
typedef void (^DismissBlock)(void);

@interface SCLAlertView : UIViewController

/** Alert hide animation styles
 *
 * Set SCLAlertView hide animation type.
 */
typedef NS_ENUM(NSInteger, SCLAlertViewHideAnimation)
{
    FadeOut,
    SlideOutToBottom,
    SlideOutToTop,
    SlideOutToLeft,
    SlideOutToRight,
    SlideOutToCenter,
    SlideOutFromCenter
};

/** Alert show animation styles
 *
 * Set SCLAlertView show animation type.
 */
typedef NS_ENUM(NSInteger, SCLAlertViewShowAnimation)
{
    FadeIn,
    SlideInFromBottom,
    SlideInFromTop,
    SlideInFromLeft,
    SlideInFromRight,
    SlideInFromCenter,
    SlideInToCenter
};

/** Alert background styles
 *
 * Set SCLAlertView background type.
 */
typedef NS_ENUM(NSInteger, SCLAlertViewBackground)
{
    Shadow,
    Transparent
};

/** Title Label
 *
 * The text displayed as title.
 */
@property UILabel *labelTitle;

/** Text view with the body message
 *
 * Holds the textview.
 */
@property UITextView *viewText;

/** Dismiss on tap outside
 *
 * A boolean value that determines whether to dismiss when tapping outside the SCLAlertView.
 * (Default: NO)
 */
@property (nonatomic, assign) BOOL shouldDismissOnTapOutside;

/** Sound URL
 *
 * Holds the sound NSURL path.
 */
@property (nonatomic, strong) NSURL *soundURL;

/** Set text attributed format block
 *
 * Holds the attributed string.
 */
@property (nonatomic, copy) SCLAttributedFormatBlock attributedFormatBlock;

/** Set Complete button format block.
 *
 * Holds the button format block.
 * Support keys : backgroundColor, borderWidth, borderColor, textColor
 */
@property (nonatomic, copy) CompleteButtonFormatBlock completeButtonFormatBlock;

/** Set button format block.
 *
 * Holds the button format block.
 * Support keys : backgroundColor, borderWidth, borderColor, textColor
 */
@property (nonatomic, copy) ButtonFormatBlock buttonFormatBlock;

/** Hide animation type
 *
 * Holds the hide animation type.
 * (Default: FadeOut)
 */
@property (nonatomic) SCLAlertViewHideAnimation hideAnimationType;

/** Show animation type
 *
 * Holds the show animation type.
 * (Default: SlideInFromTop)
 */
@property (nonatomic) SCLAlertViewShowAnimation showAnimationType;

/** Set SCLAlertView background type.
 *
 * SCLAlertView background type.
 * (Default: Shadow)
 */
@property (nonatomic) SCLAlertViewBackground backgroundType;

/** Set custom color to SCLAlertView.
 *
 * SCLAlertView custom color.
 * (Buttons, top circle and borders)
 */
@property (nonatomic, strong) UIColor *customViewColor;

/** Set custom color to SCLAlertView background.
 *
 * SCLAlertView background custom color.
 */
@property (nonatomic, strong) UIColor *backgroundViewColor;

/** Set SCLAlertView extension bounds.
 *
 * Set new bounds (EXTENSION ONLY)
 */
@property (nonatomic) CGRect extensionBounds;

/** Set status bar hidden.
 *
 * Status bar hidden
 */
@property (nonatomic) BOOL statusBarHidden;

/** Set status bar style.
 *
 * Status bar style
 */
@property (nonatomic) UIStatusBarStyle statusBarStyle;


+ (instancetype)sharedInstance;

/** Initialize SCLAlertView using a new window.
 *
 * Init with new window
 */
- (instancetype)initWithNewWindow;

/** Initialize SCLAlertView using a new window.
 *
 * Init with new window with custom width
 */
- (instancetype)initWithNewWindowWidth:(CGFloat)windowWidth;

/** Warns that alerts is gone
 *
 * Warns that alerts is gone using block
 */
- (void)alertIsDismissed:(DismissBlock)dismissBlock;

/** Hide SCLAlertView
 *
 * Hide SCLAlertView using animation and removing from super view.
 */
- (void)hideView;

/** SCLAlertView visibility
 *
 * Returns if the alert is visible or not.
 */
- (BOOL)isVisible;

/** Add Text Field
 *
 * @param title The text displayed on the textfield.
 */
- (SCLTextView *)addTextField:(NSString *)title;

/** Add a custom Text Field
 *
 * @param textField The custom textfield provided by the programmer.
 */
- (void)addCustomTextField:(UITextField *)textField;

/** Add Timer Display
 *
 * @param buttonIndex The index of the button to add the timer display to.
 * @param reverse Convert timer to countdown.
 */
- (void)addTimerToButtonIndex:(NSInteger)buttonIndex reverse:(BOOL)reverse;

/** Set Title font family and size
 *
 * @param titleFontFamily The family name used to displayed the title.
 * @param size Font size.
 */
- (void)setTitleFontFamily:(NSString *)titleFontFamily withSize:(CGFloat)size;

/** Set Text field font family and size
 *
 * @param bodyTextFontFamily The family name used to displayed the text field.
 * @param size Font size.
 */
- (void)setBodyTextFontFamily:(NSString *)bodyTextFontFamily withSize:(CGFloat)size;

/** Set Buttons font family and size
 *
 * @param buttonsFontFamily The family name used to displayed the buttons.
 * @param size Font size.
 */
- (void)setButtonsTextFontFamily:(NSString *)buttonsFontFamily withSize:(CGFloat)size;

/** Add a Button with a title and a block to handle when the button is pressed.
 *
 * @param title The text displayed on the button.
 * @param action A block of code to be executed when the button is pressed.
 */
- (SCLButton *)addButton:(NSString *)title actionBlock:(SCLActionBlock)action;

/** Add a Button with a title, a block to handle validation, and a block to handle when the button is pressed and validation succeeds.
 *
 * @param title The text displayed on the button.
 * @param validationBlock A block of code that will allow you to validate fields or do any other logic you may want to do to determine if the alert should be dismissed or not. Inside of this block, return a BOOL indicating whether or not the action block should be called and the alert dismissed.
 * @param action A block of code to be executed when the button is pressed and validation passes.
 */
- (SCLButton *)addButton:(NSString *)title validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action;

/** Add a Button with a title, a target and a selector to handle when the button is pressed.
 *
 * @param title The text displayed on the button.
 * @param target Add target for particular event.
 * @param selector A method to be executed when the button is pressed.
 */
- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector;

- (void)showTitle:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

@end
