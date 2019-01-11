//
//  StarRatingView.swift
//  5_BoxOffice
//
//  Created by byungtak on 11/01/2019.
//  Copyright © 2019 byungtak. All rights reserved.
//

import UIKit

@IBDesignable class StarRatingView: UIStackView {

    // Mark: - Properties
    @IBInspectable var starSize: CGSize = CGSize(width: 18.0, height: 18.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    private var starRatingButtons = [UIButton]()
    
    var rating = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupButtons()
    }
    
    // Mark: - Private Methods
    private func setupButtons() {
        for button in starRatingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        starRatingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "ic_star_large_full", in: bundle, compatibleWith: self.traitCollection)
        let halfFilledStar = UIImage(named: "ic_star_large_half", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "ic_star_large", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            let starButton = UIButton()
            starButton.translatesAutoresizingMaskIntoConstraints = false
            starButton.heightAnchor.constraint(equalToConstant: starSize.width).isActive = true
            starButton.widthAnchor.constraint(equalToConstant: starSize.height).isActive = true
            starButton.setImage(filledStar, for: .selected)
            starButton.setImage(halfFilledStar, for: .highlighted)
            starButton.setImage(emptyStar, for: .normal)
            starButton.addTarget(self, action: #selector(tappedStarRatingButton(button:)), for: .touchUpInside)
            
            addArrangedSubview(starButton)
            
            starRatingButtons.append(starButton)
        }
    }
    
    // Mark: - Button Action
    @objc private func tappedStarRatingButton(button: UIButton) {
        guard let index = starRatingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the starRatingButtons array: \(starRatingButtons)")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
        
    }
    
}
