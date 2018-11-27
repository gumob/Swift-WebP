//
//  WebPEncoderTests.swift
//  WebP
//
//  Created by Namai Satoshi on 2016/11/12.
//  Copyright © 2016年 satoshi.namai. All rights reserved.
//

import XCTest
import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif
@testable import WebP

class WebPEncoderTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let path = Bundle(for: self.classForCoder).resourcePath!.appendingFormat("/jiro.jpg")
        #if os(macOS)
        let image = NSImage(contentsOfFile: path)!
        #else
        let image = UIImage(contentsOfFile: path)!
        #endif
        let encoder = WebPEncoder()
        let webPImage = try! encoder.encode(image, config: .preset(.photo, quality: 10))
        XCTAssertNotNil(webPImage)
    }
}
