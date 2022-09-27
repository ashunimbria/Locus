//
//  ViewController.swift
//  LocusTestApp
//
//  Created by Ashish Nimbria on 26/09/22.
//

import UIKit

enum FormType: String, Codable {
    case comment = "COMMENT"
    case photo = "PHOTO"
    case singleChoice = "SINGLE_CHOICE"
}

class FormViewController: UIViewController {
    
    @IBOutlet weak var tfTitlePhoto: UITextField!
    @IBOutlet weak var imgCapturedImageView: UIImageView!
    @IBOutlet weak var tfSingleChoice: UITextField!
    @IBOutlet weak var tfComment: UITextView!
    @IBOutlet weak var tfCommentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnOptionA: UIButton!
    @IBOutlet weak var btnOptionB: UIButton!
    @IBOutlet weak var btnOptionC: UIButton!
    
    var formDataArray: [FormData] = [FormData]()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegates()
        setupCommentTextView()
        makeImageViewClickable()
    }
    
    @IBAction func onClickSubmit() {
        let displayViewController = storyboard?.instantiateViewController(withIdentifier: "DisplayViewController") as! DisplayViewController
        displayViewController.customInputFormData = formDataArray
        displayViewController.manager = JSONManager()
        navigationController?.pushViewController(displayViewController, animated: true)
    }
    
    @IBAction func onClickSwitch(_ sender: UISwitch) {
        if sender.isOn {
            showCommentView()
            createCommentData()
        } else {
            hideCommentView()
            deleteCommentData()
        }
    }
    
    @IBAction func onClickChoice(_ sender: UIButton) {
        
        var option: String = ""
        
        if sender.tag == 1 {
            btnOptionA.isSelected = true
            btnOptionB.isSelected = false
            btnOptionC.isSelected = false
            option = btnOptionA.titleLabel?.text ?? ""
        }
        
        if sender.tag == 2 {
            btnOptionA.isSelected = false
            btnOptionB.isSelected = true
            btnOptionC.isSelected = false
            option = btnOptionB.titleLabel?.text ?? ""
        }
        
        if sender.tag == 3 {
            btnOptionA.isSelected = false
            btnOptionB.isSelected = false
            btnOptionC.isSelected = true
            option = btnOptionC.titleLabel?.text ?? ""
        }
        
        let dataMap: DataMap = DataMap(options: [option])
        
        if let row = self.formDataArray.firstIndex(where: {$0.type == .singleChoice}) {
            formDataArray[row].updateDataMap(dataMap: dataMap)
        } else {
            let title: String = tfSingleChoice.text ?? ""
            let id = "choice\(getRandomNumber())"
            let dataMap: DataMap = DataMap(options: [option])
            let formData: FormData = FormData(type: .singleChoice, id: id, title: title, dataMap: dataMap)
            formDataArray.append(formData)
        }
    }
    
    private func setTextFieldDelegates() {
        tfTitlePhoto.delegate = self
        tfSingleChoice.delegate = self
        tfComment.delegate = self
    }
    
    private func setupCommentTextView() {
        hideCommentView()
        tfComment.text = "Type Comment"
        tfComment.layer.borderColor = UIColor.lightGray.cgColor
        tfComment.textColor = UIColor.lightGray
    }
    
    private func makeImageViewClickable() {
        imgCapturedImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLibrary))
        imgCapturedImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func openLibrary() {
        if imgCapturedImageView.image == nil {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            }
        } else {
            presentImage()
        }
    }
    
    private func createImageData() {
        let title = tfTitlePhoto.text ?? ""
        let id = "photo\(getRandomNumber())"
        let formData = FormData(type: .photo, id: id, title: title, dataMap: nil)
        formDataArray.append(formData)
    }
    
    private func presentImage() {
        let imageViewPresenter = storyboard?.instantiateViewController(withIdentifier: "ImageViewPresenter") as! ImageViewPresenter
        imageViewPresenter.image = imgCapturedImageView.image
        self.present(imageViewPresenter, animated: true)
    }
    
    private func getRandomNumber() -> Int {
        return Int.random(in: 10...100)
    }
    
    private func showCommentView() {
        tfComment.isHidden = false
        tfCommentHeightConstraint.constant = 75
    }
    
    private func hideCommentView() {
        tfComment.isHidden = true
        tfCommentHeightConstraint.constant = 1
    }
    
    private func createCommentData() {
        var title: String = ""
        if tfComment.text != "Type Comment" {
            title = tfComment.text ?? ""
        }
        
        let id = "comment\(getRandomNumber())"
        let formData = FormData(type: .comment, id: id, title: title, dataMap: nil)
        formDataArray.append(formData)
    }
    
    private func deleteCommentData() {
        if let row = self.formDataArray.firstIndex(where: {$0.type == .comment}) {
            formDataArray.remove(at: row)
        }
    }
}

extension FormViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgCapturedImageView.image = image
            createImageData()
        }
    }
}

extension FormViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfTitlePhoto {
            if let newTitle = textField.text, let row = self.formDataArray.firstIndex(where: {$0.type == .photo}) {
                formDataArray[row].updateTitle(newTitle: newTitle.appending(string))
            }
        }
        
        if textField == tfSingleChoice {
            if let newTitle = textField.text, let row = self.formDataArray.firstIndex(where: {$0.type == .singleChoice}) {
                formDataArray[row].updateTitle(newTitle: newTitle.appending(string))
            }
        }
        
        return true
    }
}

extension FormViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type Comment"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == tfComment {
            if let newTitle = textView.text, let row = self.formDataArray.firstIndex(where: {$0.type == .comment}) {
                formDataArray[row].updateTitle(newTitle: newTitle)
            }
        }
    }
}
