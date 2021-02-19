//
//  NewsListViewController.swift
//  ProEdu
//
//  Created by Raz  on 24.11.20.
//

import UIKit
import AVKit

class NewsListViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var newsTableView: UITableView!
    
    private var categories: [NewsCategory] = []
    private var allNews: [News] = []
    private var categoryNews: [News] = []
    
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        getCategories()
        getNews()
        
        dispatchGroup.notify(queue: .main) {
            self.categoryCollectionView.reloadData()
            self.newsTableView.reloadData()
            
            LoadingView.shared.hideLoading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.orientation = .portrait
        
        UIView.performWithoutAnimation {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        LoadingView.shared.frame = view.bounds
    }
    
    private func setupCollectionView() {
        categoryCollectionView.register(UINib(nibName: NewsCategoryCell.name, bundle: nil), forCellWithReuseIdentifier: NewsCategoryCell.identifier)
        categoryCollectionView.contentInset.left = 20
        categoryCollectionView.contentInset.right = 20
        
        newsTableView.register(UINib(nibName: NewsCell.name, bundle: nil), forCellReuseIdentifier: NewsCell.identifier)
        newsTableView.contentInset.bottom = 24
    }
}

extension NewsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCategoryCell.identifier, for: indexPath) as! NewsCategoryCell
        cell.nameLabel.text = indexPath.row == 0 ? Constants.Strings.all.uppercased() : categories[indexPath.row - 1].label?.uppercased()
        if indexPath.row == 0 && (collectionView.indexPathsForSelectedItems == nil || (collectionView.indexPathsForSelectedItems != nil && collectionView.indexPathsForSelectedItems!.isEmpty)){
            cell.isSelected = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var category: String? = nil
        if indexPath != IndexPath(row: 0, section: 0) {
            let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0))
            cell?.isSelected = false
            
            category = categories[indexPath.row - 1].value
        }
        
        sort(with: category)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = Constants.Fonts.bold14
        let height = collectionView.bounds.height
        var width: CGFloat = 0
        if indexPath.row == 0 {
            width = Constants.Strings.all.uppercased().width(withConstrainedHeight: collectionView.bounds.height, font: font)
        } else {
            if let category = categories[indexPath.row - 1].label?.uppercased() {
                width = category.width(withConstrainedHeight: collectionView.bounds.height, font: font)
            }
        }

        return CGSize(width: width + 32, height: height)
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell
        cell.delegate = self
        cell.set(news: categoryNews[indexPath.row])
        
        return cell
    }
    
    func sort(with category: String?) {
        if let category = category {
            categoryNews.removeAll()
            allNews.forEach { (news) in
                if news.category == category {
                    categoryNews.append(news)
                }
            }
        } else {
            categoryNews = allNews
        }
        
        newsTableView.reloadData()
    }
}

extension NewsListViewController {
    func getCategories() {
        LoadingView.shared.showLoading(in: self.view, bottomPadding: 0)
        dispatchGroup.enter()
        
        NetworkManager.shared.getNewsCategories { [weak self] (categoriesResult) in
            switch categoriesResult {
            case .success(let categories):
                self?.categories = categories
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self?.dispatchGroup.leave()
        }
    }
    
    func getNews() {
        dispatchGroup.enter()
        NetworkManager.shared.getNews { [weak self] (newsResult) in
            switch newsResult {
            case .success(let news):
                self?.allNews = news.news ?? []
                self?.categoryNews = news.news ?? []
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self?.dispatchGroup.leave()
        }
    }
}

extension NewsListViewController: NewsCellDelegate {
    
    func play(with url: URL) {
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        
        self.present(controller, animated: true) {
            player.play()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.orientation = .all
        }
    }

}
