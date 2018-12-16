//
//  BoxOfficeDetailViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 14..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit
import Cosmos

class BoxOfficeDetailViewController: BaseViewController, ModalViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movieId: String?
    
    private let detailSection = 0
    private let synopsisSection = 1
    private let infoSection = 2
    private let commentSection = 3
    
    private var movieDetail: MovieDetail?
    private var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intializeViews()
        
        fetchMovie()
        fetchComment()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideIndicator()
    }
    
    func sendStatus(status: Int) {
        if status == Constants.success {
            fetchComment()
            
            print("success register comment")
        } else if status == Constants.failure {
            print("cannot register comment")
        }
    }
    
    private func intializeViews() {
        navigationController?.navigationBar.topItem?.title = "영화목록"
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        indicator.isHidden = true
    }
    
    private func fetchMovie() {
        if let movieId = movieId {
            showIndicator()

            BoxOfficeService.fetchMovieDetail(movieId: movieId) { response in
                self.movieDetail = response.movie
                
                self.tableView.reloadSections(IndexSet(self.detailSection...self.infoSection), with: .automatic)
            }
        }
    }

    private func fetchComment() {
        if let movieId = movieId {
            showIndicator()

            BoxOfficeService.fetchMovieComment(movieId: movieId) { response in
                let comments = response.comments

                self.comments.removeAll()
                self.comments.append(contentsOf: comments)
                
                self.tableView.reloadSections(IndexSet(self.commentSection...self.commentSection), with: .automatic)
                
                self.hideIndicator()
            }
        }
    }
    
    private func getStartCount(rating: Double) -> Double {
        let starCnt: Double
        
        switch rating {
        case 0.0...1.0 : starCnt = 0.5
        case 1.0...2.0 : starCnt = 1.0
        case 2.0...3.0 : starCnt = 1.5
        case 3.0...4.0 : starCnt = 2.0
        case 4.0...5.0 : starCnt = 2.5
        case 5.0...6.0 : starCnt = 3.0
        case 6.0...7.0 : starCnt = 3.5
        case 7.0...8.0 : starCnt = 4.0
        case 8.0...9.0 : starCnt = 4.5
        case 9.0...10.0 : starCnt = 5.0
        default: starCnt = 0.0
        }
        
        return starCnt
    }
    
    @objc func tappedPostContent(gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let boxOfficeCommentModalViewController: BoxOfficeCommentModalViewController = storyboard.instantiateViewController(withIdentifier: "BoxOfficePostCommentModal") as? BoxOfficeCommentModalViewController else {
            return
        }
        boxOfficeCommentModalViewController.modalPresentationStyle = .overCurrentContext
        boxOfficeCommentModalViewController.movieDetail = movieDetail
        boxOfficeCommentModalViewController.delegate = self
        
        let navBoxOfficeCommentViewController = UINavigationController(rootViewController: boxOfficeCommentModalViewController)
        
        self.present(navBoxOfficeCommentViewController, animated: true, completion: nil)
    }
    
    @objc func tappedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedMovieImage(tapGestureRecognizer: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let boxOfficeMovieImageModalViewController: BoxOfficeMovieImageModalViewController = storyboard.instantiateViewController(withIdentifier: "BoxOfficeMovieImageModal") as? BoxOfficeMovieImageModalViewController else {
            return
        }
        boxOfficeMovieImageModalViewController.modalPresentationStyle = .overCurrentContext
        boxOfficeMovieImageModalViewController.movieImage = movieDetail?.image
        
        let navBoxOfficeMovieImageViewController = UINavigationController(rootViewController: boxOfficeMovieImageModalViewController)
        
        self.present(navBoxOfficeMovieImageViewController, animated: true, completion: nil)
    }
    
}

