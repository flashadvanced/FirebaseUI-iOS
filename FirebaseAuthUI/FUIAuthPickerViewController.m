//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "FUIAuthPickerViewController.h"

#import <FirebaseAuth/FirebaseAuth.h>
#import "FUIAuthBaseViewController_Internal.h"
#import "FUIAuthSignInButton.h"
#import "FUIAuthStrings.h"
#import "FUIAuthUtils.h"
#import "FUIAuth_Internal.h"
#import "FUIEmailEntryViewController.h"
#import "FUIPrivacyAndTermsOfServiceView.h"

/** @var kSignInButtonWidth
    @brief The width of the sign in buttons.
 */
static const CGFloat kSignInButtonWidth = 220.0f;

/** @var kSignInButtonHeight
    @brief The height of the sign in buttons.
 */
static const CGFloat kSignInButtonHeight = 40.0f;

/** @var kSignInButtonVerticalMargin
    @brief The vertical margin between sign in buttons.
 */
static const CGFloat kSignInButtonVerticalMargin = 24.0f;

/** @var kButtonContainerBottomMargin
    @brief The magin between sign in buttons and the bottom of the screen.
 */
static const CGFloat kButtonContainerBottomMargin = 56.0f;

@implementation FUIAuthPickerViewController {
  UIView *_buttonContainerView;

  IBOutlet FUIPrivacyAndTermsOfServiceView *_privacyPolicyAndTOSView;
}

- (instancetype)initWithAuthUI:(FUIAuth *)authUI {
  return [self initWithNibName:@"FUIAuthPickerViewController"
                        bundle:[FUIAuthUtils bundleNamed:FUIAuthBundleName]
                        authUI:authUI];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                         authUI:(FUIAuth *)authUI {

  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil
                         authUI:authUI];
  if (self) {
    self.title = FUILocalizedString(kStr_AuthPickerTitle);
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  if (!self.authUI.shouldHideCancelButton) {
    UIBarButtonItem *cancelBarButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                      target:self
                                                      action:@selector(cancelAuthorization)];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
  }

  NSInteger numberOfButtons = self.authUI.providers.count;

  CGFloat buttonContainerViewHeight =
      kSignInButtonHeight * numberOfButtons + kSignInButtonVerticalMargin * (numberOfButtons);
  CGRect buttonContainerViewFrame = CGRectMake(0, 0, kSignInButtonWidth, buttonContainerViewHeight);
  _buttonContainerView = [[UIView alloc] initWithFrame:buttonContainerViewFrame];
  [self.view addSubview:_buttonContainerView];

  CGRect buttonFrame = CGRectMake(0, 0, kSignInButtonWidth, kSignInButtonHeight);
  for (id<FUIAuthProvider> providerUI in self.authUI.providers) {
    UIButton *providerButton =
        [[FUIAuthSignInButton alloc] initWithFrame:buttonFrame providerUI:providerUI];
    [providerButton addTarget:self
                       action:@selector(didTapSignInButton:)
             forControlEvents:UIControlEventTouchUpInside];
    [_buttonContainerView addSubview:providerButton];

    // Make the frame for the new button.
    buttonFrame.origin.y += (kSignInButtonHeight + kSignInButtonVerticalMargin);
  }

  _privacyPolicyAndTOSView.authUI = self.authUI;
  [_privacyPolicyAndTOSView useFullMessage];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  CGFloat distanceFromCenterToBottom =
      CGRectGetHeight(_buttonContainerView.frame) / 2.0f + kButtonContainerBottomMargin;
  CGFloat centerY = CGRectGetHeight(self.view.bounds) - distanceFromCenterToBottom;
  // Compensate for bounds adjustment if any.
  centerY += self.view.bounds.origin.y;
  _buttonContainerView.center = CGPointMake(self.view.center.x, centerY);
}

#pragma mark - Actions

- (void)didTapSignInButton:(FUIAuthSignInButton *)button {
  [self.authUI signInWithProviderUI:button.providerUI
           presentingViewController:self
                       defaultValue:nil];
}

@end
