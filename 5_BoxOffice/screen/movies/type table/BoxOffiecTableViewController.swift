//
//  ViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 5..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit

class BoxOfficeTableViewController: UIViewController {
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let boxOfficeDetailViewController = segue.destination as? BoxOfficeDetailViewController,
            let _: BoxOfficeTableViewCell = sender as? BoxOfficeTableViewCell else {
                
            return
        }
        
        if let selectedIndex = tableView.indexPathForSelectedRow?.row {
            boxOfficeDetailViewController.movieId = movies[selectedIndex].id
            boxOfficeDetailViewController.navigationItem.title = movies[selectedIndex].title
        }
    }
    
    private func intializeRefreshControl() {
        self.tableView.addSubview(refreshControl)
    }

    private func intializeViews() {
        intializeNavigationBar()
    }
    
    private func intializeNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "예매율 순"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.lightBlue
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
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.fetchMovies()
    }
    
    @IBAction func tappedSetting(_ sender: UIBarButtonItem) {
        self.showOrderSettingActionSheet(completion: { (orderType) in
            self.fetchMoviesSettingViewController(orderType: orderType)
        })
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
        cell.configure(movie, row: indexPath.row, index: self.tableView.indexPath(for: cell) ?? indexPath)
        
        return cell
    }
}

