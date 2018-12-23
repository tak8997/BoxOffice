//
//  ViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 5..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit

class BoxOfficeTableViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "table_cell"
    
    private var movies: [Movie] = []
    private var orderType = OrderType.rate

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intializeRefreshControl()
        intializeViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchMoviesSettingViewController(orderType: orderType)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideIndicator()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let boxOfficeDetailViewController = segue.destination as? BoxOfficeDetailViewController else {
            return
        }
        
        guard let _: BoxOfficeTableViewCell = sender as? BoxOfficeTableViewCell else {
            return
        }
        
        if let selectedIndex = tableView.indexPathForSelectedRow?.row {
            boxOfficeDetailViewController.movieId = movies[selectedIndex].id
            boxOfficeDetailViewController.navigationItem.title = movies[selectedIndex].title
        }
    }
    
    private func intializeRefreshControl() {
        tableView.addSubview(refreshControl)
    }

    private func intializeViews() {
        intializeStatusBar()
        intializeNavigationBar()
        
        indicator.isHidden = true
    }
    
    private func intializeNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "예매율 순"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.lightBlue
    }
    
    private func intializeStatusBar() {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.lightBlue
    }

    // Mark: - load data
    private func fetchMoviesSettingViewController(orderType: OrderType) {
        self.orderType = orderType
        self.showIndicator()
        self.fetchMovies()
        
        self.navigationController?.navigationBar.topItem?.title = orderType.navigationTitle
    }
    
    private func fetchMovies() {
        BoxOfficeService.fetchMovies(orderType: self.orderType.rawValue) { (movies) in
            self.movies = movies
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
            self.hideIndicator()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.fetchMovies()
    }
    
    @IBAction func tappedSetting(_ sender: UIBarButtonItem) {
        showOrderSettingActionSheet { orderType in
            self.fetchMoviesSettingViewController(orderType: orderType)
        }
    }
}

extension BoxOfficeTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: BoxOfficeTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BoxOfficeTableViewCell else {
            return UITableViewCell()
        }
     
        let movie: Movie = movies[indexPath.row]
        
        cell.configure(movie, tableView: self.tableView, indexPath: indexPath, cell: cell)
        
//        DispatchQueue.global().async {
//            guard let thumbImageUrl: URL = URL(string: movie.thumb) else {
//                    return
//            }
//
//            guard let thumbImageData: Data = try? Data(contentsOf: thumbImageUrl) else {
//                    return
//            }
//
//            DispatchQueue.main.async {
//                if let index: IndexPath = self.tableView.indexPath(for: cell) {
//                    if index.row == indexPath.row {
//                        cell.movieThumb.image = UIImage(data: thumbImageData)
//                    }
//                }
//            }
//        }
        
        return cell
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

