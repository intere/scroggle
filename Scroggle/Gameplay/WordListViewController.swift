//
//  WordListViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/10/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

class WordListViewController: UITableViewController {

    var wordList: [String] {
        return GameContextProvider.instance.currentGame?.game.words.reversed() ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Notification.Scroggle.GameEvent.scoreUpdated.addObserver(tableView, selector: #selector(tableView.reloadData))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)

        guard let wordCell = cell as? WordCell, indexPath.row < wordList.count else {
            return cell
        }

        wordCell.word = wordList[indexPath.row]

        return wordCell
    }
}
