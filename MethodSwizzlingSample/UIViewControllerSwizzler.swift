//
//  UIViewControllerSwizzer.swift
//  MethodSwizzlingSample
//
//  Created by 若森和昌 on 2022/07/14.
//

import UIKit

final class UIViewControllerSwizzer: Swizzler {
    
    let targetClass: UIViewController.Type
    
    init(targetClass: AnyClass?) throws {
        guard let targetClass = targetClass as? UIViewController.Type else {
            throw SwizzlerError.invalidTargetClass
        }
        self.targetClass = targetClass
    }
    
    func swizzle() {
        let targetSelector = #selector(targetClass.viewDidLoad)
        let swizzledSelector = #selector(UIViewController.swizzler_viewDidLoad)
        
        guard let targetMethod = class_getInstanceMethod(targetClass, targetSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
            return
        }
        
        let targetImpl = method_getImplementation(targetMethod)
        let swizzledImpl = method_getImplementation(swizzledMethod)
        
        let didAddMethod = class_addMethod(targetClass, targetSelector, swizzledImpl, method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(targetClass, swizzledSelector, targetImpl, method_getTypeEncoding(targetMethod))
        } else {
            method_exchangeImplementations(targetMethod, swizzledMethod)
        }
        
    }
}

private extension UIViewController {
    
    @objc func swizzler_viewDidLoad() {
        self.swizzler_viewDidLoad()
        NSLog("This is swizzled viewDidLoad.")
    }

}
