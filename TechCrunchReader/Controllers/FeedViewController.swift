//
//  FeedViewController.swift
//  TechCrunchReader
//
//  Created by Vladimír Zdražil on 17/02/2017.
//  Copyright © 2017 Vladimír Zdražil. All rights reserved.
//

import UIKit
import CoreData
import SafariServices
import SDWebImage

class FeedViewController: UIViewController {
    
    fileprivate let moc: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.dataController.managedObjectContext
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    // URL of the article in the preview View
    fileprivate var previewURL: String?
    // Track if article was selected on start
    fileprivate var articleOnStartupSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows placing feed under the navigation bar
        self.edgesForExtendedLayout = []
        
        contentView.feedTableView.delegate = self
        contentView.feedTableView.dataSource = self
        
        // Initialize and start parsing articles
        let jsonParser = JsonParser()
        // JSON Url to parse
        let stringURL = "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=463418465f874cb4a5009c4967ae9cf2"
        jsonParser.parseJSONtoCoreData(stringURL: stringURL)
        
        // Intitialize FetchedResultsController
        initializeFetchedResultsController()
        
        // Add tap gesture recognizer to previewView
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapPreview(sender:)))
        contentView.previewView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Place share button on the right of the navigation bar
        let shareBar = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(self.userDidTapShare(sender:)))
        contentView.navigationBar.topItem?.rightBarButtonItem = shareBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Initialize View
extension FeedViewController {
    
    // Computed property that returns FeedViewController's view as custom view
    fileprivate var contentView: MainView {
        return view as! MainView
    }
    
    // Initialize view
    override func loadView() {
        view = MainView()
        contentView.navigationBar.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
    }
    
    // Set light status for use on dark backgrounds
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    
    fileprivate func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        // Get article entity at provided indexPath and use it to set values
        guard let selectedArticle = fetchedResultsController.object(at: indexPath) as? ArticleMO else { fatalError("Unexpected Object in FetchedResultsController") }
        
        var stringURL = selectedArticle.urlImage
        if let stringURLUnwrapped = stringURL {
            // Get url of image of size of imageView to save bandwith
            // FIXME: - maybe doesn't work if image height is larger that width -> image will be too small?
            // FIXME: - doesn't handle 3x resolution - support for iPhone Plus
            stringURL =  JSONRequestHelper.getImageURLStringWithDimension(width: Double(2 * (cell.imageView?.frame.width)!), height: Double(2 * (cell.imageView?.frame.height)!), crop: true, url: stringURLUnwrapped)
            
            // Show grey indicator when downloading image
            cell.imageView?.sd_setShowActivityIndicatorView(true)
            cell.imageView?.sd_setIndicatorStyle( .gray)
            // Set placeholder and load image with SDWebImage
            // Placeholder must be set, otherwise the image doesn't show up on first view
            cell.imageView?.sd_setImage(with: URL(string: stringURL!), placeholderImage: UIImage(named: "Placeholder.png"))
        }
        
        // Set value
        cell.textLabel?.text = selectedArticle.title
        
        // Format and add a localized relative time as a subtitle
        let publishedAt = selectedArticle.publishedAt as? Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        // If it fails, don't set anything
        if let publishedDateUnwrapped = publishedAt {
            let relativeTime = dateFormatter.string(from: publishedDateUnwrapped)
            cell.detailTextLabel?.text = relativeTime
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // No indexPath as parameter so the cell can be nil and can be created
        // Allows setting the cell style here and not in a custom class ArticleTableViewCell
        var cell: ArticleTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? ArticleTableViewCell
        if (cell == nil) {
            cell = ArticleTableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        configureCell(cell: cell!, indexPath: indexPath)
        
        // Select first article on startup
        if !articleOnStartupSelected {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView(tableView, didSelectRowAt: indexPath)
            articleOnStartupSelected = true
        }
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
}

// MARK: - TableViewDelegate
extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get selected Article entity to use its values
        guard let selectedArticle = fetchedResultsController.object(at: indexPath) as? ArticleMO else { fatalError("Unexpected Object in FetchedResultsController") }
        
        if var stringURL = selectedArticle.urlImage {
            // FIXME: - maybe doesn't work if image height is larger that width -> image will be too small?
            // FIXME: - doesn't handle 3x resolution - support for iPhone Plus
            stringURL =  JSONRequestHelper.getImageURLStringWithDimension(width: Double(2 * contentView.previewImageView.frame.width), height: Double(2 * contentView.previewImageView.frame.height), crop: true, url: stringURL)
            if let imageURL = URL(string: stringURL) {
                contentView.previewImageView.sd_setShowActivityIndicatorView(true)
                contentView.previewImageView.sd_setIndicatorStyle(.gray)
                contentView.previewImageView.sd_setImage(with: imageURL)
            }
        }
        
        // Set values
        contentView.articleTitleLabel.text = selectedArticle.title
        previewURL = selectedArticle.url
        contentView.authorLabel.text = selectedArticle.author
        contentView.descriptionLabel.text = selectedArticle.articleDescription
        
        // Format and set date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd. MMMM YYYY"
        contentView.publishedDateLabel.text =  dateFormatter.string(from: (selectedArticle.publishedAt as? Date)!)
    }
}

// MARK: - FetchedResultsController
extension FeedViewController {
    
    fileprivate func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        // Sort by date
        let dateSort = NSSortDescriptor(key: "publishedAt", ascending: false)
        request.sortDescriptors = [dateSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
}

// MARK: - FetchedResultsControllerDelegate {
extension FeedViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contentView.feedTableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            contentView.feedTableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            contentView.feedTableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            contentView.feedTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            contentView.feedTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(cell: contentView.feedTableView.cellForRow(at: indexPath!)!, indexPath: indexPath!)
        case .move:
            contentView.feedTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contentView.feedTableView.endUpdates()
    }
}

// MARK: - Preview
extension FeedViewController {
    
    // Manage tapping on article preview
    @objc fileprivate func tapPreview(sender: UITapGestureRecognizer) {
        showArticle()
    }
    
    // Open article in a SFSafariViewController
    fileprivate func showArticle() {
        guard let stringURL = previewURL else {
            return
        }
        
        guard let url = URL(string: stringURL) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

// MARK: - Share Button
extension FeedViewController {
    
    @objc fileprivate func userDidTapShare(sender: UIBarButtonItem) {
        var sharingItems = [AnyObject]()
        
        if let textToShare = contentView.articleTitleLabel.text {
            sharingItems.append(textToShare as AnyObject)
        }
        
        if let stringURL = previewURL {
            if let url = NSURL(string: stringURL) {
                sharingItems.append(url)
            }
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        self.present(activityViewController, animated: true, completion: nil)
    }
}


