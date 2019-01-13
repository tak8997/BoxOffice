//
//  StarRatingView.swift
//  5_BoxOffice
//
//  Created by byungtak on 11/01/2019.
//  Copyright © 2019 byungtak. All rights reserved.
//

import UIKit

@objc protocol StarRatingViewProtocol {
    @objc optional func touchesUpStarRatingView(beginUpdating rating: Double)
    @objc optional func touchesUpStarRatingView(updating rating: Double)
    @objc optional func touchesUpStarRatingView(endUpdating rating: Double)
}

@IBDesignable class StarRatingView: UIStackView {

    // Mark: - Properties
    @IBInspectable var starSize: CGSize = CGSize(width: 18.0, height: 18.0) {
        didSet {
            setupStar()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupStar()
        }
    }
    
    private var starRatingImageViews = [UIImageView]()
    
    var rating = 0.0 {
        didSet {
            updateStarSelectionStates()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStar()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupStar()
    }
    
    // Mark: - Private Methods
    private func setupStar() {
        let bundle = Bundle(for: type(of: self))
        
        for button in starRatingImageViews {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        starRatingImageViews.removeAll()
        
        for _ in 0..<starCount {
            let starImageView = UIImageView()
            starImageView.image = UIImage(named: "ic_star_large", in: bundle, compatibleWith: self.traitCollection)
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.heightAnchor.constraint(equalToConstant: starSize.width).isActive = true
            starImageView.widthAnchor.constraint(equalToConstant: starSize.height).isActive = true

            addArrangedSubview(starImageView)
            
            starRatingImageViews.append(starImageView)
        }
        
        updateStarSelectionStates()
    }
    
    private func updateStarSelectionStates() {
        var rating = self.rating
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "ic_star_large_full", in: bundle, compatibleWith: self.traitCollection)
        let halfFilledStar = UIImage(named: "ic_star_large_half", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "ic_star_large", in: bundle, compatibleWith: self.traitCollection)
        
        starRatingImageViews.forEach { (imageView) in
            switch rating {
            case 2...: imageView.image = filledStar
            case 1..<2: imageView.image = halfFilledStar
            default: imageView.image = emptyStar
            }
            
            rating -= 2
            if rating < 0 {
                return
            }
        }
    }

}

// Mark:- Touch Events
extension StarRatingView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
