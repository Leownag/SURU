//
//  CommentSelectionView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit
import Alamofire


protocol CommentSelectionViewDelegate: AnyObject {
    func didGetSelectStore(_ view: CommentSelectionView, storeID: String)
    
    func didGetSelectMeal(_ view: CommentSelectionView, meal: String)
    
    func didTapSelectValue(_ view: CommentSelectionView, type: SelectionType)
    
    func didTapWriteComment(_ view: CommentSelectionView)
    
    func didTapNotWriteComment(_ view: CommentSelectionView)
    
    func didTapSendComment(_ view: CommentSelectionView)
    
    func didTapSaveComment(_ view: CommentSelectionView)
    
    func didTapDownloadImage(_ view: CommentSelectionView)
    
    func didTapAddoneMore(_ view: CommentSelectionView)
    
    func didTapGoAllPage(_ view: CommentSelectionView)
}
// 素材名稱
enum SelectionButton: String {
    case addPicture = "addMedia"
    
    case selectNoodle = "noodle"
    case selectSoup = "water"
    case selectHappy = "thumb"
    case writeComment = "writeComment"
    case notWriteComment = "notwriteComment"
    
    case saveCommentToDraft = "draftmark"
    case downloadPicture = "download"
    case backToCommentPage = "back"
    case addAnotherOne = "goPage"
}

class CommentSelectionView: UIView {
    weak var delegate: CommentSelectionViewDelegate?
    
    var selectedStoreID: String = ""
    
    var stores: [Store] = []
    
    func layoutSelectView(dataSource: [Store]) {
        stores = dataSource
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        initPickerView()
        initTextField()
        initButton()
    }
    // MARK: - 選取店家物件
    var selectedStoreTextField = UITextField()
    var selectedMealTextField = UITextField()
    var storePickerView = UIPickerView()
    var mealPickerView = UIPickerView()
    // MARK: - Value按鈕
    let selectNoodelValueButton = UIButton()
    let selectSouplValueButton = UIButton()
    let selectHappyValueButton = UIButton()
    // MARK: - 評論按鈕
    let writeCommentButton = UIButton()
    let notWriteCommentButton = UIButton()
    let stackView = UIStackView()
    let saveDraftButton = UIButton()
    
    func initTextField() {
        self.addSubview(selectedStoreTextField)
        selectedStoreTextField.translatesAutoresizingMaskIntoConstraints = false
        selectedStoreTextField.backgroundColor = .clear
        selectedStoreTextField.text = "輸入店家"
        selectedStoreTextField.textColor = .B1
        selectedStoreTextField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        selectedStoreTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        selectedStoreTextField.font = UIFont.medium(size: 30)
        selectedStoreTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        selectedStoreTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        selectedStoreTextField.inputView = storePickerView
        
        
        
        self.addSubview(selectedMealTextField)
        selectedMealTextField.translatesAutoresizingMaskIntoConstraints = false
        selectedMealTextField.backgroundColor = .clear
        selectedMealTextField.text = "輸入品項"
        selectedMealTextField.textColor = .B1
        selectedMealTextField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        selectedMealTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        selectedStoreTextField.font = UIFont.medium(size: 20)
        selectedMealTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        selectedMealTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        selectedMealTextField.inputView = mealPickerView
        
    }
    func initPickerView() {
        storePickerView.tag = 1
        storePickerView.delegate = self
        storePickerView.dataSource = self
        storePickerView.reloadAllComponents()
        
        mealPickerView.tag = 2
        mealPickerView.delegate = self
        mealPickerView.dataSource = self
        mealPickerView.reloadAllComponents()
    }
    
