//
//  ConsolesManager.swift
//  MyGames
//
//  Created by William Tomaz on 10/06/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//

import CoreData

class ConsolesManager {
    static let shared = ConsolesManager()
    var consoles: [Console] = []
    
    func loadConsoles(with context: NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            consoles = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console) //excluiu do contexto
        do {
            try context.save()
            consoles.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private init() {
        
    }
}
