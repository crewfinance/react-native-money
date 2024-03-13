import Foundation

@objc(RNMoneyInput)
class TextInputMask: NSObject, RCTBridgeModule, MoneyInputListener {
    static func moduleName() -> String {
        "MoneyInput"
    }

    @objc static func requiresMainQueueSetup() -> Bool {
        true
    }

    var methodQueue: DispatchQueue {
        bridge.uiManager.methodQueue
    }

    var bridge: RCTBridge!
    var masks: [String: MoneyInputDelegate] = [:]
    var listeners: [String: MoneyInputListener] = [:]
    
    @objc(formatMoney:showFractionDigits:locale:)
    func formatMoney(value: NSNumber, showFractionDigits: Bool, locale: NSString?) -> String {
        let (format, _) = MoneyMask.mask(value: value.doubleValue, locale: String(locale ?? "en_US"), showFractionDigits: showFractionDigits)
        return format
    }

    
    @objc(extractValue:showFractionDigits:locale:)
    func extractValue(value: NSString, showFractionDigits: Bool, locale: NSString?) -> NSNumber {
        return NSNumber(value: MoneyMask.unmask(input: String(value), locale: String(locale ?? "en_US"), showFractionDigits: showFractionDigits))
    }
    
    @objc(initializeMoneyInput:options:)
    func initializeMoneyInput(reactNode: NSNumber, options: NSDictionary) {
        bridge.uiManager.addUIBlock { (uiManager, viewRegistry) in
            DispatchQueue.main.async {
                guard let view = viewRegistry?[reactNode] as? RCTBaseTextInputView else { return }
                let textView = view.backedTextInputView as! RCTUITextField
            
                let locale = options["locale"] as? String
                let showFractionDigits = options["showFractionDigits"] as? Bool
                let maskedDelegate = MoneyInputDelegate(localeIdentifier: locale, showFractionDigits: showFractionDigits) { (_, value) in
                    let textField = textView as! UITextField
                    view.onChange?([
                        "text": value,
                        "target": view.reactTag,
                        "eventCount": view.nativeEventCount,
                    ])
                }
                let key = reactNode.stringValue
                self.listeners[key] = MaskedRCTBackedTextFieldDelegateAdapter(textField: textView)
                maskedDelegate.listener = self.listeners[key]
                self.masks[key] = maskedDelegate

                textView.delegate = self.masks[key]
            }
        }
    }
}

class MaskedRCTBackedTextFieldDelegateAdapter : RCTBackedTextFieldDelegateAdapter, MoneyInputListener {}
