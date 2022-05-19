//
//  RegisterNameView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import SnapKit

final class RegisterNameView: UIView {
    
    // MARK: Properties
    private let nameQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = "What's your name?"
        label.font = .roboto(size: 16.0)
        label.textColor = UIColor(red: 86.0/255.0, green: 69.0/255.0, blue: 8.0/255.0, alpha: 1.0)
        return label
    }()
    
    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0, alpha: 1.0)
        return label
    }()
    
    private let answerBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        backgroundView.layer.cornerRadius = 19.5
        return backgroundView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 14.0)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter your name",
            attributes: [.foregroundColor: UIColor(red: 134.0/255.0, green: 134.0/255.0, blue: 134.0/255.0, alpha: 1.0)])
        return textField
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func layout() {
        self.addSubview(nameQuestionLabel)
        nameQuestionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(30.0)
        }
        
        self.addSubview(asteriskLabel)
        asteriskLabel.snp.makeConstraints {
            $0.top.equalTo(nameQuestionLabel).offset(-3.0)
            $0.leading.equalTo(nameQuestionLabel.snp.trailing).offset(6.0)
        }
        
        self.addSubview(answerBackgroundView)
        answerBackgroundView.snp.makeConstraints {
            $0.top.equalTo(nameQuestionLabel.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
            $0.height.equalTo(39.0)
        }
        
        answerBackgroundView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        }
    }
}