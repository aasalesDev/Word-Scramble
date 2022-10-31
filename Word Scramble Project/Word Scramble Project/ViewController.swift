//
//  ViewController.swift
//  Word Scramble Project
//
//  Created by Anderson Sales on 31/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailTableViewCell.nib(), forCellReuseIdentifier: DetailTableViewCell.identifier)
        populatesTheWordsArray()
        startGame()
        addNavigationItem()
    }
    
    func populatesTheWordsArray() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }

        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func addNavigationItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()
        
        //let errorTitle: String
        //let errorMessage: String
        
        if isNotEqual(word: lowerAnswer) {
            if isPossible(word: lowerAnswer){
                if isLargeEnough(word: lowerAnswer) {
                    if isOriginal(word: lowerAnswer){
                        if isReal(word: lowerAnswer){
                            usedWords.insert(answer, at: 0)
                            let indexPath = IndexPath(row: 0, section: 0)
                            tableView.insertRows(at: [indexPath], with: .automatic)
                            return
                        } else {
                            showErrorMessage(errorTitle: "Word Not Recognized!", errorMessage: "The word \(answer) does not exist in the English Dictionary!")
                            //errorTitle = "Word Too Short"
                            //errorMessage = "The word \(answer) is too short. Word should have at least three characters!"
                        }
                    } else {
                        showErrorMessage(errorTitle: "Word Already Used!", errorMessage: "You have already used the word \(answer). Please try a different one!")
                        //errorTitle = "Word Not Valid"
                        //errorMessage = "You cannot use the same word provided by the challenge. Please try a different one!"
                    }
                    
                } else {
                    showErrorMessage(errorTitle: "Word Too Short", errorMessage: "The word \(answer) is too short. Word should have at least three characters!")
                    //errorTitle = "Word Not Recognized!"
                    //errorMessage = "The word \(answer) does not exist in the English Dictionary!"
                }
            } else {
                showErrorMessage(errorTitle: "Word Not Possible!", errorMessage: "You can't spell \(answer) from \(title!.lowercased())!")
                //errorTitle = "Word Already Used!"
                //errorMessage = "You have already used the word \(answer). Please try a different one!"
            }
        } else {
            showErrorMessage(errorTitle: "Word Not Valid", errorMessage: "You cannot use the word provided by the challenge. Please try a different one!")
            //errorTitle = "Word Not Possible!"
            //errorMessage = "You can't spell \(answer) from \(title!.lowercased())!"
        }
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var auxWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = auxWord.firstIndex(of: letter){
                auxWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
}
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isNotEqual(word: String) -> Bool {
        return title?.lowercased() != word.lowercased()
    }
    
    func isLargeEnough(word: String) -> Bool {
        return word.count >= 3
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell {
            cell.setupCell(name: usedWords[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row \(indexPath.row)")
    }
}

