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
    
    private var questionLabel: UILabel!
    private var itemLabel: UILabel!
    
    init(questionText: String, itemText: String) {
        
        self.questionText = questionText
        self.itemText = itemText
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        questionLabel = UILabel()
        questionLabel.text = questionText
        questionLabel.textColor = .white
        questionLabel.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        questionLabel.textAlignment = .left
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.isUserInteractionEnabled = false
        
        itemLabel = UILabel()
        itemLabel.text = itemText
        itemLabel.textColor = .white
        itemLabel.font = UIFont.systemFont(ofSize: 55, weight: .bold)
        itemLabel.textAlignment = .left
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.isUserInteractionEnabled = false
        
        addSubview(questionLabel)
        addSubview(itemLabel)
        
        NSLayoutConstraint.activate([
            itemLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: topAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: itemLabel.topAnchor, constant: 5),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func updateItemText(itemText: String, questionText: String? = nil) {
        self.itemText = itemText
        if let questionText = questionText {
            self.questionText = questionText
        }
    }
}

