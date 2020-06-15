//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by William Tomaz on 10/06/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//

import UIKit

class ConsolesTableViewController: UITableViewController {

    var label = UILabel()
    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsoles()
        
        label.text = "Você não possui consoles cadastrados"
        label.textAlignment = .center
    }

    
    @IBAction func addConsole(_ sender: UIBarButtonItem) {
        showAlert(with: nil)
        
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = consolesManager.consoles.count
        
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let console = consolesManager.consoles[indexPath.row]
        cell.textLabel?.text = console.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let console = consolesManager.consoles[indexPath.row]
        showAlert(with: console)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func showAlert(with console: Console?) {
        let title = console == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + "Plataforma", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Nome da plataforma"
            if let name = console?.name {
                textfield.text = name
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            let console = console ?? Console(context: self.context)
            console.name = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadConsoles()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alert.view.tintColor = UIColor(named: "SecondColor")
        present(alert, animated: true, completion: nil)
    }
    
    func loadConsoles() {
        consolesManager.loadConsoles(with: context)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            consolesManager.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
