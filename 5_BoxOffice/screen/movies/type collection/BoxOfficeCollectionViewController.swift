//
//  BoxOfficeCollectionViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 12..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit

class BoxOfficeCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIdentifier = "collection_cell"
    
    private var orderType = OrderType.rate
    private var movies: [Movie] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return UIRefreshControl()
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intializeViews()
        intializeRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchMoviesSettingViewController(orderType: orderType)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let boxOfficeDetailViewController = segue.destination as? BoxOfficeDetailViewController,
            let cell: UICollectionViewCell = sender as? UICollectionViewCell else {
                
            return
        }
        
        let indexPath = collectionView?.indexPath(for: cell)
        
        if let selectedIndex = indexPath?.row {
            boxOfficeDetailViewController.movieId = movies[selectedIndex].id
            boxOfficeDetailViewController.navigationItem.title = movies[selectedIndex].title
        }
    }
    
    private func intializeRefreshControl() {
        self.collectionView.addSubview(refreshControl)
    }
    
    private func intializeViews() {
        initializeNavigationBar()
        initializeFlowLayout()
    }
    
    private func initializeFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()

        let halfWidth = UIScreen.main.bounds.width / 2.0
        let halfHeight = UIScreen.main.bounds.height / 2.0
        
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.estimatedItemSize = CGSize(width: halfWidth - 20, height: halfHeight - 60)
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    private func initializeNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.lightBlue
    }
    
    // Mark: - load data
    private func fetchMoviesSettingViewController(orderType: OrderType) {
        self.orderType = orderType
        self.fetchMovies()
        
        self.navigationController?.navigationBar.topItem?.title = orderType.navigationTitle
    }
    
    private func fetchMovies() {
        BoxOfficeService.shared.fetchMovies(orderType: self.orderType.rawValue) { [weak self] (movies) in
            guard let self = self else {
                return
            }
            
            self.movies = movies
            
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.fetchMovies()
    }

}

extension BoxOfficeCollectionViewController {
    @IBAction func tappedSettings(_ sender: UIBarButtonItem) {
        showOrderSettingActionSheet { (orderType) in
            self.fetchMoviesSettingViewController(orderType: orderType)
        }
    }
}

extension BoxOfficeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: BoxOfficeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? BoxOfficeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie: Movie = movies[indexPath.item]
        
        cell.configure(movie, item: indexPath.item, index: self.collectionView.indexPath(for: cell) ?? indexPath)
        
        return cell
    }
}

