extension BoxOfficeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case detailSection,
             synopsisSection,
             infoSection:
            
            return 1
        case commentSection:
            return comments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case detailSection:
            guard let cell: BoxOfficeDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "detail_cell", for: indexPath) as? BoxOfficeDetailTableViewCell else {
                return BoxOfficeTableViewCell()
            }
            
            let movieDetail = self.movieDetail
            
            cell.movieTitle.text = movieDetail?.title
            cell.movieGenre.text = movieDetail?.genre
            if  let duration = movieDetail?.duration,
                let grade = movieDetail?.reservationGrade,
                let rate = movieDetail?.reservationRate,
                let rating = movieDetail?.userRating,
                let audience = movieDetail?.audience,
                let date = movieDetail?.date {
                
                cell.movieDuration.text = "\(duration)분"
                cell.movieReservationGrade.text = "\(grade)위"
                cell.movieReservationRate.text = "\(rate)%"
                cell.movieUserRating.text = String(rating)
                cell.movieAudienceCount.text = audience.convertNumberToDecimalFormatter()
                cell.movieDate.text = "\(date)개봉"
                
                let startCnt: Double = getStartCount(rating: rating)
                
                cell.movieUserRatingStar.settings.updateOnTouch = false
                cell.movieUserRatingStar.rating = startCnt
            }
            
            let gradeImageType: String
            
            switch movieDetail?.grade {
            case 0: gradeImageType = "ic_12"
            case 12: gradeImageType = "ic_15"
            case 15: gradeImageType = "ic_19"
            case 19: gradeImageType = "ic_allages"
            default: gradeImageType = "ic_allages"
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedMovieImage(tapGestureRecognizer:)))
            
            cell.movieGrade.image = UIImage(named: gradeImageType)
            cell.movieImage.image = UIImage(named: "img_placeholder")
            cell.movieImage.isUserInteractionEnabled = true
            cell.movieImage.addGestureRecognizer(tapGestureRecognizer)
            
            DispatchQueue.global().async {
                guard
                    let imageUrl = movieDetail?.image,
                    let url: URL = URL(string: imageUrl),
                    let data: Data = try? Data(contentsOf: url) else {
                        
                    return
                }
                
                DispatchQueue.main.async {
                    cell.movieImage.image = UIImage(data: data)
                }
            }
            
            return cell
        case synopsisSection:
            guard let cell: BoxOfficeContentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "content_cell", for: indexPath) as? BoxOfficeContentTableViewCell else {
                return BoxOfficeContentTableViewCell()
            }
            
            let movieDetail = self.movieDetail
            
            cell.movieSynopsis.text = movieDetail?.synopsis
            
            return cell
        case infoSection:
            guard let cell: BoxOfficeInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "info_cell", for: indexPath) as? BoxOfficeInfoTableViewCell else {
                return BoxOfficeInfoTableViewCell()
            }
            
            let movieDetail = self.movieDetail
            
            cell.movieDirector.text = movieDetail?.director
            cell.movieActor.text = movieDetail?.actor
            
            return cell
        case commentSection:
            guard let cell: BoxOfficeCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "comment_cell", for: indexPath) as? BoxOfficeCommentTableViewCell else {
                return BoxOfficeCommentTableViewCell()
            }
            
            let comment = self.comments[indexPath.row]
            
            let date = Date(timeIntervalSince1970: comment.timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let strDate = dateFormatter.string(from: date)
            
            let starCnt = getStartCount(rating: comment.rating)
            
            cell.userId.text = comment.writer
            cell.userCommentDate.text = strDate
            cell.userComment.text = comment.contents
            cell.userRatingStar.rating = starCnt
            cell.userRatingStar.settings.updateOnTouch = false
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 40
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
            headerView.backgroundColor = UIColor.white

            let title = UILabel()
            title.frame = CGRect(x: 12, y: 0, width: 100, height: 40)
            title.font = UIFont.systemFont(ofSize: 21.0)
            title.text = "한줄평"
        
            let postImage = UIImage(named: "btn_compose")
            let postImageView = UIImageView(image: postImage)
            postImageView.frame = CGRect(x: tableView.frame.size.width - 40, y: 0, width: 30, height: 35)

            let headerTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPostContent))
            headerView.addGestureRecognizer(headerTapGesture)
            
            headerView.addSubview(title)
            headerView.addSubview(postImageView)

            return headerView
        }

        return nil
    }

}
