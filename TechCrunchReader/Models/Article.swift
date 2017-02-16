//
//  Article.swift
//  TechCrunchReader
//
//  Created by Vladimír Zdražil on 18/02/2017.
//  Copyright © 2017 Vladimír Zdražil. All rights reserved.
//

import Foundation

struct Article {
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    
    init(author: String, title: String, description: String, url: String, urlToImage: String, publishedAt: Date) {
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
}
