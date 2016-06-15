//
//  SCLAlertView.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertView.h"
#import "SCLAlertViewResponder.h"
#import "SCLTimerDisplay.h"
#import "SCLMacros.h"
#import <Masonry/Masonry.h>

#if defined(__has_feature) && __has_feature(modules)
@import AVFoundation;
#else
#import <AVFoundation/AVFoundation.h>
#endif

#define KEYBOARD_HEIGHT 80
#define PREDICTION_BAR_HEIGHT 40
#define ADD_BUTTON_PADDING 0.0f
#define DEFAULT_WINDOW_WIDTH 240

@interface SCLAlertView ()  <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *inputs;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) NSString *titleFontFamily;
@property (nonatomic, strong) NSString *bodyTextFontFamily;
@property (nonatomic, strong) NSString *buttonsFontFamily;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIWindow *previousWindow;
@property (nonatomic, strong) UIWindow *SCLAlertWindow;
@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> restoreInteractivePopGestureDelegate;
@property (nonatomic) BOOL canAddObservers;
@property (nonatomic) BOOL keyboardIsVisible;
@property (nonatomic) BOOL usingNewWindow;
@property (nonatomic) BOOL restoreInteractivePopGestureEnabled;
@property (nonatomic) CGFloat backgroundOpacity;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic) CGFloat bodyFontSize;
@property (nonatomic) CGFloat buttonsFontSize;
@property (nonatomic) CGFloat windowHeight;
@property (nonatomic) CGFloat windowWidth;
@property (nonatomic) CGFloat subTitleHeight;
@property (nonatomic) CGFloat subTitleY;

@end

@implementation SCLAlertView

CGFloat kCircleHeight;
CGFloat kTitleTop;
CGFloat kTitleHeight;

// Timer
NSTimer *durationTimer;
SCLTimerDisplay *buttonTimer;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"NSCoding not supported"
                                 userInfo:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupViewWindowWidth:DEFAULT_WINDOW_WIDTH];
    }
    return self;
}

- (instancetype)initWithWindowWidth:(CGFloat)windowWidth
{
    self = [super init];
    if (self)
    {
        [self setupViewWindowWidth:windowWidth];
    }
    return self;
}

- (instancetype)initWithNewWindow
{
    self = [self initWithWindowWidth:DEFAULT_WINDOW_WIDTH];
    if(self)
    {
        [self setupNewWindow];
    }
    return self;
}

- (instancetype)initWithNewWindowWidth:(CGFloat)windowWidth
{
    self = [self initWithWindowWidth:windowWidth];
    if(self)
    {
        [self setupNewWindow];
    }
    return self;
}

- (void)dealloc
{
    [self removeObservers];
    [self restoreInteractivePopGesture];
}

+ (instancetype)sharedInstance
{
    static id localConnection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localConnection = [[self alloc] init];
    });
    
    return localConnection;
}

- (void)addObservers
{
    if(_canAddObservers)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        _canAddObservers = NO;
    }
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Setup view

