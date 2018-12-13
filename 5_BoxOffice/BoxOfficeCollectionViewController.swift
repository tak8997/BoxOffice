//
//  BoxOfficeCollectionViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 12..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit

class BoxOfficeCollectionViewController: BaseViewController {

    private let orderType = OrderType.type
    
    private var movies: [Movie] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    } ()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func tappedSettings(_ sender: UIBarButtonItem) {
        showOrderSettingActionSheet(style: UIAlertControllerStyle.actionSheet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intializeViews()
        intializeRefreshControl()
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
        
        guard let cell: UICollectionViewCell = sender as? UICollectionViewCell else {
            return
        }
        
        let indexPath = collectionView?.indexPath(for: cell)
        
        if let selectedIndex = indexPath?.row {
            boxOfficeDetailViewController.movieId = movies[selectedIndex].id
            boxOfficeDetailViewController.navigationItem.title = movies[selectedIndex].title
        }
    }
    
    @objc func didReceiveMoviesNotification(_ noti: Notification) {
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie] else {
            return
        }
        
        self.movies = movies
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            
            self.hideIndicator()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies(orderType: orderType.requestOrderType)
    }
    
    private func fetchMoviesSettingViewController(orderType: String) {
        self.orderType.requestOrderType = orderType
        
        let navigationTitle: String
        
        switch orderType {
        case "0": navigationTitle = "예매율 순"
        case "1": navigationTitle = "큐레이션"
        case "2": navigationTitle = "개봉일"
        default: navigationTitle = "예매율 순"
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
        collectionView.addSubview(refreshControl)
    }
    
    private func intializeNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
    }
    
    private func intializeViews() {
        initializeStatusBar()
        initializeNavigationBar()
        initializeFlowLayout()
        
        indicator.isHidden = true
    }
    let halfWidth = UIScreen.main.bounds.width / 2.0
    let halfHeight = UIScreen.main.bounds.height / 2.0
    
    private func initializeFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()

        
        
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.estimatedItemSize = CGSize(width: halfWidth - 20, height: halfHeight - 60)
//        flowLayout.itemSize = CGSize(width: halfWidth - 20, height: halfHeight - 60)
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    private func initializeNavigationBar() {
        let lightBlue = "#84A3F6"
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = lightBlue.hexStringToUIColor()
    }
    
    private func initializeStatusBar() {
        let lightBlue = "#84A3F6"
        
        UIApplication.shared.statusBarView?.backgroundColor = lightBlue.hexStringToUIColor()
    }
    
}

extension BoxOfficeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: BoxOfficeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as? BoxOfficeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie: Movie = movies[indexPath.item]
        
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.frame.size.width = halfWidth - 20
        cell.contentView.backgroundColor = UIColor.red
        
        cell.movieTitle.text = movie.title
        cell.movieUserRating.text = "(\(movie.userRating))"
        cell.movieReservationGrade.text = "\(movie.reservationGrade)위"
        cell.movieReservationRate.text = "\(movie.reservationRate)%"
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
                //다운받는 동안 사용자가 스크롤 할수있음. 셀의 위치,배치가 잘못될수도 있음. 다른 위치에 가있을수도
                //그래서 셀이 지금 데이터를 세팅해 주고있는 현재 인덱스와 이미지 다운로드가 끝났을때 인덱스가 상의할 수 있기 때문에,
                //그걸 구분해주고 서로 일치할때만 이미지 세팅
                
                if let index: IndexPath = self.collectionView.indexPath(for: cell) {
                    print("here")
                    if index.item == indexPath.item {
                        cell.movieThumb.image = UIImage(data: thumbImageData)
                    }
                } 
            }
        }
        
        return cell
    }
}

















