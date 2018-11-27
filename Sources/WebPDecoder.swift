//
// Created by kojirof on 2018-11-27.
// Copyright (c) 2018 satoshi.namai. All rights reserved.
//

import Foundation
import CoreGraphics
import CWebP

public struct WebPDecoder {

    public static func decode(_ webPData: Data) throws -> CGImage {
        var config: CWebP.WebPDecoderConfig = webPData.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
            var config = CWebP.WebPDecoderConfig()
            if WebPInitDecoderConfig(&config) == 0 {
                fatalError("can't init decoder config")
            }

            var features = CWebP.WebPBitstreamFeatures()
            if WebPGetFeatures(body, webPData.count, &features) != VP8_STATUS_OK {
                fatalError("broken header")
            }

            config.output.colorspace = MODE_RGBA

            if WebPDecode(body, webPData.count, &config) != VP8_STATUS_OK {
                fatalError("failure decode")
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

    static func decode(_ webPData: Data, checkStatus: Bool = false) -> (Int, Int) {

        let config: WebPDecoderConfig = webPData.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
            var config = WebPDecoderConfig()
            if WebPInitDecoderConfig(&config) == 0 { return config }

            var features = WebPBitstreamFeatures()
            if WebPGetFeatures(body, webPData.count, &features) != VP8_STATUS_OK && checkStatus { return config }

            config.output.colorspace = MODE_RGBA

            /* If chunk webPData is passed to decoder it always returns fault status.
             * Do not check status in this case. */
            if WebPDecode(body, webPData.count, &config) != VP8_STATUS_OK && checkStatus  { return config }
//            WebPDecode(body, webPData.count, &config)

            return config
        }

        return (Int(config.input.width), Int(config.input.height))
    }
}
