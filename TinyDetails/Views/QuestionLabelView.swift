//
//  QuestionLabelView.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 26/06/2025.
//
import UIKit

final class QuestionLabelView: UIView {
    var questionText: String {
        didSet {
            questionLabel.text = questionText
        }
    }
    
    var itemText: String {
        didSet {
            itemLabel.text = itemText + "?"
        }
    }
    
    var smallScreen: Bool = false
    
    private var questionLabel: UILabel!
    private var itemLabel: UILabel!
    
    init(questionText: String, itemText: String, smallScreen: Bool) {
        self.questionText = questionText
        self.itemText = itemText
        self.smallScreen = smallScreen
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        print("Small screen: \(smallScreen)")
        
        questionLabel = UILabel()
        questionLabel.text = questionText
        questionLabel.textColor = .white
        questionLabel.font = UIFont.systemFont(ofSize: smallScreen ? QuestionViewConstants.questionFontSizeSmall : QuestionViewConstants.questionFontSizeBig, weight: .medium)
        questionLabel.textAlignment = .left
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.isUserInteractionEnabled = false
        
        itemLabel = UILabel()
        itemLabel.text = itemText
        itemLabel.textColor = .white
        itemLabel.font = UIFont.systemFont(ofSize: smallScreen ? QuestionViewConstants.itemFontSizeSmall : QuestionViewConstants.itemFontSizeBig, weight: .bold)
        itemLabel.textAlignment = .left
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.isUserInteractionEnabled = false
        itemLabel.adjustsFontSizeToFitWidth = true
        itemLabel.minimumScaleFactor = 0.5
        itemLabel.lineBreakMode = .byTruncatingTail
        itemLabel.numberOfLines = 1
        
        addSubview(questionLabel)
        addSubview(itemLabel)
        
        NSLayoutConstraint.activate([
            itemLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: topAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: itemLabel.topAnchor, constant: QuestionViewConstants.bottomMargin),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func updateItemText(itemText: String, questionText: String? = nil) {
        self.itemText = itemText
        if let questionText = questionText {
            self.questionText = questionText
        }
        if self.itemText.count > QuestionViewConstants.charLimit {
            adaptToLongText(gettingBack: false)
        } else {
            adaptToLongText(gettingBack: true)
        }
    }
    
    private func adaptToLongText(gettingBack: Bool) {
        if gettingBack {
            itemLabel.font = UIFont.systemFont(ofSize: smallScreen ? QuestionViewConstants.itemFontSizeSmall : QuestionViewConstants.itemFontSizeBig, weight: .bold)
            itemLabel.adjustsFontSizeToFitWidth = true
            itemLabel.lineBreakMode = .byTruncatingTail
            itemLabel.numberOfLines = 1
        } else {
            itemLabel.font = UIFont.systemFont(ofSize: QuestionViewConstants.longTextFontSizeSmall, weight: .bold)
            itemLabel.adjustsFontSizeToFitWidth = false
            itemLabel.lineBreakMode = .byWordWrapping
            itemLabel.numberOfLines = 0
        }
    }
}

