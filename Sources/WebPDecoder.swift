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

    public static func decode(_ webPData: Data) throws -> CGImage {
        var config: CWebP.WebPDecoderConfig = try webPData.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
            var config = CWebP.WebPDecoderConfig()
            if WebPInitDecoderConfig(&config) == 0 {
                throw WebPDecodeError.configFailure
            }

            var features = CWebP.WebPBitstreamFeatures()
            if WebPGetFeatures(body, webPData.count, &features) != VP8_STATUS_OK {
                throw WebPDecodeError.brokenHeader
            }

            config.output.colorspace = MODE_RGBA

            if WebPDecode(body, webPData.count, &config) != VP8_STATUS_OK {
                throw WebPDecodeError.decodeFailure
            }
            return config
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let provider = CGDataProvider(dataInfo: &config,
                                      data: config.output.u.RGBA.rgba,
                                      size: (Int(config.input.width) * Int(config.input.height) * 4),
                                      releaseData: webp_freeWebPData)!
        let cgImage = CGImage(
                width: Int(config.input.width),
                height: Int(config.input.height),
                bitsPerComponent: 8,
                bitsPerPixel: 32,
                bytesPerRow: Int(config.output.u.RGBA.stride),
                space: colorSpace,
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
                provider: provider,
                decode: nil,
                shouldInterpolate: false,
                intent: CGColorRenderingIntent.defaultIntent)!

        return cgImage
    }

    public static func decode(_ webPData: Data, checkStatus: Bool = false) throws -> CGSize {

        let config: WebPDecoderConfig = try webPData.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
            var config = WebPDecoderConfig()
            if WebPInitDecoderConfig(&config) == 0 {
                throw WebPDecodeError.configFailure
            }

            var features = WebPBitstreamFeatures()
            if WebPGetFeatures(body, webPData.count, &features) != VP8_STATUS_OK && checkStatus {
                throw WebPDecodeError.brokenHeader
            }

            config.output.colorspace = MODE_RGBA

            if WebPDecode(body, webPData.count, &config) != VP8_STATUS_OK && checkStatus {
                throw WebPDecodeError.decodeFailure
            }

            return config
        }

        return CGSize(width: Int(config.input.width), height: Int(config.input.height))
    }
}
