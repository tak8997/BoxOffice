//
//  BoxOfficeCommentModalViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 24..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit
import Cosmos

protocol ModalViewControllerDelegate {
    func sendStatus(status: NetworkStatus)
}

class BoxOfficeCommentModalViewController: UIViewController {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGradeImage: UIImageView!
    @IBOutlet weak var userNicknameTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var userRatingStarView: CosmosView!
    @IBOutlet weak var userRatingLabel: UILabel!
    
    var movieDetail: MovieDetail?
    var delegate: ModalViewControllerDelegate?
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initializeViews()

        fetchSavedNickname()
    }
    
    private func saveNickName(nickname: String) {
        let preferences = UserDefaults.standard
        
        let key = "nickname"
        let value = nickname
        
        preferences.set(value, forKey: key)
        
        let didSave = preferences.synchronize()
        
        if didSave {
            print("success")
        } else {
            print("failure")
        }
    }
    
    private func fetchSavedNickname() {
        let preferences = UserDefaults.standard
        
        let key = "nickname"
        
        if preferences.object(forKey: key) == nil {
            print("doesn't exiest")
        } else {
            let value = preferences.string(forKey: key)
            
            userNicknameTextField.text = value
        }
    }
    
    private func registerMovieComment(id: String?, nickname: String, comment: String, rating: Double) {
        BoxOfficeService.shared.registerMovieComment(id: id, nickname: nickname, comment: comment, rating: rating) { [weak self] response in
            guard let self = self else {
                return
            }
        
            self.delegate?.sendStatus(status: response)
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func initializeViews() {
        intializeNavigationBar()
        intializeRatingStarView()
        
        movieTitleLabel.text = movieDetail?.title
        
        movieGradeImage.image = UIImage(named: MovieGrade(rawValue: movieDetail?.grade ?? 12)?.movieGrade ?? "")
        
        commentTextView?.layer.borderWidth = 1
        commentTextView?.layer.borderColor = UIColor.red.cgColor
    }
    
    private func intializeRatingStarView() {
        userRatingStarView.settings.fillMode = .precise
        userRatingStarView.didTouchCosmos = { rating in
            var starCnt = 0
            
            switch rating {
            case 0.0:
                starCnt = 0
            case 0.1...0.5:
                starCnt = 1
            case 0.5...1.0:
                starCnt = 2
            case 1.0...1.5:
                starCnt = 3
            case 1.5...2.0:
                starCnt = 4
            case 2.0...2.5:
                starCnt = 5
            case 2.5...3.0:
                starCnt = 6
            case 3.0...3.5:
                starCnt = 7
            case 3.5...4.0:
                starCnt = 8
            case 4.0...4.5:
                starCnt = 9
            case 4.5...5.0:
                starCnt = 10
            default:
                starCnt = 0
            }
            self.userRatingLabel.text = String(starCnt)
        }
    }
    
    private func intializeNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "한줄평 작성"
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tappedModalDismiss(sender:)) )
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tappedCommentPostSuccess(sender:)) )
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.lightBlue
    }

    @objc func tappedModalDismiss(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedCommentPostSuccess(sender: UIBarButtonItem) {
        guard
            let nickname = userNicknameTextField.text,
            let comment = commentTextView.text else {
                
            return
        }
        
        if !nickname.isEmpty && !comment.isEmpty && userRatingStarView.rating != 0.0 {
            registerMovieComment(id: movieDetail?.id, nickname: nickname, comment: comment, rating: userRatingStarView.rating)
        } else {
            showAlertController(title: "등록 실패", message: "항목을 모두 채워주세요.")
        }
        
        saveNickName(nickname: nickname)
    }
    
}
