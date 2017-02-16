//
//  ArticleClassTests.swift
//  TechCrunchReader
//
//  Created by Vladimír Zdražil on 23/02/2017.
//  Copyright © 2017 Vladimír Zdražil. All rights reserved.
//

import XCTest
@testable import TechCrunchReader

class ArticleClassTests: XCTestCase {
    // Create Article
    let article = Article(author: "Jonathan Shieber",
                          title: "Hear Bradley Tusk speak on startups and politics at our DC meetup",
                          description: "We're excited to announce that Bradley Tusk",
                          url: "https://techcrunch.com/2017/02/17/hear-bradley-tusk-speak-on-startups-and-politics-at-our-dc-meetup/",
                          urlToImage: "https://tctechcrunch2011.files.wordpress.com/2016/08/bradley-tusk.jpeg",
                          publishedAt: Date(timeIntervalSinceReferenceDate: -123456789.0))
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReturnsAuthor() {
        XCTAssert(article.author == "Jonathan Shieber")
    }
    
    func testReturnsTitle() {
        XCTAssert(article.title == "Hear Bradley Tusk speak on startups and politics at our DC meetup")
    }
    
    func testReturnsDescription() {
        XCTAssert(article.description == "We're excited to announce that Bradley Tusk")
    }
    
    func testReturnsURL() {
        XCTAssert(article.url == "https://techcrunch.com/2017/02/17/hear-bradley-tusk-speak-on-startups-and-politics-at-our-dc-meetup/")
    }
    
    func testReturnsURLToImage() {
        XCTAssert(article.urlToImage == "https://tctechcrunch2011.files.wordpress.com/2016/08/bradley-tusk.jpeg")
    }
    
    func testReturnPublishedAt() {
        XCTAssert(article.publishedAt == Date(timeIntervalSinceReferenceDate: -123456789.0))
    }
}
