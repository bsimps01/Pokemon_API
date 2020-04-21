//
//  ImageView.swift
//  Pokemon_API
//
//  Created by Benjamin Simpson on 4/20/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import UIKit

class ImageView: UIViewController {
    
    var imageURL : String? = nil
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        fetchPokemonImage(url: imageURL!)
        viewImage()
    }
    
    func viewImage(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        ])
    }
    
    func fetchPokemonImage(url: String) {
        
        let defaultSession = URLSession(configuration: .default)
        if let url = URL(string: url) {
            
            let request = URLRequest(url: url)
    
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                         
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    
}