- (void)setupViewWindowWidth:(CGFloat)windowWidth
{
    // Default values
    kCircleHeight = 0.0f;
    kTitleTop = 10.0f;
    kTitleHeight = 40.0f;
    self.subTitleY = 54.0f;
    self.subTitleHeight = 90.0f;
    self.windowWidth = windowWidth;
    self.windowHeight = 160.0f;
    self.shouldDismissOnTapOutside = NO;
    self.usingNewWindow = NO;
    self.canAddObservers = YES;
    self.keyboardIsVisible = NO;
    self.hideAnimationType = FadeOut;
    self.showAnimationType = SlideInFromTop;
    self.backgroundType = Shadow;
    
    // Font
    _titleFontFamily = @"HelveticaNeue";
    _bodyTextFontFamily = @"HelveticaNeue";
    _buttonsFontFamily = @"HelveticaNeue";
    _titleFontSize = 20.0f;
    _bodyFontSize = 16.0f;
    _buttonsFontSize = 18.0f;
    
    // Init
    _labelTitle = [[UILabel alloc] init];
    _viewText = [[UITextView alloc] init];
    _contentView = [[UIView alloc] init];
    _backgroundView = [[UIImageView alloc]initWithFrame:[self mainScreenFrame]];
    _buttons = [[NSMutableArray alloc] init];
    _inputs = [[NSMutableArray alloc] init];
    
    // Add Subviews
    [self.view addSubview:_contentView];
    
    // Background View
    _backgroundView.userInteractionEnabled = YES;
    
    // Content View
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 10.0f;
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.borderWidth = .0f;
    [_contentView addSubview:_labelTitle];
    [_contentView addSubview:_viewText];
    
    // Title
    _labelTitle.numberOfLines = 1;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.font = [UIFont fontWithName:_titleFontFamily size:_titleFontSize];
    _labelTitle.frame = CGRectMake(12.0f, kTitleTop, _windowWidth - 24.0f, kTitleHeight);
    
    // View text
    _viewText.editable = NO;
    _viewText.allowsEditingTextAttributes = YES;
    _viewText.textAlignment = NSTextAlignmentCenter;
    _viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
    _viewText.frame = CGRectMake(12.0f, _subTitleY, _windowWidth - 24.0f, _subTitleHeight);
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        _viewText.textContainerInset = UIEdgeInsetsZero;
        _viewText.textContainer.lineFragmentPadding = 0;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Colors
    self.backgroundViewColor = [UIColor whiteColor];
    _labelTitle.textColor = UIColorFromHEX(0x4D4D4D); //Dark Grey
    _viewText.textColor = UIColorFromHEX(0x4D4D4D); //Dark Grey
    _contentView.layer.borderColor = UIColorFromHEX(0xCCCCCC).CGColor; //Light Grey
}

- (void)setupNewWindow
{
    // Create a new one to show the alert
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[self mainScreenFrame]];
    alertWindow.windowLevel = UIWindowLevelAlert;
    alertWindow.backgroundColor = [UIColor clearColor];
    alertWindow.rootViewController = self;
    self.SCLAlertWindow = alertWindow;
    
    self.usingNewWindow = YES;
}

#pragma mark - View Cycle

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self setFrame];
}

- (void)setFrame {
    
    CGSize sz = [self mainScreenFrame].size;
    
    CGFloat x = (sz.width - _windowWidth) / 2;
    CGFloat y = (sz.height - _windowHeight -  (kCircleHeight / 8)) / 2;
    
    _contentView.frame = CGRectMake(x, y, _windowWidth, _windowHeight);
    
    {
        // Text fields
        CGFloat y = (_labelTitle.text == nil) ? (kCircleHeight - 20.0f) : 50.0f;
        y += _subTitleHeight + 14.0f;
        for (SCLTextView *textField in _inputs)
        {
            textField.frame = CGRectMake(12.0f, y, _windowWidth - 24.0f, textField.frame.size.height);
            textField.layer.cornerRadius = 3.0f;
            y += textField.frame.size.height + 10.0f;
        }
        
        // Buttons
        for (SCLButton *btn in _buttons)
        {
            btn.frame = CGRectMake(0.0f, y, btn.frame.size.width, btn.frame.size.height);
            y += btn.frame.size.height + 1.0f;
        }
    }
}

#pragma mark - UIViewController

- (BOOL)prefersStatusBarHidden
{
  return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return self.statusBarStyle;
}

#pragma mark - Handle gesture

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (_shouldDismissOnTapOutside)
    {
        BOOL hide = _shouldDismissOnTapOutside;
        
        for(SCLTextView *txt in _inputs)
        {
            // Check if there is any keyboard on screen and dismiss
            if (txt.editing)
            {
                [txt resignFirstResponder];
                hide = NO;
            }
        }
        if(hide)[self hideView];
    }
}

- (void)setShouldDismissOnTapOutside:(BOOL)shouldDismissOnTapOutside
{
    _shouldDismissOnTapOutside = shouldDismissOnTapOutside;
    
    if(_shouldDismissOnTapOutside)
    {
        self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_usingNewWindow ? _SCLAlertWindow : _backgroundView addGestureRecognizer:_gestureRecognizer];
    }
}

- (void)disableInteractivePopGesture
{
    UINavigationController *navigationController;
    
    if([_rootViewController isKindOfClass:[UINavigationController class]])
    {
        navigationController = ((UINavigationController*)_rootViewController);
    }
    else
    {
        navigationController = _rootViewController.navigationController;
    }
    
    // Disable iOS 7 back gesture
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        _restoreInteractivePopGestureEnabled = navigationController.interactivePopGestureRecognizer.enabled;
        _restoreInteractivePopGestureDelegate = navigationController.interactivePopGestureRecognizer.delegate;
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)restoreInteractivePopGesture
{
    UINavigationController *navigationController;
    
    if([_rootViewController isKindOfClass:[UINavigationController class]])
    {
        navigationController = ((UINavigationController*)_rootViewController);
    }
    else
    {
        navigationController = _rootViewController.navigationController;
    }
    
    // Restore iOS 7 back gesture
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = _restoreInteractivePopGestureEnabled;
        navigationController.interactivePopGestureRecognizer.delegate = _restoreInteractivePopGestureDelegate;
    }
}

