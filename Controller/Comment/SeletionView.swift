//
//  SeletionView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/7.
//

import UIKit

enum SelectionButton: String {
    case addPicture = "addMedia"
    
    case selectNoodle = "noodle"
    case selectSoup = "water"
    case selectHappy = "thumb"
    
    case notWriteComment = "notwriteComment"
    
    case saveCommentToDraft = "draftmark"
    case downloadPicture = "download"
    case backToCommentPage = "back"
    case addAnotherOne = "goPage"
}

protocol SelectionViewDelegate: AnyObject {
    func didTapImageView(_ view: SeletionView, imagePicker: UIImagePickerController)
    func didFinishPickImage(_ view: SeletionView, image: UIImage, imagePicker: UIImagePickerController)
    
    func selectStore(_ view: SeletionView, textField: UITextField)
    func selectMeal(_ view: SeletionView, textField: UITextField, storeID: String)
    
    func didTapSelectValue(_ view: SeletionView, type: SelectionType)

    func didTapWriteComment(_ view: SeletionView)
}
class SeletionView: UIView {
    weak var delegate: SelectionViewDelegate?
    
    var selectedStoreID: String! {
        willSet {
            selectedStoreTextField.text = newValue
            selectedMeal = ""
            stackView.isHidden = true
        }
    }
    var selectedMeal: String! {
        willSet {
            selectedMealTextField.text = newValue
        }
    }
    let imageView = UIImageView()
    let imagePicker = UIImagePickerController()
    
    var selectedStoreTextField = UITextField()
    var selectedMealTextField = UITextField()
    
    let selectionBackgroundView = UIView()
    let stackView = UIStackView()
    
    let selectNoodelValueButton = UIButton()
    let selectSouplValueButton = UIButton()
    let selectOverAllValueButton = UIButton()
    
    let noodleLabel = UILabel()
    let soupLabel = UILabel()
    let overallLabel = UILabel()
    
    let writeCommentButton = UIButton()
    
    func configView() {
        setupImageView()
        setupBackgroundView()
        setupTextField()
        setupButtons()
    }
    func setupImageView() {
        addSubview(imageView)
        imageView.cornerRadii(radii: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.width - 32).isActive = true
        imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imageView.addGestureRecognizer(tap)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    func setupBackgroundView() {
        addSubview(selectionBackgroundView)
        selectionBackgroundView.backgroundColor = .C2
        selectionBackgroundView.cornerRadii(radii: 10)
        selectionBackgroundView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        selectionBackgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        selectionBackgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        selectionBackgroundView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 16).isActive = true
    }
    
    func setupTextField() {
        addSubview(selectedStoreTextField)
        selectedStoreTextField.delegate = self
        selectedStoreTextField.translatesAutoresizingMaskIntoConstraints = false
        selectedStoreTextField.backgroundColor = .B6
        selectedStoreTextField.text = "點擊選取店家"
        selectedStoreTextField.textColor = .B1
        selectedStoreTextField.topAnchor.constraint(equalTo: selectionBackgroundView.topAnchor, constant: 8).isActive = true
        selectedStoreTextField.leadingAnchor.constraint(equalTo: selectionBackgroundView.leadingAnchor, constant: 8).isActive = true
        selectedStoreTextField.font = UIFont.medium(size: 24)
        

        addSubview(selectedMealTextField)
        selectedMealTextField.delegate = self
        selectedMealTextField.translatesAutoresizingMaskIntoConstraints = false
        selectedMealTextField.backgroundColor = .B6
        selectedMealTextField.text = "點擊選取品項"
        selectedMealTextField.textColor = .B1
        selectedStoreTextField.font = UIFont.medium(size: 16)
        selectedMealTextField.topAnchor.constraint(equalTo: selectedStoreTextField.bottomAnchor, constant: 8).isActive = true
        selectedMealTextField.leadingAnchor.constraint(equalTo: selectedStoreTextField.leadingAnchor, constant: 0).isActive = true
        selectedMealTextField.isHidden = true
    }
    
    func setupButtons() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.topAnchor.constraint(equalTo: selectedMealTextField.bottomAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: selectionBackgroundView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: selectionBackgroundView.trailingAnchor, constant: -16).isActive = true
        let spacing = selectionBackgroundView.bounds.height - 8 - selectedStoreTextField.bounds.height - 8 - selectedMealTextField.bounds.height - 8 - 8
        stackView.heightAnchor.constraint(equalToConstant: spacing).isActive = true
        stackView.addArrangedSubview(selectNoodelValueButton)
        stackView.addArrangedSubview(selectSouplValueButton)
        stackView.addArrangedSubview(selectOverAllValueButton)
        stackView.isHidden = true

