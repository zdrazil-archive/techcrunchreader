//
//  MainView.swift
//  TechCrunchReader
//
//  Created by Vladimír Zdražil on 17/02/2017.
//  Copyright © 2017 Vladimír Zdražil. All rights reserved.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    // previewView properties
    private(set) var navigationBar = UINavigationBar()
    private(set) var previewView = UIView()
    private(set) var previewImageView = UIImageView()
    private(set) var articleTitleLabel = UILabel()
    private(set) var publishedDateLabel = UILabel()
    private(set) var authorLabel = UILabel()
    private(set) var descriptionLabel = UILabel()
    
    // feedView properties
    private(set) var feedTableView = UITableView()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.white
        self.frame = CGRect.zero
        initializeUI()
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        // FIXME: - Changes background color under status bar - Is there a better way?
        self.backgroundColor = UIColor.black
        
        // Add main subviews
        addSubview(previewView)
        addSubview(feedTableView)
        
        // Add navigation bar
        previewView.addSubview(navigationBar)
        
        // Prepare share button
        let shareButton = UINavigationItem(title: "")
        navigationBar.items?.append(shareButton)
        
        // Make navigation bar fully transparent
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        // Add subviews
        previewView.addSubview(previewImageView)
        previewView.addSubview(articleTitleLabel)
        previewView.addSubview(publishedDateLabel)
        previewView.addSubview(authorLabel)
        previewView.addSubview(descriptionLabel)
        
        // Settings for everything in previewView
        previewView.backgroundColor = UIColor.white
        previewImageView.contentMode = .scaleToFill
        previewImageView.clipsToBounds = true
        
        // Text settings in Preview View
        articleTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        articleTitleLabel.adjustsFontSizeToFitWidth = true
        articleTitleLabel.numberOfLines = 1
        articleTitleLabel.minimumScaleFactor = 0.8
        
        authorLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        authorLabel.adjustsFontSizeToFitWidth = true
        authorLabel.numberOfLines = 1
        authorLabel.minimumScaleFactor = 0.7
        
        publishedDateLabel.font = authorLabel.font
        publishedDateLabel.adjustsFontSizeToFitWidth = true
        publishedDateLabel.numberOfLines = 1
        publishedDateLabel.minimumScaleFactor = 0.7
        
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.minimumScaleFactor = 0.7
        
        // Look of Feed Table View
        feedTableView.rowHeight = 88
    }
    
    private func createConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        previewView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.33)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            // Position under navbar
            // 44 is the standard height of the navigation bar
            make.top.equalTo(navigationBar.snp.bottom).offset(-44)
        }
        
        feedTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(previewView.snp.bottom).offset(0.4)
            make.bottom.equalToSuperview()
        }
        
        previewImageView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(previewView.snp.top).offset(30)
            make.bottom.lessThanOrEqualTo(previewView.snp.bottom).offset(-30)
            make.leading.equalTo(previewView.snp.leading).offset(10)
            make.width.equalTo(previewImageView.snp.height)
            make.centerY.equalToSuperview()
        }
        
        articleTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalTo(previewImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(articleTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(articleTitleLabel.snp.leading)
            make.width.lessThanOrEqualTo(publishedDateLabel)
        }
        
        publishedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.top)
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(authorLabel.snp.trailing).offset(5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom)
            make.leading.equalTo(articleTitleLabel.snp.leading)
            make.trailing.equalTo(previewView.snp.trailing)
            make.bottom.equalTo(previewView.snp.bottom).offset(-10)
        }
    }
}
