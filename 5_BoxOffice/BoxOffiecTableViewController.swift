//
//  ViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 5..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit

class BoxOfficeTableViewController: BaseViewController {
    
    private let orderType = OrderType.type
    
    private var movies: [Movie] = []
    private var movieId: String?

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    } ()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tappedSetting(_ sender: UIBarButtonItem) {
        showOrderSettingActionSheet(style: UIAlertControllerStyle.actionSheet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intializeRefreshControl()
        intializeViews()
        intializeNotificationObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchMoviesSettingViewController(orderType: orderType.requestOrderType)
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies(orderType: orderType.requestOrderType)
    }
    
    @objc func didReceiveMoviesNotification(_ noti: Notification) {
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie] else {
            return
        }
        
        self.movies = movies
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
            self.hideIndicator()
        }
    }
    
    private func fetchMoviesSettingViewController(orderType: String) {
        self.orderType.requestOrderType = orderType
        
        let navigationTitle: String
        
        switch orderType {
        case "0": navigationTitle = "예매율 순"
        case "1": navigationTitle = "큐레이션"
        case "2": navigationTitle = "개봉일"
        default:  navigationTitle = "예매율 순"
        }
        
        navigationController?.navigationBar.topItem?.title = navigationTitle
        
        showIndicator()
        
        fetchMovies(orderType: self.orderType.requestOrderType)
    }

    private func showOrderSettingActionSheet(style: UIAlertControllerStyle) {
        let orderAlertController: UIAlertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let actionOrderingByRate: UIAlertAction = UIAlertAction(title: "예매율", style: UIAlertActionStyle.default) { (action) in
            self.fetchMoviesSettingViewController(orderType: self.orderType.rate)
        }
        
        let actionOrderingByCuration: UIAlertAction = UIAlertAction(title: "큐레이션", style: UIAlertActionStyle.default) { (action) in
            self.fetchMoviesSettingViewController(orderType: self.orderType.curation)
        }
        
        let actionOrderingByDate: UIAlertAction = UIAlertAction(title: "개봉일", style: UIAlertActionStyle.default) { (action) in
            self.fetchMoviesSettingViewController(orderType: self.orderType.date)
        }
        
        let actionCancel: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        orderAlertController.addAction(actionOrderingByRate)
        orderAlertController.addAction(actionOrderingByCuration)
        orderAlertController.addAction(actionOrderingByDate)
        orderAlertController.addAction(actionCancel)
        
        present(orderAlertController, animated: true)
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
        let lightBlue = "#84A3F6"
        
        navigationController?.navigationBar.topItem?.title = "예매율 순"
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = lightBlue.hexStringToUIColor()
    }
    
    private func intializeStatusBar() {
        let lightBlue = "#84A3F6"
        
        UIApplication.shared.statusBarView?.backgroundColor = lightBlue.hexStringToUIColor()
    }
    
    private func intializeNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
    }
}

extension BoxOfficeTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: BoxOfficeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "table_cell", for: indexPath) as? BoxOfficeTableViewCell else {
            return UITableViewCell()
        }
     
        let movie: Movie = movies[indexPath.row]
        
        cell.movieTitle.text = movie.title
        cell.movieUserRating.text = String(movie.userRating)
        cell.movieReservationGrade.text = String(movie.reservationGrade)
        cell.movieReservationRate.text = String(movie.reservationRate)
        cell.movieReleaseDate.text = movie.date
        
        let gradeImageType: String
        
        switch movie.grade {
        case 0: gradeImageType = "ic_12"
        case 12: gradeImageType = "ic_15"
        case 15: gradeImageType = "ic_19"
        case 19: gradeImageType = "ic_allages"
        default: gradeImageType = "ic_allages"
        }
        
        cell.movieGrade.image = UIImage(named: gradeImageType)
        cell.movieThumb.image = UIImage(named: "img_placeholder")
        
        DispatchQueue.global().async {
            guard let thumbImageUrl: URL = URL(string: movie.thumb) else {
                    return
            }
            
            guard let thumbImageData: Data = try? Data(contentsOf: thumbImageUrl) else {
                    return
            }
            
            DispatchQueue.main.async {
                if let index: IndexPath = self.tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        print("\(index)  \(index.row) \(indexPath.row)")
                        cell.movieThumb.image = UIImage(data: thumbImageData)
                    }
                } else {
                    print("noneee")
                }
            }
        }
        
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

