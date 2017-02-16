//
//  JSONHelperClassTests.swift
//  TechCrunchReader
//
//  Created by Vladimír Zdražil on 23/02/2017.
//  Copyright © 2017 Vladimír Zdražil. All rights reserved.
//

import XCTest
@testable import TechCrunchReader

class JSONHelperClassTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetURLStringWithDimensions() {
        let url = "https://tctechcrunch2011.files.wordpress.com/2016/08/bradley-tusk.jpeg"
        let urlImage = JSONRequestHelper.getImageURLStringWithDimension(width: 25.0,
                                                                        height: 50.0,
                                                                        crop: true,
                                                                        url: url)
        let finalImageURL = "https://tctechcrunch2011.files.wordpress.com/2016/08/bradley-tusk.jpeg?w=25.0&h=50.0&crop=1"
        XCTAssert(urlImage == finalImageURL)
    }
    
    func testGetURLWithoutParameters() {
        let inputURL = NSURL(string: "http://www.google.com/?abc&lang=cs")
        let outputURL = JSONRequestHelper.getURLWithoutParameters(inputURL: inputURL!)
        let finalURL = "http://www.google.com/"
        XCTAssert(outputURL == finalURL)
    }
}
