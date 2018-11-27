//
//  WebPDecoderTests.swift
//  WebPTests iOS
//
//  Created by kojirof on 2018/11/27.
//  Copyright © 2018 satoshi.namai. All rights reserved.
//

import XCTest
import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif
@testable import WebP

class WebPDecoderTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testVP8() {
        let url = Bundle(for: self.classForCoder).url(forResource: "jiro-vp8", withExtension: "webp")!
        let data = try! Data(contentsOf: url)
        let size = try! WebPDecoder.decode(data, checkStatus: true)
        XCTAssertEqual(size, CGSize(width: 1210, height: 907))
    }

    func testVP8L() {
        let url = Bundle(for: self.classForCoder).url(forResource: "jiro-vp8l", withExtension: "webp")!
        let data = try! Data(contentsOf: url)
        let size = try! WebPDecoder.decode(data, checkStatus: true)
        XCTAssertEqual(size, CGSize(width: 1210, height: 907))
    }

    func testVP8Header() {
        let url = Bundle(for: self.classForCoder).url(forResource: "jiro-vp8-only-header", withExtension: "webp")!
        let data = try! Data(contentsOf: url)
        let size = try! WebPDecoder.decode(data, checkStatus: false)
        XCTAssertEqual(size, CGSize(width: 1210, height: 907))
    }

    func testVP8LHeader() {
        let url = Bundle(for: self.classForCoder).url(forResource: "jiro-vp8l-only-header", withExtension: "webp")!
        let data = try! Data(contentsOf: url)
        let size = try! WebPDecoder.decode(data, checkStatus: false)
        XCTAssertEqual(size, CGSize(width: 1210, height: 907))
    }

    /* TODO: Add a test case for VP8X */
//    func testVP8X() {
//        let url = Bundle(for: self.classForCoder).url(forResource: "jiro-vp8x", withExtension: "webp")!
//        let data = try! Data(contentsOf: url)
//        let size = try! WebPDecoder.decode(data, checkStatus: false)
//        XCTAssertEqual(size.0, 1210)
//        XCTAssertEqual(size.1, 907)
//    }

//    func testVP8XHeader() {
//        let url = Bundle(for: self.classForCoder).url(forResource: "jiro-vp8x-only-header", withExtension: "webp")!
//        let data = try! Data(contentsOf: url)
//        let size = try! WebPDecoder.decode(data, checkStatus: false)
//        XCTAssertEqual(size.0, 1210)
//        XCTAssertEqual(size.1, 907)
//    }
}