        selectNoodelValueButton.translatesAutoresizingMaskIntoConstraints = false
        selectNoodelValueButton.heightAnchor.constraint(equalTo: selectNoodelValueButton.widthAnchor, multiplier: 1).isActive = true
        selectNoodelValueButton.layer.cornerRadius = 15
        selectNoodelValueButton.setImage(UIImage(named: SelectionButton.selectNoodle.rawValue), for: .normal)
        selectNoodelValueButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectNoodelValueButton.backgroundColor = .black.withAlphaComponent(0.4)
        selectNoodelValueButton.tintColor = .white
        selectNoodelValueButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        selectSouplValueButton.translatesAutoresizingMaskIntoConstraints = false
        selectSouplValueButton.heightAnchor.constraint(equalTo: selectSouplValueButton.widthAnchor, multiplier: 1).isActive = true
        selectSouplValueButton.layer.cornerRadius = 15
        selectSouplValueButton.setImage(UIImage(named: SelectionButton.selectSoup.rawValue), for: .normal)
        selectSouplValueButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectSouplValueButton.backgroundColor = .black.withAlphaComponent(0.4)
        selectSouplValueButton.tintColor = .white
        selectSouplValueButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        selectOverAllValueButton.translatesAutoresizingMaskIntoConstraints = false
        selectOverAllValueButton.heightAnchor.constraint(equalTo: selectOverAllValueButton.widthAnchor, multiplier: 1).isActive = true
        selectOverAllValueButton.layer.cornerRadius = 15
        selectOverAllValueButton.setImage(UIImage(named: SelectionButton.selectHappy.rawValue), for: .normal)
        selectOverAllValueButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectOverAllValueButton.backgroundColor = .black.withAlphaComponent(0.4)
        selectOverAllValueButton.tintColor = .white
        selectOverAllValueButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        writeCommentButton.translatesAutoresizingMaskIntoConstraints = false
        writeCommentButton.heightAnchor.constraint(equalTo: writeCommentButton.widthAnchor, multiplier: 1).isActive = true
        writeCommentButton.layer.cornerRadius = 15
        writeCommentButton.setImage(UIImage(named: SelectionButton.notWriteComment.rawValue), for: .normal)
        writeCommentButton.addTarget(self, action: #selector(writeComment), for: .touchUpInside)
        writeCommentButton.backgroundColor = .black.withAlphaComponent(0.4)
        writeCommentButton.tintColor = .white
        writeCommentButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func setupLabels() {
        addSubview(noodleLabel)
        noodleLabel.translatesAutoresizingMaskIntoConstraints = false
        noodleLabel.topAnchor.constraint(equalTo: selectNoodelValueButton.bottomAnchor, constant: 8).isActive = true
        noodleLabel.centerYAnchor.constraint(equalTo: selectNoodelValueButton.centerYAnchor, constant: 0).isActive = true
        noodleLabel.font = .medium(size: 9)
        noodleLabel.tintColor = .B1
        noodleLabel.text = "麵條評分"
        noodleLabel.isHidden = true
        
        addSubview(soupLabel)
        soupLabel.translatesAutoresizingMaskIntoConstraints = false
        soupLabel.topAnchor.constraint(equalTo: selectSouplValueButton.bottomAnchor, constant: 8).isActive = true
        soupLabel.centerYAnchor.constraint(equalTo: selectSouplValueButton.centerYAnchor, constant: 0).isActive = true
        soupLabel.font = .medium(size: 9)
        soupLabel.tintColor = .B1
        soupLabel.text = "湯頭評分"
        soupLabel.isHidden = true
        
        addSubview(overallLabel)
        overallLabel.translatesAutoresizingMaskIntoConstraints = false
        overallLabel.topAnchor.constraint(equalTo: selectOverAllValueButton.bottomAnchor, constant: 8).isActive = true
        overallLabel.centerYAnchor.constraint(equalTo: selectOverAllValueButton.centerYAnchor, constant: 0).isActive = true
        overallLabel.font = .medium(size: 9)
        overallLabel.tintColor = .B1
        overallLabel.text = "綜合評分"
        overallLabel.isHidden = true
    }
    func showMealSelection() {
        selectedMealTextField.isHidden = false
    }
    func showValueSelection() {
        stackView.isHidden = false
    }
    func showCommentButton() {
        stackView.addArrangedSubview(writeCommentButton)
        UIView.animate(withDuration: 0.7) {
            self.layoutIfNeeded()
        }
    }
    
    
    @objc func tapImage() {
        delegate?.didTapImageView(self, imagePicker: imagePicker)
    }
    
    @objc func selectValue(sender: UIButton) {
        let type: SelectionType = {
            switch sender {
            case selectNoodelValueButton:
                return SelectionType.noodle
            case selectSouplValueButton:
                return SelectionType.soup
            case selectOverAllValueButton:
                return SelectionType.happy
            default:
                return SelectionType.noodle
            }
        }()
        delegate?.didTapSelectValue(self, type: type)
    }
    @objc func writeComment() {
        delegate?.didTapWriteComment(self)
    }
}

extension SeletionView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        delegate?.didFinishPickImage(self, image: image, imagePicker: picker)
    }
}

extension SeletionView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectedStoreTextField {
            self.delegate?.selectStore(self, textField: textField)
        } else {
            if selectedStoreID != nil {
                self.delegate?.selectMeal(self, textField: textField, storeID: selectedStoreID)
            }
        }
        return false
    }
}
