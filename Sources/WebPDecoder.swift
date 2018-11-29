//
// Created by kojirof on 2018-11-27.
// Copyright (c) 2018 satoshi.namai. All rights reserved.
//

import Foundation
import CoreGraphics
import CWebP

enum WebPDecodeError: Int, Error {
    case ok = 0
    case configFailure         // configuration failure
    case brokenHeader          // broken header
    case decodeFailure         // decode failure
}

public struct WebPDecoder {

//    public static func decode(_ webPData: Data, checkStatus: Bool = false) throws -> CGSize {
//
//        var config: WebPDecoderConfig = try webPData.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
//            var config = WebPDecoderConfig()
//            if WebPInitDecoderConfig(&config) == 0 {
//                throw WebPDecodeError.configFailure
//            }
//            defer {
//            }
//
//            var features = WebPBitstreamFeatures()
//            if WebPGetFeatures(body, webPData.count, &features) != VP8_STATUS_OK && checkStatus {
//                throw WebPDecodeError.brokenHeader
//            }
//
//            config.output.colorspace = MODE_RGBA
//
//            if WebPDecode(body, webPData.count, &config) != VP8_STATUS_OK && checkStatus {
//                throw WebPDecodeError.decodeFailure
//            }
//
//            return config
//        }
//
//        let size: CGSize = CGSize(width: Int(config.input.width), height: Int(config.input.height))
//        WebPFreeDecBuffer(&config.output)
//        return size
//    }

    public static func decode(_ webPData: Data, checkStatus: Bool = false) throws -> CGSize {
        var width: CInt = 0
        var height: CInt = 0
        if webPInfo(webPdata: webPData, width: &width, height: &height) != true && checkStatus {
            throw WebPDecodeError.decodeFailure
        }
        return CGSize(width: Int(width), height: Int(height))
    }

    static private func webPInfo(webPdata: Data, width: inout CInt, height: inout CInt) -> Bool {
        let statusOk = Int32(1)
        let bytes: UnsafeMutablePointer<UInt8> = webPdata.copyAllBytes()
        if (WebPGetInfo(bytes, webPdata.count, &width, &height) == statusOk) {
            return true
        }
        return false
    }
}
