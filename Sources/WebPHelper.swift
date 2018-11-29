//
//  WebPHelper.swift
//  WebP
//
//  Created by kojirof on 2018/11/27.
//  Copyright © 2018 satoshi.namai. All rights reserved.
//

import Foundation
import CWebP
import CoreGraphics

internal func webp_freeWebPData(info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> Void {
    if let info = info {
        var config = info.assumingMemoryBound(to: CWebP.WebPDecoderConfig.self).pointee
        WebPFreeDecBuffer(&config.output)
    }
    free(UnsafeMutableRawPointer(mutating: data))
}
extension Data {

    /// Copy bytes
    ///
    /// - Parameters:
    ///   - start: start index
    ///   - end: end index
    /// - Returns: return un deallocate bytes
    func copyBytes(from start: Int, to end: Int) -> UnsafeMutablePointer<UInt8> {
        assert(start >= 0 && end >= 0, "start and end must be greater than 0")
        assert(end >= start, "end index must be greater than start")
        let length = end - start
        assert(self.count >= length, "data count must be >= length")
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        bytes.initialize(to: 0)
        if start < self.count && end <= self.count {
            self.copyBytes(to: bytes, from: start..<end)
        } else {
            print("--------------")
        }
        return bytes
    }

    /// Copy all bytes
    ///
    /// - Returns: return un deallocate bytes
    public func copyAllBytes() -> UnsafeMutablePointer<UInt8> {
        return self.copyBytes(from: 0, to: self.count)
    }
}