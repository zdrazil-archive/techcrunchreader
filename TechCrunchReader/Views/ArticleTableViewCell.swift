//
//  ArticleTableViewCell.swift
//  TechCrunchReader
//
//  Created by Vladimír Zdražil on 20/02/2017.
//  Copyright © 2017 Vladimír Zdražil. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Cell settings
        textLabel?.adjustsFontSizeToFitWidth = true
        textLabel?.minimumScaleFactor = 0.8
        textLabel?.numberOfLines = 2
        
        self.imageView?.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        imageView?.clipsToBounds = true
        
        // Set frame size to manage images that have not been cropped correctly
        // or at all
        guard let limgW = self.imageView?.image?.size.width else {
            return
        }
        
        // If image exists, shift text labels to the right
        if limgW > CGFloat(0) {
            self.textLabel?.frame = CGRect(x: 80, y: (self.textLabel?.frame.origin.y)!, width: (self.textLabel?.frame.size.width)!, height: (self.textLabel?.frame.size.height)!)
            self.detailTextLabel?.frame = CGRect(x: 80, y: (self.detailTextLabel?.frame.origin.y)!, width: (self.detailTextLabel?.frame.size.width)!, height: (self.detailTextLabel?.frame.size.height)!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        
        // Set frame size to manage images that have not been cropped correctly
        // or at all
        guard let limgW = self.imageView?.image?.size.width else {
            return
        }
        
        // If image exists, shift text labels to the right
        if limgW > CGFloat(0) {
            self.textLabel?.frame = CGRect(x: 80, y: (self.textLabel?.frame.origin.y)!, width: (self.textLabel?.frame.size.width)!, height: (self.textLabel?.frame.size.height)!)
            self.detailTextLabel?.frame = CGRect(x: 80, y: (self.detailTextLabel?.frame.origin.y)!, width: (self.detailTextLabel?.frame.size.width)!, height: (self.detailTextLabel?.frame.size.height)!)
        }
    }
    
    // Prevent loading wrong image in reused cells, eq. when scrolling
    // http://stackoverflow.com/questions/18406956/sdwebimage-to-load-image-in-custom-uitableviewcell-but-when-scroll-the-image-lo
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancel pending download request
        self.imageView?.sd_cancelCurrentAnimationImagesLoad()
        // Clear out reused image
        self.imageView?.image = nil
    }
}
