//
//  FontsViewController.swift
//  Postal
//
//  Created by Nic Ollis on 12/30/17.
//  Copyright © 2017 Ollis. All rights reserved.
//

import UIKit
import MobileCoreServices

class FontsViewController: UITableViewController {
    
    // MARK: - Properties
    
    let fonts = UIFont.familyNames.sorted()
    
    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dragDelegate = self
        title = "Fonts"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let fontName = fonts[indexPath.row]
        cell.textLabel?.text = fontName
        cell.textLabel?.font = UIFont(name: fontName, size: 18)
        
        return cell
    }

}

// MARK: - UITableViewDragDelegate
extension FontsViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let string = fonts[indexPath.row]
        guard let data = string.data(using: .utf8) else { return [] }
        
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    
}
