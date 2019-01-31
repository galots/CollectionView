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
        layout.minimumLineSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let additionButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Addition", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let subtractionButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Subtraction", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private var additionModel = AchievementModel(achievement: Achievement.addition)
    private var subtractionModel = AchievementModel(achievement: Achievement.subtraction)
    private lazy var additionCellModel = CellModel(achievementModel: self.additionModel)
    private lazy var subtractionCellModel = CellModel(achievementModel: self.subtractionModel)
    private var additionGamesWon : Int = 0
    private var subtractionGamesWon : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(additionButton)
        additionButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: nil,
                              size: .init(width: self.view.frame.width / 2, height: 100))
        additionButton.addTarget(self, action: #selector(additionGame), for: .touchUpInside)
        
        self.view.addSubview(subtractionButton)
        subtractionButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.additionButton.trailingAnchor, bottom: nil, trailing: self.view.trailingAnchor,
                                 size: .init(width: 0, height: 100))
        subtractionButton.addTarget(self, action: #selector(subtractionGame), for: .touchUpInside)
        
        self.view.addSubview(collectionView)
        collectionView.anchor(top: self.additionButton.bottomAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
    }
    
    @objc func additionGame (sender: UIButton) {
        self.additionGamesWon += 1
        self.additionModel.games = self.additionGamesWon
        self.additionCellModel.update(additionModel)
        collectionView.reloadData()
    }
    
    @objc func subtractionGame (sender: UIButton) {
        self.subtractionGamesWon += 1
        self.subtractionModel.games = self.subtractionGamesWon
        self.subtractionCellModel.update(subtractionModel)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        if indexPath.item == 0 {
            cell.configure(with: self.additionCellModel)
        } else {
            cell.configure(with: self.subtractionCellModel)
        }
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 100)
    }

}

// This are the achievement types that you want, you can add as many as you like.
public enum Achievement {
    case addition, subtraction
}

// The model for the achievement, this sets the number of games won and the type of achievement
struct AchievementModel {
    var achievement : Achievement
    
    var games : Int = 0

    init (achievement: Achievement) {
        self.achievement = achievement
    }
}

// Cell model. Updates the label when needed and depends on the achievement
struct CellModel {
    private var achievementModel : AchievementModel {
        didSet {
            self.setAchievementLabel()
        }
    }
    var achievementText : String = ""
    var numberOfGames : Int = 0
    // Change the milestones here as you want
    private let milestones = [10, 15, 20]
    private var currentIndex : Int
    
    init(achievementModel: AchievementModel) {
        self.achievementModel = achievementModel
        self.currentIndex = 0
        setAchievementLabel()
    }
    
    mutating func update (_ achievementModel: AchievementModel) {
        if self.milestones.contains(achievementModel.games) {
            self.achievementModel = achievementModel
        }
        self.numberOfGames = achievementModel.games
    }
    
    private mutating func setAchievementLabel () {
        switch self.achievementModel.achievement {
        case .addition:
            self.achievementText = "Win \(self.milestones[self.currentIndex]) games in Addition Mode"
            if currentIndex < self.milestones.count - 1 { self.currentIndex += 1 }
        case .subtraction:
            self.achievementText = "Win \(self.milestones[self.currentIndex]) games in Subtraction Mode"
            if currentIndex < self.milestones.count - 1 { self.currentIndex += 1 }
        }
    }
}

// A protocol to cofigure the cell
protocol ConfigurableCell: class {
    func configure(with cellModel: CellModel)
}

// A collection view cell that can be configured with a cell model
class Cell : UICollectionViewCell, ConfigurableCell {
    
    private let label : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let numberLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(label)
        label.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, size: .init(width: 0, height: 50))
        self.addSubview(numberLabel)
        numberLabel.anchor(top: self.label.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellModel: CellModel) {
        self.label.text = cellModel.achievementText
        self.numberLabel.text = String(cellModel.numberOfGames)
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


