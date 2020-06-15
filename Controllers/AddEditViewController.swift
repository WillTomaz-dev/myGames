//
//  AddEditViewController.swift
//  MyGames
//
//  Created by William Tomaz on 10/06/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game!
    var consolesManager = ConsolesManager.shared
    var edit: Bool = false
    
    lazy var pickerView: UIPickerView = {
       let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancel, btFlexibleSpace, btDone]
        
        tfConsole.inputAccessoryView = toolbar
        tfConsole.inputView = pickerView
    }
    @objc func cancel() {
        tfConsole.resignFirstResponder()
    }
    
    @objc func done() {
        tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consolesManager.loadConsoles(with: context)
        if edit == false {
            navigationItem.title = "Adicionar"
            btCover.setTitle("Toque para adicionar a imagem de capa", for: .normal)
            btAddEdit.setTitle("Adicionar", for: .normal)
        } else {
            navigationItem.title = "Editar"
            tfTitle.text = game.title
            tfConsole.text = game.console?.name
//            if let index = consolesManager.consoles.index(of: game.console?.name) {
//                pickerView.selectRow(index, inComponent: 0, animated: false)
//            }
            if let releaseDate = game.releaseDate {
                dpReleaseDate.date = releaseDate
            }
            if let image = game.cover as? UIImage {
                ivCover.image = image
                btCover.setTitle("Toque para alterar a imagem de capa", for: .normal)
                btCover.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
                
            } else {
                btCover.setTitle("Toque para adicionar a imagem de capa", for: .normal)
            }
            btAddEdit.setTitle("Editar", for: .normal)
            }
    }
    
    @IBAction func addEditGame(_ sender: UIButton) {
        if game == nil {
            game = Game(context: context)
        }
        
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date
        if !tfConsole.text!.isEmpty {
            let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
            game.console = console
        }
        game.cover = ivCover.image
        
        do {
            try context.save()
        }catch {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addEditCover(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar Poster", message: "De onde você deseja escolher a imagem?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let photosAction = UIAlertAction(title: "Albúm de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
    }
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { //colunas
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //linhas
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}

extension UITextField {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage
        ivCover.image = image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
