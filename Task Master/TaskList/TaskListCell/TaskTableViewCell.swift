//
//  TaskTableViewCell.swift
//  Task Master
//
//  Created by Rahul Anand on 28/07/24.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class ImageLoader: ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    var imageLoader: ImageLoaderProtocol = ImageLoader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.taskImage.image = UIImage(named: "noImage")
    }
    
    func setTaskDetails(title: String, desc: String, taskImage: String) {
        self.taskTitle.text = title
        self.taskDescription.text = desc
//        if let url = URL(string: taskImage) {
//            self.imageLoader.loadImage(from: url)
//            { image in
//                DispatchQueue.main.async {
//                    self.taskImage.image = image
//                }
//            }
//        }
    }
    
}
