//
//  ViewController.swift
//  GallereyProject
//
//  Created by Артём Черныш on 17.08.23.
//

import UIKit
import SnapKit

class AuthorizationViewController: UIViewController {

    private let arrayOfButtons: [UIButton] = {
        var arrayOfButtons: [UIButton] = []
        for element in 0...9 {
            let button = UIButton(type: .system)
            button.tag = element
            let buttonImage = UIImage(systemName: "\(element).circle.fill")?.withRenderingMode(.alwaysTemplate)
            button.setImage(buttonImage, for: .normal)
            button.tintColor = .systemGray
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            arrayOfButtons.append(button)
            
        }
        return arrayOfButtons
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "○○○○"
        label.font = UIFont.systemFont(ofSize: 60)
        label.textColor = .white
        return label
    }()
    
    private var password: String = String()
    private var filledCircles = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(passwordLabel)
        setupPasswordLabel()
        setupButtons()
    }
    
    private func setupPasswordLabel() {
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupButtons() {
        let offsetForTop = (view.frame.height - (view.frame.width / 3) - (view.frame.width / 3 * 4)) / 6
        for element in arrayOfButtons {
            if element.tag == 0 {
                view.addSubview(element)
            } else if element.tag < 4 {
                makeButtonConstraints(button: element, top: passwordLabel.snp.bottom)
            } else {
                makeButtonConstraints(button: element, top: arrayOfButtons[element.tag-3].snp.bottom)
            }
            element.addTarget(self, action: #selector(clickOnButtonAction(_:)), for: .touchUpInside)
        }
        arrayOfButtons[0].snp.makeConstraints { make in
            make.top.equalTo(arrayOfButtons[8].snp.bottom).offset(offsetForTop)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(view.frame.width/3)
        }
    }
    
    private func makeButtonConstraints(button: UIButton, top: ConstraintItem) {
        view.addSubview(button)
        let offsetForTop = (view.frame.height - (view.frame.width / 3) - (view.frame.width / 3 * 4)) / 6
        switch button.tag%3 {
        case 1:
            button.snp.makeConstraints { make in
                make.top.equalTo(top).offset(offsetForTop)
                make.left.equalTo(view.safeAreaLayoutGuide)
                make.height.width.equalTo(view.frame.width/3)
            }
        case 2:
            button.snp.makeConstraints { make in
                make.top.equalTo(top).offset(offsetForTop)
                make.centerX.equalTo(view.safeAreaLayoutGuide)
                make.height.width.equalTo(view.frame.width/3)
            }
        case 0:
            button.snp.makeConstraints { make in
                make.top.equalTo(top).offset(offsetForTop)
                make.right.equalTo(view.safeAreaLayoutGuide)
                make.height.width.equalTo(view.frame.width/3)
            }
        default:
            break
        }
    }
    
    @objc private func clickOnButtonAction(_ button: UIButton) {
        if passwordLabel.text?.count ?? 0 < 4 || passwordLabel.text == "○○○○" {
            if passwordLabel.text == "○○○○" {
                passwordLabel.text = "\(button.tag)"
                password += "\(button.tag)"
                filledCircles += "●"
            } else {
                passwordLabel.text = filledCircles + "\(button.tag)"
                password += "\(button.tag)"
                filledCircles += "●"
            }
            if passwordLabel.text?.count ?? 0 == 4 {
                if password == "2281" {
                    shakingPasswordLabel()
                    passwordLabel.text = "○○○○"
                    password = ""
                    filledCircles = ""
                    let gallereyViewController: UIViewController = GallereyViewController()
                    navigationController?.pushViewController(gallereyViewController, animated: true)
                } else {
                    shakingPasswordLabel()
                    passwordLabel.text = "○○○○"
                    password = ""
                    filledCircles = ""
                }
            }
        }
    }
    
    private func shakingPasswordLabel() {
        UIView.animate(withDuration: 0.15, delay: 0.0) {
            self.passwordLabel.snp.remakeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide)
                make.right.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0.0) {
                self.passwordLabel.snp.remakeConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide)
                    make.left.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.075, delay: 0.0) {
                    self.passwordLabel.snp.remakeConstraints { make in
                        make.top.equalTo(self.view.safeAreaLayoutGuide)
                        make.centerX.equalToSuperview()
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

