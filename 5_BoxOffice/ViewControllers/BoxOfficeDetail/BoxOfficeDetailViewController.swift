//
//  BoxOfficeDetailViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 14..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit
import Cosmos

class BoxOfficeDetailViewController: UIViewController {

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
    
    private func intializeViews() {
        navigationController?.navigationBar.topItem?.title = "영화목록"
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
    
    // Mark: - load data
    private func fetchMovie() {
        guard let movieId = movieId else { return }
        
        BoxOfficeService.shared.fetchMovieDetail(movieId: movieId, completion: { [weak self] (movie) in
            guard let self = self else { return }
            
            self.movieDetail = movie
            self.tableView.reloadSections(IndexSet(self.detailSection...self.infoSection), with: .automatic)
        }) { self.showAlertController(title: "요청 실패", message: "알 수 없는 네트워크 에러 입니다.") }
    }

    private func fetchComment() {
        guard let movieId = movieId else { return }
        
        BoxOfficeService.shared.fetchMovieComment(movieId: movieId, completion: { [weak self] (comments) in
            guard let self = self else { return }
            
            let comments = comments
            
            self.comments.removeAll()
            self.comments.append(contentsOf: comments)
            self.tableView.reloadSections(IndexSet(self.commentSection...self.commentSection), with: .automatic)
        }) { self.showAlertController(title: "요청 실패", message: "알 수 없는 네트워크 에러 입니다.") }
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

extension BoxOfficeDetailViewController: ModalViewControllerDelegate {
    func sendStatus(status: NetworkStatus) {
        if status == NetworkStatus.success {
            fetchComment()
            print("success register comment")
        } else if status == NetworkStatus.failure {
            print("cannot register comment")
        }
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
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedMovieImage(tapGestureRecognizer:)))
            
            let movieDetail = self.movieDetail
            
            cell.configure(movieDetail: movieDetail, tapGestureRecognizer: tapGestureRecognizer)
            
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
            
            cell.configure(comment: comment)
            
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
