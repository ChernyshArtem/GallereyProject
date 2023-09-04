//
//  GallereyViewController.swift
//  GallereyProject
//
//  Created by Артём Черныш on 19.08.23.
//

import UIKit
import SnapKit
import UniformTypeIdentifiers

class GallereyViewController: UIViewController, UIDocumentPickerDelegate {
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = view.frame.width
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(imagesCollectionViewCell.self, forCellWithReuseIdentifier: imagesCollectionViewCell.cellIdentifier)
        
        return collectionView
    }()
    
    private var arrayOfImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Добавить", image: nil, target: self, action: #selector(addImage))
        setupCollectionView()
        DispatchQueue.main.async { [weak self] in
            let arrayOfUmagesURLS = URLManager.getImagesURL()
            for fileName in arrayOfUmagesURLS {
                guard let saveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                
                let fileURL = URL(fileURLWithPath: fileName, relativeTo: saveDirectory).appendingPathExtension("png")
                self?.loadImage(from: fileURL)
            }
            self?.imagesCollectionView.reloadData()
        }
    }
    
    
    private func setupCollectionView() {
        view.addSubview(imagesCollectionView)
        imagesCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addImage() {
        let alert = UIAlertController(title: "Добавление фотографии", message: "Выберите вариант для добавления фотографии", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .camera
            self?.present(pickerController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .photoLibrary
            self?.present(pickerController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Документы", style: .default, handler: { [weak self] _ in
            self?.selectFiles()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadImage(from fileURL: URL) {
        guard let savedData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: savedData) else { return }
        
        arrayOfImages.append(image)
    }
    
    func saveImage(image: UIImage) {
        DispatchQueue.global().async {
            guard let saveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                      let imageData = image.pngData() else { return }
            let fileName = "\(URLManager.getImagesURL().count + 1)"
            let fileURL = URL(fileURLWithPath: fileName, relativeTo: saveDirectory).appendingPathExtension("png")
            try? imageData.write(to: fileURL)
            URLManager.setImageName(imageURL: fileName)
        }
    }
    
    func selectFiles() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else { return }
        let data = try? Data(contentsOf: myURL)
        let image = UIImage(data: data ?? Data())
        arrayOfImages.append(image ?? UIImage())
        saveImage(image: image ?? UIImage())
        imagesCollectionView.reloadData()
     }
    
}

extension GallereyViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let errorImage = UIImage(systemName: "xmark.circle") else { return }
        arrayOfImages.append(info[.originalImage] as? UIImage ?? errorImage)
        picker.dismiss(animated: true)
        saveImage(image: (arrayOfImages.last ?? UIImage(systemName: "xmark.circle"))!)
        imagesCollectionView.reloadData()
    }
}

extension GallereyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagesCollectionViewCell.cellIdentifier, for: indexPath) as? imagesCollectionViewCell else { return UICollectionViewCell() }
        let a = (view.frame.width / 3) - 8
        cell.configure(image: arrayOfImages[indexPath.row], imageSize: a )
        return cell
    }
}

extension GallereyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
