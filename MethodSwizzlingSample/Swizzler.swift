//
//  Swizzler.swift
//  MethodSwizzlingSample
//
//  Created by 若森和昌 on 2022/07/14.
//

protocol Swizzler {
    init(targetClass: AnyClass?) throws
    func swizzle()
}

enum SwizzlerError: Error {
    case invalidTargetClass
}
