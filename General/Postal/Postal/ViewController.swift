//
//  ViewController.swift
//  Postal
//
//  Created by Nic Ollis on 12/30/17.
//  Copyright © 2017 Ollis. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var colors = [UIColor]()
    
    var image: UIImage?
    
    var topText = "Visit Indy"
    var topFontName = "Helvetica Neue"
    var topColor = UIColor.white
    
    var bottomText = "Home of ClusterTruck"
    var bottomFontName = "Helvetica Neue"
    var bottomColor = UIColor.white
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var postcard: UIImageView!
    @IBOutlet weak var colorSelection: UICollectionView!
    
    // MARK: - IBActions
    
    @IBAction func changeText(_ sender: UIGestureRecognizer) {
        let location = sender.location(in: postcard)
        
        let changeTop: Bool
        
        if location.y < postcard.bounds.midY {
            changeTop = true
        } else {
            changeTop = false
        }
        
        let alertController = UIAlertController(title: "Change text", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Write what you want to say"
            
            if changeTop {
                textField.text = self.topText
            } else {
                textField.text = self.bottomText
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Change", style: .default, handler: { [unowned self] (_) in
            guard let text = alertController.textFields?[0].text else { return }
            
            if changeTop {
                self.topText = text
            } else {
                self.bottomText = text
            }
            
            self.renderPostcard()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true)
    }
    
    // MARK: - Instance Methods
    
    func renderPostcard() {
        let drawRect = CGRect(x: 0, y: 0, width: 3000, height: 2400)
        
        let topTextRect = CGRect(x: 250, y: 200, width: 2500, height: 600)
        let bottomTextRect = CGRect(x: 250, y: 1800, width: 2500, height: 600)
        
        let topFont = UIFont(name: topFontName, size: 350) ?? UIFont.systemFont(ofSize: 250)
        let bottomFont = UIFont(name: bottomFontName, size: 150) ?? UIFont.systemFont(ofSize: 100)
        
        let centered = NSMutableParagraphStyle()
        centered.alignment = .center
        
        let topTextAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: topColor,
            .font: topFont,
            .paragraphStyle: centered
            ]
        let bottomTextAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: bottomColor,
            .font: bottomFont,
            .paragraphStyle: centered
        ]
        
        let renderer = UIGraphicsImageRenderer(size: drawRect.size)
        
        postcard.image = renderer.image(actions: { (context) in
            UIColor.gray.set()
            context.fill(drawRect)
            image?.draw(at: CGPoint(x: 0, y: 0))
            
            topText.draw(in: topTextRect, withAttributes: topTextAttributes)
            bottomText.draw(in: bottomTextRect, withAttributes: bottomTextAttributes)
        })
    }
    
    // MARK: - ViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        colors += [.black, .gray, .white, .yellow, .orange, .red, .magenta, .purple, .blue, .cyan, .green]
        
        for i in 0...9 {
            for j in 1...10 {
                let color = UIColor(hue: CGFloat(i)/10, saturation: CGFloat(j)/10, brightness: 1, alpha: 1)
                colors.append(color)
            }
        }
        
        renderPostcard()
        
        colorSelection.dragDelegate = self
        
        postcard.isUserInteractionEnabled = true
        let dropInteraction = UIDropInteraction(delegate: self)
        postcard.addInteraction(dropInteraction)
        let dragInteraction = UIDragInteraction(delegate: self)
        postcard.addInteraction(dragInteraction)
        
        title = "Edit Postcard"
        splitViewController?.view.backgroundColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = colors[indexPath.row]
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDragDelegate
extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let color = colors[indexPath.row]
        let provider = NSItemProvider(object: color)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
}

// MARK: - UIDropInteractionDelegate
extension ViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let location = session.location(in: postcard)
        
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            session.loadObjects(ofClass: NSString.self, completion: {[unowned self] (items) in
                guard let string = items.first as? String else { return }
                
                if location.y < self.postcard.bounds.midY {
                    self.topFontName = string
                } else {
                    self.bottomFontName = string
                }
                
                self.renderPostcard()
            })
        } else if session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) {
            session.loadObjects(ofClass: UIImage.self, completion: {[unowned self] (items) in
                guard let draggedImage = items.first as? UIImage else { return }
                
                self.image = draggedImage
                self.renderPostcard()
            })
        } else {
            session.loadObjects(ofClass: UIColor.self) { [unowned self] items in
                guard let color = items.first as? UIColor else { return }
                
                if location.y < self.postcard.bounds.midY {
                    self.topColor = color
                } else {
                    self.bottomColor = color
                }
                
                self.renderPostcard()
            }
        }
    }
}

// Mark: - UIDragInteractionDelegate
extension ViewController: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let image = postcard.image else { return [] }
        
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        
        return [item]
    }
    
    
}