#pragma mark - Custom Fonts

- (void)setTitleFontFamily:(NSString *)titleFontFamily withSize:(CGFloat)size
{
    self.titleFontFamily = titleFontFamily;
    self.titleFontSize = size;
    self.labelTitle.font = [UIFont fontWithName:_titleFontFamily size:_titleFontSize];
}

- (void)setBodyTextFontFamily:(NSString *)bodyTextFontFamily withSize:(CGFloat)size
{
    self.bodyTextFontFamily = bodyTextFontFamily;
    self.bodyFontSize = size;
    self.viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
}

- (void)setButtonsTextFontFamily:(NSString *)buttonsFontFamily withSize:(CGFloat)size
{
    self.buttonsFontFamily = buttonsFontFamily;
    self.buttonsFontSize = size;
}

#pragma mark - Background Color

- (void)setBackgroundViewColor:(UIColor *)backgroundViewColor
{
    _backgroundViewColor = backgroundViewColor;
    _contentView.backgroundColor = _backgroundViewColor;
    _viewText.backgroundColor = _backgroundViewColor;
}

#pragma mark - Sound

- (void)setSoundURL:(NSURL *)soundURL
{
    NSError *error;
    _soundURL = soundURL;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_soundURL error:&error];
}

#pragma mark - Subtitle Height

- (void)setSubTitleHeight:(CGFloat)value
{
    _subTitleHeight = value;
}

#pragma mark - TextField

- (SCLTextView *)addTextField:(NSString *)title
{
    [self addObservers];
    
    // Add text field
    SCLTextView *txt = [[SCLTextView alloc] init];
    txt.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
    txt.delegate = self;
    
    // Update view height
    self.windowHeight += txt.bounds.size.height + 10.0f;
    
    if (title != nil)
    {
        txt.placeholder = title;
    }
    
    [_contentView addSubview:txt];
    [_inputs addObject:txt];
    
    // If there are other fields in the inputs array, get the previous field and set the
    // return key type on that to next.
    if (_inputs.count > 1)
    {
        NSUInteger indexOfCurrentField = [_inputs indexOfObject:txt];
        SCLTextView *priorField = _inputs[indexOfCurrentField - 1];
        priorField.returnKeyType = UIReturnKeyNext;
    }
    return txt;
}

- (void)addCustomTextField:(UITextField *)textField
{
    // Update view height
    self.windowHeight += textField.bounds.size.height + 10.0f;
    
    [_contentView addSubview:textField];
    [_inputs addObject:textField];
    
    // If there are other fields in the inputs array, get the previous field and set the
    // return key type on that to next.
    if (_inputs.count > 1)
    {
        NSUInteger indexOfCurrentField = [_inputs indexOfObject:textField];
        UITextField *priorField = _inputs[indexOfCurrentField - 1];
        priorField.returnKeyType = UIReturnKeyNext;
    }
}

# pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // If this is the last object in the inputs array, resign first responder
    // as the form is at the end.
    if (textField == _inputs.lastObject)
    {
        [textField resignFirstResponder];
    }
    else // Otherwise find the next field and make it first responder.
    {
        NSUInteger indexOfCurrentField = [_inputs indexOfObject:textField];
        UITextField *nextField = _inputs[indexOfCurrentField + 1];
        [nextField becomeFirstResponder];
    }
    return NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(_keyboardIsVisible) return;
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect f = self.view.frame;
        f.origin.y -= KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT;
        self.view.frame = f;
    }];
    _keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if(!_keyboardIsVisible) return;
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect f = self.view.frame;
        f.origin.y += KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT;
        self.view.frame = f;
    }];
    _keyboardIsVisible = NO;
}

#pragma mark - Buttons

