//
//  WordsTableViewController.swift
//  Wordalysis
//
//  Created by Nicholas Ollis on 4/8/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class WordsTableViewController: UITableViewController {
    
    var words: WordCounter!
    var sortedWords: [(key: String, value: Int)] = []
    var timer: DispatchSourceTimer?
    var displayLink: CADisplayLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard words != nil else {
            preconditionFailure("WordCounter should be added before attempting to load view")
        }
        sortedWords = words.currentState.wordList.sorted(by: { $0.1 > $1.1 })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startUpdating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopUpdating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startUpdating() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: .now(), repeating: .milliseconds(32), leeway: .microseconds(5))
        timer?.setEventHandler(qos: .userInitiated, flags: [], handler: self.update)
        timer?.resume()
        displayLink = CADisplayLink(target: self, selector: #selector(displayUpdate))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    func stopUpdating() {
        timer?.cancel()
        timer = nil
        update()
        displayLink.invalidate()
    }
    
    func update() {
        sortedWords = words.currentState.wordList.sorted(by: { $0.1 > $1.1 })
        tableView.reloadData()
    }
    
    @objc func displayUpdate() {
        navigationItem.title = "\(words.currentState.totalCount) words"
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return }
        
        for indexPath in visibleIndexPaths {
            guard let cell = tableView.cellForRow(at: indexPath),
                let key = cell.detailTextLabel?.text,
                let count = words.currentState.wordList[key]
                else { continue }
            cell.textLabel?.text = String(count)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return words.currentState.wordList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsCell", for: indexPath)
        cell.textLabel?.text = String(sortedWords[indexPath.row].value)
        cell.detailTextLabel?.text = sortedWords[indexPath.row].key

        return cell
    }

}
