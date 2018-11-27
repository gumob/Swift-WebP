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
