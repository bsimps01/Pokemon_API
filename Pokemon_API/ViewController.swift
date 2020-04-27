//
//  ViewController.swift
//  Pokemon_API
//
//  Created by Benjamin Simpson on 4/19/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pokemon: [Pokemon] = []
    let tableView = UITableView()
    var additionalViews: String? = nil
    var pokemonImage: String? = nil
    let url = "https://pokeapi.co/api/v2/pokemon/"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        fetchPokemon(url: "\(url)")
        tableSetUp()
        fetchHeaderData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath)
        cell.textLabel!.text = pokemon[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) {
        let pokemonURL = (pokemon[indexPath.row].url)
        configureImage(url: pokemonURL)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            fetchPokemon(url: "\(additionalViews!)")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        configureImage(url: pokemon[indexPath.row].url)
    }
    
    
    
    func tableSetUp(){
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "pokemonCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    
    func fetchHeaderData() {
        
        let defaultSeission = URLSession(configuration: .default)
        
        let url = URL(string: "https://httpbin.org/headers")
        
        let request = URLRequest(url: url!)
        
        let dataTask = defaultSeission.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            
            print("data is: ", data!)
            print("response is: ", response!)
        })
        dataTask.resume()
    }
    
    func fetchPokemon(url: String) {
        
        let defaultSession = URLSession(configuration: .default)
        
        if let url = URL(string: url) {
            
            let request = URLRequest(url: url)
            
            let dataTask = defaultSession.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
                
//                print("data is: ", data!)
//                print("response is: ", response!)
                
//                if let error = error {
//                    print("failed to fetch, error: ", error.localizedDescription)
//                    return
//                }
                
//                guard let data = data else {return}
                
                do {
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pokemon = try decoder.decode(List.self, from: data!)
                    print(pokemon)
                    self.pokemon.append(contentsOf: pokemon.results)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.additionalViews = pokemon.next!
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            })
            dataTask.resume()
        }
    }
        
    func configureImage(url: String) {
            let defaultSession = URLSession(configuration: .default)
                
            if let url = URL(string: url) {
                    
                let request = URLRequest(url: url)

                let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                        
                    do {
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let pokemonImage = try decoder.decode(PokemonImage.self, from: data!)
                        self.pokemonImage = pokemonImage.sprites.frontDefault
                        
                        DispatchQueue.main.async {
                            let pokemonView = ImageView()
                            pokemonView.imageURL = self.pokemonImage!
                            self.present(pokemonView, animated: true, completion: nil)
                        }
                    } catch  {
                         print("JSON error: \(error.localizedDescription)")
                    }
                    
                })
                dataTask.resume()
        }
    }
}
