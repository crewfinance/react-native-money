#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNMoneyInput, NSObject)


RCT_EXTERN__BLOCKING_SYNCHRONOUS_METHOD(formatMoney:(nonnull NSNumber) value
                                        showFractionDigits:(nonnull BOOL) showFractionDigits
                                        locale:(NSString *) locale)
RCT_EXTERN__BLOCKING_SYNCHRONOUS_METHOD(extractValue:(nonnull NSString) value
                                        showFractionDigits:(nonnull BOOL) showFractionDigits
                                        locale:(NSString *) local)

RCT_EXTERN_METHOD(initializeMoneyInput:(nonnull NSNumber *)reactNode
                  options:(NSDictionary *)option)

@end