    func initButton() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.topAnchor.constraint(equalTo: selectedMealTextField.bottomAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        stackView.addArrangedSubview(selectNoodelValueButton)
        stackView.addArrangedSubview(selectSouplValueButton)
        stackView.addArrangedSubview(selectHappyValueButton)
        stackView.addArrangedSubview(notWriteCommentButton)
        
        selectNoodelValueButton.translatesAutoresizingMaskIntoConstraints = false
        selectNoodelValueButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        selectNoodelValueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        selectNoodelValueButton.layer.cornerRadius = 15
        selectNoodelValueButton.setImage( UIImage(named: SelectionButton.selectNoodle.rawValue), for: .normal)
        selectNoodelValueButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectNoodelValueButton.backgroundColor = .black.withAlphaComponent(0.4)
        selectNoodelValueButton.tintColor = .white
        selectNoodelValueButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        selectSouplValueButton.translatesAutoresizingMaskIntoConstraints = false
        selectSouplValueButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        selectSouplValueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        selectSouplValueButton.layer.cornerRadius = 15
        selectSouplValueButton.setImage( UIImage(named: SelectionButton.selectSoup.rawValue), for: .normal)
        selectSouplValueButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectSouplValueButton.backgroundColor = .black.withAlphaComponent(0.4)
        selectSouplValueButton.tintColor = .white
        selectSouplValueButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        selectHappyValueButton.translatesAutoresizingMaskIntoConstraints = false
        selectHappyValueButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        selectHappyValueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        selectHappyValueButton.layer.cornerRadius = 15
        selectHappyValueButton.setImage( UIImage(named: SelectionButton.selectHappy.rawValue), for: .normal)
        selectHappyValueButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectHappyValueButton.backgroundColor = .black.withAlphaComponent(0.4)
        selectHappyValueButton.tintColor = .white
        selectHappyValueButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        
        
        notWriteCommentButton.translatesAutoresizingMaskIntoConstraints = false
        notWriteCommentButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        notWriteCommentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        notWriteCommentButton.layer.cornerRadius = 15
        notWriteCommentButton.setImage( UIImage(named: SelectionButton.notWriteComment.rawValue), for: .normal)
        notWriteCommentButton.addTarget(self, action: #selector(notWriteComment), for: .touchUpInside)
        notWriteCommentButton.backgroundColor = .black.withAlphaComponent(0.4)
        notWriteCommentButton.tintColor = .white
        notWriteCommentButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        self.addSubview(saveDraftButton)
        saveDraftButton.translatesAutoresizingMaskIntoConstraints = false
        saveDraftButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        saveDraftButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveDraftButton.layer.cornerRadius = 20
        saveDraftButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        saveDraftButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        saveDraftButton.setImage( UIImage(named: "draftmark"), for: .normal)
        saveDraftButton.addTarget(self, action: #selector(saveCommentDraft), for: .touchUpInside)
        saveDraftButton.backgroundColor = .black.withAlphaComponent(0.4)
        saveDraftButton.tintColor = .white
        saveDraftButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    func initValueView(on view: UIView, value: Double) {
        // round view
            let roundView = UIView(
                frame: CGRect(
                    x: view.bounds.origin.x,
                    y: view.bounds.origin.y,
                    width: view.bounds.size.width - 4,
                    height: view.bounds.size.height - 4
                )
            )
            roundView.backgroundColor = .B5
            roundView.layer.cornerRadius = roundView.frame.size.width / 2
            
            // bezier path
            let circlePath = UIBezierPath(arcCenter: CGPoint (x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
                                          radius: roundView.frame.size.width / 2,
                                          startAngle: CGFloat(-0.5 * .pi),
                                          endAngle: CGFloat(1.5 * .pi),
                                          clockwise: true)
            // circle shape
            let circleShape = CAShapeLayer()
            circleShape.path = circlePath.cgPath
            circleShape.strokeColor = UIColor.red.cgColor
            circleShape.fillColor = UIColor.clear.cgColor
            circleShape.lineWidth = 4
            // set start and end values
            circleShape.strokeStart = 0.0
        circleShape.strokeEnd = value*0.1
            
            // add sublayer
            roundView.layer.addSublayer(circleShape)
            // add subview
            view.addSubview(roundView)
        view.removeFromSuperview()
    }
}
// MARK: - Button objc func
extension CommentSelectionView {
    @objc func selectValue(sender: UIButton) {
        let type: SelectionType = {
            switch sender {
            case selectNoodelValueButton:
                return SelectionType.noodle
            case selectSouplValueButton:
                return SelectionType.soup
            case selectHappyValueButton:
                return SelectionType.happy
            default:
                return SelectionType.happy
            }
        }()
        self.delegate?.didTapSelectValue(self, type: type)
    }
    @objc func writeComment() {
        self.delegate?.didTapWriteComment(self)
    }
    @objc func notWriteComment() {
        self.delegate?.didTapNotWriteComment(self)
    }
    @objc func downloadImage() {
        self.delegate?.didTapDownloadImage(self)
    }
    @objc func sendComment() {
        self.delegate?.didTapSendComment(self)
    }
    @objc func saveCommentDraft() {
        self.delegate?.didTapSaveComment(self)
    }
}

extension CommentSelectionView: UITextFieldDelegate {
    private func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.B2
        }
    }
    private func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            switch textView {
            case selectedStoreTextField:
                textView.text = "輸入店家"
            case selectedMealTextField:
                textView.text = "輸入品項"
            default:
                textView.text = ""
            }
        }
    }
}
extension CommentSelectionView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return stores.count
        case 2:
            var storeHodler: Store?
            for store in stores where selectedStoreID == store.storeID {
                storeHodler = store
            }
            guard let storeHodler = storeHodler else {
                return 0
            }
            return storeHodler.meals.count
        default :
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return stores[row].name
        case 2:
            var storeHodler: Store?
            for store in stores where selectedStoreID == store.storeID {
                storeHodler = store
            }
            guard let storeHodler = storeHodler else {
                return ""
            }
            return storeHodler.meals[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            selectedStoreID = stores[row].storeID
            selectedStoreTextField.text = stores[row].name
            self.delegate?.didGetSelectStore(self, storeID: selectedStoreID)
        case 2:
            for store in stores where selectedStoreID == store.storeID {
                for store in stores where selectedStoreID == store.storeID {
                    let meal = store.meals[row]
                    selectedMealTextField.text = meal
                    self.delegate?.didGetSelectMeal(self, meal: meal)
                }
            }
        default:
            return
        }
    }
}

