#import "ABI46_0_0RNCSafeAreaProviderComponentView.h"

#import <react/renderer/components/safeareacontext/ComponentDescriptors.h>
#import <react/renderer/components/safeareacontext/EventEmitters.h>
#import <react/renderer/components/safeareacontext/Props.h>
#import <react/renderer/components/safeareacontext/ABI46_0_0RCTComponentViewHelpers.h>

#import <ABI46_0_0React/ABI46_0_0RCTFabricComponentsPlugins.h>
#import "ABI46_0_0RNCSafeAreaUtils.h"

using namespace ABI46_0_0facebook::react;

@interface ABI46_0_0RNCSafeAreaProviderComponentView () <ABI46_0_0RCTRNCSafeAreaProviderViewProtocol>
@end

@implementation ABI46_0_0RNCSafeAreaProviderComponentView {
  UIEdgeInsets _currentSafeAreaInsets;
  CGRect _currentFrame;
  BOOL _initialInsetsSent;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ABI46_0_0RNCSafeAreaProviderProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)safeAreaInsetsDidChange
{
  [self invalidateSafeAreaInsets];
}

- (void)invalidateSafeAreaInsets
{
  // This gets called before the view size is set by react-native so
  // make sure to wait so we don't set wrong insets to JS.
  if (CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
    return;
  }

  UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
  CGRect frame = [self convertRect:self.bounds toView:nil];

  if (_initialInsetsSent &&
      UIEdgeInsetsEqualToEdgeInsetsWithThreshold(safeAreaInsets, _currentSafeAreaInsets, 1.0 / ABI46_0_0RCTScreenScale()) &&
      CGRectEqualToRect(frame, _currentFrame)) {
    return;
  }

  _initialInsetsSent = YES;
  _currentSafeAreaInsets = safeAreaInsets;
  _currentFrame = frame;

  [NSNotificationCenter.defaultCenter postNotificationName:ABI46_0_0RNCSafeAreaDidChange object:self userInfo:nil];

  if (_eventEmitter) {
    ABI46_0_0RNCSafeAreaProviderEventEmitter::OnInsetsChange event = {
        .insets =
            {
                .top = safeAreaInsets.top,
                .left = safeAreaInsets.left,
                .bottom = safeAreaInsets.bottom,
                .right = safeAreaInsets.right,
            },
        .frame =
            {
                .x = frame.origin.x,
                .y = frame.origin.y,
                .width = frame.size.width,
                .height = frame.size.height,
            },
    };
    std::static_pointer_cast<ABI46_0_0RNCSafeAreaProviderEventEmitter const>(_eventEmitter)->onInsetsChange(event);
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  [self invalidateSafeAreaInsets];
}

#pragma mark - ABI46_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ABI46_0_0RNCSafeAreaProviderComponentDescriptor>();
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  _currentSafeAreaInsets = UIEdgeInsetsZero;
  _currentFrame = CGRectZero;
  _initialInsetsSent = NO;
}

@end

Class<ABI46_0_0RCTComponentViewProtocol> ABI46_0_0RNCSafeAreaProviderCls(void)
{
  return ABI46_0_0RNCSafeAreaProviderComponentView.class;
}
