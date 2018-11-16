//
//  ViewController.swift
//  cuentame_ios
//
//  Created by Mac on 10/22/18.
//  Copyright © 2018 UDB. All rights reserved.
//

import UIKit
import SwiftyJSON

import Alomafire
import SDWebImage
import AVFoundation

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var storyColection: UITableView!
    var storyList :[Sections] = [Sections]()
    let cellIdentifier:String = "showStoryCell"
     var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storyColection.dataSource = self
        self.storyColection.delegate = self
        

        self.refresh()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for:UIControl.Event.valueChanged)
        storyColection.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refresh(){
        print("Refresh content")

        Alamofire.request("https://gitlab.com/snippets/1753442/raw").responseJSON{
            response in
            switch response.result{
            case .success:
                self.parse(data:JSON(response.data))
        
            case .failure(let error):
                print(error)
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    func parse(data:JSON){
        
        //print(data)
        
        self.storyList.removeAll()
        for item in data.arrayValue{
            
            var story:Section = Sections()
            story.title = item["title"].string!
            story.image = item["image"].string!
            
            self.storyList.append(story)
            
            print(story.title!)
        }
        
        self.storyColection.reloadData()
        self.refreshControl.endRefreshing()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! StoryCell
        cell.title.text = self.storyList[indexPath.item].title;
        let image = "https://www.pequeocio.com/wp-content/uploads/2009/05/el-patito-feo-1-600x423.jpg" + self.storyList[indexPath.item].image!
        print(cell.title.text!)
        cell.cellImage.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named: "emoji.png"))
        return cell;
    }
    
    
}

