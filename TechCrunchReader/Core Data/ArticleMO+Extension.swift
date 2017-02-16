//
//  Article.swift
//  TechCrunchReader
//
//  Created by Vladimír Zdražil on 18/02/2017.
//  Copyright © 2017 Vladimír Zdražil. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension ArticleMO {
    
    class func createArticleMOEntity(article: Article, inManagedObjectContext context: NSManagedObjectContext) -> ArticleMO? {
        if let articleMO = NSEntityDescription.insertNewObject(forEntityName: "Article", into: context) as? ArticleMO {
            articleMO.author = article.author
            articleMO.title = article.title
            articleMO.articleDescription = article.description
            articleMO.url = article.url
            articleMO.urlImage = article.urlToImage
            articleMO.publishedAt = article.publishedAt as NSDate?
            return articleMO
        }
        return nil
    }
}
