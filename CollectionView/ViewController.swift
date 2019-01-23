//
//  ViewController.swift
//  CollectionView
//
//  Created by Galo Torres Sevilla on 1/23/19.
//  Copyright © 2019 Galo Torres Sevilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(collectionView)
        collectionView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        collectionView.register(TopCell.self, forCellWithReuseIdentifier: "topCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as! TopCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
    }

}

class BaseCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() { }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TopCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ButtonCellDelegate {
    
    var model = "Text"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .green
        self.addSubview(collectionView)
        collectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        collectionView.register(ButtonsCell.self, forCellWithReuseIdentifier: "buttonsCell")
        collectionView.register(InnerCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonsCell", for: indexPath) as! ButtonsCell
            cell.buttonCellDelegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! InnerCollectionViewCell
        cell.model = self.model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 150)
    }
    
    func didPressButton(sender: String) {
        
        switch sender {
        case "buttonOne":
            self.model = "Text"
            self.collectionView.reloadData()
        case "buttonTwo":
            self.model = "New Text"
            self.collectionView.reloadData()
        default:
            break
        }
        
        
    }
}

// Protocol for buttons

protocol ButtonCellDelegate : class { func didPressButton (sender: String) }

// Buttons Cell

class ButtonsCell : BaseCell {
    
    weak var buttonCellDelegate : ButtonCellDelegate?
    
    let buttonOne : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Button 1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let buttonTwo : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Button 2", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(buttonOne)
        buttonOne.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, size: .init(width: self.frame.width / 2, height: 0))
        buttonOne.addTarget(self, action: #selector(buttonOnePressed), for: .touchUpInside)
        self.addSubview(buttonTwo)
        buttonTwo.anchor(top: self.topAnchor, leading: buttonOne.trailingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        buttonTwo.addTarget(self, action: #selector(buttonTwoPressed), for: .touchUpInside)
    }
    
    @objc func buttonTwoPressed (sender: UIButton) {
        self.buttonCellDelegate?.didPressButton(sender: "buttonTwo")
    }
    
    @objc func buttonOnePressed (sender: UIButton) {
        self.buttonCellDelegate?.didPressButton(sender: "buttonOne")
    }
}

// Mark

class InnerCollectionViewCell : BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var model : String? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(collectionView)
        collectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        collectionView.register(InnerCollectionViewSubCell.self, forCellWithReuseIdentifier: "innerCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "innerCell", for: indexPath) as! InnerCollectionViewSubCell
        cell.model = self.model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}

// Mark

class InnerCollectionViewSubCell : BaseCell {
    
    var model : String? {
        didSet { label.text = model }
    }
    
    let label : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(label)
        label.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
}

// Extensions

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top { topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true }
        if let leading = leading { leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true }
        if let bottom = bottom { bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true }
        if let trailing = trailing { trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true }
        if size.width != 0 { widthAnchor.constraint(equalToConstant: size.width).isActive = true }
        if size.height != 0 { heightAnchor.constraint(equalToConstant: size.height).isActive = true }
    }
}