- (SCLButton *)addButton:(NSString *)title
{
    // Add button
    SCLButton *btn = [[SCLButton alloc] initWithWindowWidth:self.windowWidth];
    btn.layer.masksToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:_buttonsFontFamily size:_buttonsFontSize];
    
    // Update view height
    self.windowHeight += (btn.frame.size.height + ADD_BUTTON_PADDING);
    
    [_contentView addSubview:btn];
    [_buttons addObject:btn];
    
    return btn;
}

- (SCLButton *)addDoneButtonWithTitle:(NSString *)title
{
    SCLButton *btn = [self addButton:title];
    
    if (_completeButtonFormatBlock != nil)
    {
        btn.completeButtonFormatBlock = _completeButtonFormatBlock;
    }
    
    [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title actionBlock:(SCLActionBlock)action
{
    SCLButton *btn = [self addButton:title];
    
    if (_buttonFormatBlock != nil)
    {
        btn.buttonFormatBlock = _buttonFormatBlock;
    }
    
    btn.actionType = SCLBlock;
    btn.actionBlock = action;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action
{
    SCLButton *btn = [self addButton:title actionBlock:action];
    btn.validationBlock = validationBlock;
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector
{
    SCLButton *btn = [self addButton:title];
    btn.actionType = SCLSelector;
    btn.target = target;
    btn.selector = selector;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)buttonTapped:(SCLButton *)btn
{
    // Cancel Countdown timer
    [buttonTimer cancelTimer];
    
    // If the button has a validation block, and the validation block returns NO, validation
    // failed, so we should bail.
    if (btn.validationBlock && !btn.validationBlock()) {
        return;
    }
    if([self isVisible])
    {
        [self hideView];
    }

    if (btn.actionType == SCLBlock)
    {
        if (btn.actionBlock)
            btn.actionBlock();
    }
    else if (btn.actionType == SCLSelector)
    {
        UIControl *ctrl = [[UIControl alloc] init];
        [ctrl sendAction:btn.selector to:btn.target forEvent:nil];
    }
    else
    {
        NSLog(@"Unknown action type for button");
    }
}

#pragma mark - Button Timer

- (void)addTimerToButtonIndex:(NSInteger)buttonIndex reverse:(BOOL)reverse
{
    buttonIndex = MAX(buttonIndex, 0);
    buttonIndex = MIN(buttonIndex, [_buttons count]);
    
    buttonTimer = [[SCLTimerDisplay alloc] initWithOrigin:CGPointMake(5, 5) radius:13 lineWidth:4];
    buttonTimer.buttonIndex = buttonIndex;
    buttonTimer.reverse = reverse;
}

#pragma mark - Show Alert

- (void)showTitle:(NSString *)title
         subTitle:(NSString *)subTitle
 closeButtonTitle:(NSString *)closeButtonTitle
         duration:(NSTimeInterval)duration {
    [self showWithColor:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle];
}

- (SCLAlertViewResponder *)showWithColor:(UIColor *)color
                                   title:(NSString *)title
                                subTitle:(NSString *)subTitle
                                duration:(NSTimeInterval)duration
                            completeText:(NSString *)completeText
{
//    self.windowHeight = 160.0f;
    
    if(_usingNewWindow)
    {
        // Save previous window
        self.previousWindow = [UIApplication sharedApplication].keyWindow;
        self.backgroundView.frame = _SCLAlertWindow.bounds;
        
        // Add window subview
        [_SCLAlertWindow insertSubview:_backgroundView atIndex:0];
    }
    
    self.view.alpha = 0.0f;
    [self setBackground];
    
    // Alert color/icon
    UIColor *viewColor;
    
    // Icon style
    viewColor = color;
    
    // Custom Alert color
    if(_customViewColor)
    {
        viewColor = _customViewColor;
    }
    
    // Title
    if([title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
    {
        self.labelTitle.text = title;
//        self.windowHeight += _labelTitle.frame.size.height;
    }
    else
    {
        // Title is nil, we can move the body message to center and remove it from superView
        self.windowHeight -= _labelTitle.frame.size.height;
        [_labelTitle removeFromSuperview];
        
        _subTitleY = kCircleHeight - 20;
    }
    
    // Subtitle
    if([subTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
    {
        // No custom text
        if (_attributedFormatBlock == nil)
        {
            _viewText.text = subTitle;
        }
        else
        {
            self.viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
            _viewText.attributedText = self.attributedFormatBlock(subTitle);
        }
        
        // Adjust text view size, if necessary
        CGSize sz = CGSizeMake(_windowWidth - 24.0f, CGFLOAT_MAX);
        
        CGSize size = [_viewText sizeThatFits:sz];
        
        CGFloat ht = ceilf(size.height);
        if (ht <= _subTitleHeight)
        {
            self.windowHeight -= (_subTitleHeight - ht);
            self.subTitleHeight = ht;
        }
        else
        {
            self.windowHeight += (ht - _subTitleHeight + 10);
//            self.windowHeight += (ht - _subTitleHeight);
            self.subTitleHeight = ht;
        }
        _viewText.frame = CGRectMake(12.0f, _subTitleY, _windowWidth - 24.0f, _subTitleHeight);
    }
    else
    {
        // Subtitle is nil, we can move the title to center and remove it from superView
        self.subTitleHeight = 0.0f;
        self.windowHeight -= _viewText.frame.size.height;
        [_viewText removeFromSuperview];
        
        // Move up
        _labelTitle.frame = CGRectMake(12.0f, 15.0f, _windowWidth - 24.0f, kTitleHeight);
    }
    
//    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _windowWidth, _windowHeight);
    
    // Play sound, if necessary
    if(_soundURL != nil)
    {
        if (_audioPlayer == nil)
        {
            NSLog(@"You need to set your sound file first");
        }
        else
        {
            [_audioPlayer play];
        }
    }
    
    // Add button, if necessary
    if(completeText != nil)
    {
        [self addDoneButtonWithTitle:completeText];
    }
    
    for (SCLTextView *textField in _inputs)
    {
        textField.layer.borderColor = viewColor.CGColor;
    }
    
    for (SCLButton *btn in _buttons)
    {
        if (!btn.defaultBackgroundColor) {
            btn.defaultBackgroundColor = [UIColor whiteColor];
        }
        
        if (btn.completeButtonFormatBlock != nil)
        {
            [btn parseConfig:btn.completeButtonFormatBlock()];
        }
        else if (btn.buttonFormatBlock != nil)
        {
            [btn parseConfig:btn.buttonFormatBlock()];
        }
    }
    
    // Adding duration
    if (duration > 0)
    {
        [durationTimer invalidate];
        
        if (buttonTimer && _buttons.count > 0) {
            
            SCLButton *btn = _buttons[buttonTimer.buttonIndex];
            btn.timer = buttonTimer;
            [buttonTimer startTimerWithTimeLimit:duration completed:^{
                [self buttonTapped:btn];
            }];
        }
        else
        {
            durationTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                             target:self
                                                           selector:@selector(hideView)
                                                           userInfo:nil
                                                            repeats:NO];
        }
    }
    
    if(_usingNewWindow)
    {
        [_SCLAlertWindow makeKeyAndVisible];
    }
    
    [self setFrame];
    // Show the alert view
    [self showView];
    
    // Chainable objects
    return [[SCLAlertViewResponder alloc] init:self];
}

#pragma mark - Visibility

- (BOOL)isVisible
{
    return (self.view.alpha);
}

- (void)alertIsDismissed:(DismissBlock)dismissBlock
{
    self.dismissBlock = dismissBlock;
}

- (CGRect)mainScreenFrame
{
    return [self isAppExtension] ? _extensionBounds : [UIApplication sharedApplication].keyWindow.bounds;
}

- (BOOL)isAppExtension
{
    return [[NSBundle mainBundle].executablePath rangeOfString:@".appex/"].location != NSNotFound;
}

#pragma mark - Background Effects

- (void)makeShadowBackground
{
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.5f;
    _backgroundOpacity = 0.5f;
}

- (void)makeTransparentBackground
{
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.alpha = 0.0f;
    _backgroundOpacity = 1.0f;
}

- (void)setBackground
{
    switch (_backgroundType)
    {
        case Shadow:
            [self makeShadowBackground];
            break;
            
        case Transparent:
            [self makeTransparentBackground];
            break;
    }
}

#pragma mark - Show Alert

- (void)showView
{
    switch (_showAnimationType)
    {
        case FadeIn:
            [self fadeIn];
            break;
            
        case SlideInFromBottom:
            [self slideInFromBottom];
            break;
            
        case SlideInFromTop:
            [self slideInFromTop];
            break;
            
        case SlideInFromLeft:
            [self slideInFromLeft];
            break;
            
        case SlideInFromRight:
            [self slideInFromRight];
            break;
            
        case SlideInFromCenter:
            [self slideInFromCenter];
            break;
            
        case SlideInToCenter:
            [self slideInToCenter];
            break;
    }
}

#pragma mark - Hide Alert

- (void)hideView
{
    switch (_hideAnimationType)
    {
        case FadeOut:
            [self fadeOut];
            break;
            
        case SlideOutToBottom:
            [self slideOutToBottom];
            break;
            
        case SlideOutToTop:
            [self slideOutToTop];
            break;
            
        case SlideOutToLeft:
            [self slideOutToLeft];
            break;
            
        case SlideOutToRight:
            [self slideOutToRight];
            break;
            
        case SlideOutToCenter:
            [self slideOutToCenter];
            break;
            
        case SlideOutFromCenter:
            [self slideOutFromCenter];
            break;
    }
    
    if (self.dismissBlock)
    {
        self.dismissBlock();
    }
    
    if(_usingNewWindow)
    {
        // Restore previous window
        [self.previousWindow makeKeyAndVisible];
        self.previousWindow = nil;
    }
}

#pragma mark - Hide Animations

- (void)fadeOut
{
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = 0.0f;
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self.backgroundView removeFromSuperview];
        if(_usingNewWindow)
        {
            // Remove current window            
            [self.SCLAlertWindow setHidden:YES];
            self.SCLAlertWindow = nil;
        }
        else
        {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
    }];
}

- (void)slideOutToBottom
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y += self.backgroundView.frame.size.height;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToTop
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= self.backgroundView.frame.size.height;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToLeft
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x -= self.backgroundView.frame.size.width;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToRight
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x += self.backgroundView.frame.size.width;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToCenter
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform =
        CGAffineTransformConcat(CGAffineTransformIdentity,
                                CGAffineTransformMakeScale(0.1f, 0.1f));
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutFromCenter
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform =
        CGAffineTransformConcat(CGAffineTransformIdentity,
                                CGAffineTransformMakeScale(3.0f, 3.0f));
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

#pragma mark - Show Animations

- (void)fadeIn
{
    self.backgroundView.alpha = 0.0f;
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundView.alpha = _backgroundOpacity;
                         self.view.alpha = 1.0f;
                     }
                     completion:nil];
}

- (void)slideInFromTop
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        //From Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.y = -self.backgroundView.frame.size.height;
        self.view.frame = frame;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundView.alpha = _backgroundOpacity;
            
            //To Frame
            CGRect frame = self.backgroundView.frame;
            frame.origin.y = 0.0f;
            self.view.frame = frame;
            
            self.view.alpha = 1.0f;
        } completion:^(BOOL completed) {
            [UIView animateWithDuration:0.2f animations:^{
                self.view.center = _backgroundView.center;
            }];
        }];
    }
    else {
        //From Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.y = -self.backgroundView.frame.size.height;
        self.view.frame = frame;
        
        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.5f options:0 animations:^{
            self.backgroundView.alpha = _backgroundOpacity;
            
            //To Frame
            CGRect frame = self.backgroundView.frame;
            frame.origin.y = 0.0f;
            self.view.frame = frame;
            
            self.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            // nothing
        }];
    }
}

- (void)slideInFromBottom
{
    //From Frame
    CGRect frame = self.backgroundView.frame;
    frame.origin.y = self.backgroundView.frame.size.height;
    self.view.frame = frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.y = 0.0f;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        }];
    }];
}

- (void)slideInFromLeft
{
    //From Frame
    CGRect frame = self.backgroundView.frame;
    frame.origin.x = -self.backgroundView.frame.size.width;
    self.view.frame = frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.x = 0.0f;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        }];
    }];
}

- (void)slideInFromRight
{
    //From Frame
    CGRect frame = self.backgroundView.frame;
    frame.origin.x = self.backgroundView.frame.size.width;
    self.view.frame = frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.x = 0.0f;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        }];
    }];
}

- (void)slideInFromCenter
{
    //From Frame
    self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                  CGAffineTransformMakeScale(3.0f, 3.0f));
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                      CGAffineTransformMakeScale(1.0f, 1.0f));
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        }];
    }];
}

- (void)slideInToCenter
{
    //From Frame
    self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                  CGAffineTransformMakeScale(0.1f, 0.1f));
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                      CGAffineTransformMakeScale(1.0f, 1.0f));
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        }];
    }];
}

@end
