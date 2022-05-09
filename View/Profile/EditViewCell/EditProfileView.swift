//
//  EditProfileView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/5.
//

import UIKit
import Kingfisher

protocol EditProfileViewDelegate: AnyObject {
    func didSelectImage(_ view: EditProfileView, image: UIImage)
    func didSelectImage(_ view: EditProfileView, image: UIImage, imagePickView: UIImagePickerController)
    func didTapImagePicker(_ view: EditProfileView, imagePicker: UIImagePickerController?)
    func didEditNickName(_ view: EditProfileView, text: String)
    func didEditWebSide(_ view: EditProfileView, text: String)
    func didEditBio(_ view: EditProfileView, text: String)
    func didTapEditImage(_ view: EditProfileView, alert: UIAlertController)
}
class EditProfileView: UIView {
    weak var delegate: EditProfileViewDelegate?
    
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var websideLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var nickNameTextfield: UITextField!
    @IBOutlet weak var websideTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var editImageButton: UIButton!
    var imagePicker: UIImagePickerController? {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        return imagePicker
    }
    @IBAction func tapEditImageButton(_ sender: UIButton) {
        showAlert()
    }
    
    func layoutView(currentUser: Account) {
        mainImageView.kf.setImage(with: URL(string: currentUser.mainImage))
        mainImageView.layer.cornerRadius = 40
        mainImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        mainImageView.addGestureRecognizer(tap)
        nickNameTextfield.text = currentUser.name
        nickNameTextfield.delegate = self
        websideTextField.delegate = self
        bioTextView.delegate = self
        if let webSide = currentUser.websideLink {
            websideTextField.text = webSide
        }
        if let bio = currentUser.bio {
            bioTextView.text = bio
        }
    }
    
    @objc func tapImage() {
        showAlert()
    }
    
    private func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "移除目前的大頭貼照", style: .default , handler:{ (UIAlertAction)in
            LKProgressHUD.showSuccess(text: "修改成功")
            guard let image = UIImage(named: "AppIcon") else { return }
            self.mainImageView.image = image
            self.delegate?.didSelectImage(self, image: image)
        }))
        alert.addAction(UIAlertAction(title: "從圖庫選擇", style: .default , handler:{ (UIAlertAction)in
            self.delegate?.didTapImagePicker(self, imagePicker: self.imagePicker)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.delegate?.didTapEditImage(self, alert: alert)
    }
}

extension EditProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        mainImageView.image = image
        self.delegate?.didSelectImage(self, image: image, imagePickView: picker)
    }
}
extension EditProfileView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.didEditBio(self, text: textView.text)
    }
}

extension EditProfileView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == websideTextField {
            if !verifyUrl(urlString: textField.text) {
                textField.textColor = .red
                self.delegate?.didEditWebSide(self, text: "無效網址")
            } else {
                if #available(iOS 15.0, *) {
                    textField.textColor = .tintColor
                    self.delegate?.didEditWebSide(self, text: textField.text ?? "")
                } else {
                    textField.textColor = .blue
                    self.delegate?.didEditWebSide(self, text: textField.text ?? "")
                }
            }
        } else {
            self.delegate?.didEditNickName(self, text: textField.text ?? "")
        }
    }
}
