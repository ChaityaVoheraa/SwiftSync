//
//  AddChannelTableViewController.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 23/04/24.
//

import Gallery
import ProgressHUD
import UIKit

class AddChannelTableViewController: UITableViewController {
    // MARK: - IBOutlet
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var aboutTextView: UITextView!
    
    // MARK: - Vars
    
    var gallery: GalleryController!
    var tapGesture = UITapGestureRecognizer()
    var avatarLink = ""
    var channelId = UUID().uuidString
    
    var channelToEdit: Channel?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        configureGestures()
        configureLeftBarButton()
        
        if channelToEdit != nil {
            configureEditingView()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if nameTextField.text != "" {
            channelToEdit != nil ? editChannel() : saveChannel()
        } else {
            ProgressHUD.showError("Channel name is empty!")
        }
    }
    
    @objc func avatarImageTap() {
        showGallery()
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Configuration
    
    private func configureGestures() {
        tapGesture.addTarget(self, action: #selector(avatarImageTap))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    private func configureLeftBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed))
    }
    
    private func configureEditingView() {
        nameTextField.text = channelToEdit!.name
        channelId = channelToEdit!.id
        aboutTextView.text = channelToEdit!.aboutChannel
        avatarLink = channelToEdit!.avatarLink
        title = "Editing Channel"
        
        setAvatar(avatarLink: channelToEdit!.avatarLink)
    }
    
    // MARK: - Save Channel
    
    private func saveChannel() {
        let channel = Channel(id: channelId, name: nameTextField.text!, adminId: User.currentId, memberIds: [User.currentId], avatarLink: avatarLink, aboutChannel: aboutTextView.text)
        
        FirebaseChannelListener.shared.saveCannel(channel)
        
        navigationController?.popViewController(animated: true)
    }
    
    private func editChannel() {
        channelToEdit!.name = nameTextField.text!
        channelToEdit!.aboutChannel = aboutTextView.text
        channelToEdit!.avatarLink = avatarLink
        
        FirebaseChannelListener.shared.saveCannel(channelToEdit!)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Gallery
    
    private func showGallery() {
        gallery = GalleryController()
        gallery.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        present(gallery, animated: true, completion: nil)
    }
    
    // MARK: - Avatars
    
    private func uploadAvatarImage(_ image: UIImage) {
        let fileDirectory = "Avatars/" + "_\(channelId)" + ".jpg"
        
        FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.7)! as NSData, fileName: channelId)
        
        FileStorage.uploadImage(image, directory: fileDirectory) { avatarLink in
            
            self.avatarLink = avatarLink ?? ""
        }
    }
    
    private func setAvatar(avatarLink: String) {
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { avatarImage in
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        } else {
            avatarImageView.image = UIImage(named: "avatar")
        }
    }
}

extension AddChannelTableViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            images.first!.resolve { icon in
                
                if icon != nil {
                    self.uploadAvatarImage(icon!)
                    self.avatarImageView.image = icon!.circleMasked
                } else {
                    ProgressHUD.showFailed("Couldn't select image!")
                }
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
