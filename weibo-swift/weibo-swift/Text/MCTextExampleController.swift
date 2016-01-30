//
//  MCTextExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCTextExampleController: UITableViewController {

    var titles = [String]()
    var classNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "丰富的text内容"
        
        self.addCell("Text Attributes 1", className: "MCTextAttributeExampleController")
        self.addCell("Text Attributes 2", className: "MCTextTagExampleController")
        self.addCell("Text Attachments", className: "MCTextAttachmentExampleController")
        self.addCell("Text Edit", className: "MCTextEditExampleController")
        self.addCell("Text Parser (Markdown)", className: "MCTextMarkdownExampleController")
        self.addCell("Text Parser (Emoticon)", className: "MCTextEmoticonExampleController")
        self.addCell("Text Binding", className: "MCTextBindingExampleController")
        self.addCell("Copy and Paste", className: "MCTextCopyPasteExampleController")
        self.addCell("Undo and Redo", className: "MCTextUndoRedoExampleController")
        self.addCell("Ruby Annotation", className: "MCTextRubyExampleController")
        self.addCell("Async Display", className: "MCTextAsyncExampleController")
        self.tableView.reloadData()
    }

    func addCell(title :String , className:String){
        self.titles.append(title)
        self.classNames.append(className)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    // MARK: - table view delegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("MC")
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MC")
        }
        cell?.textLabel?.text = self.titles[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let className :String = self.classNames[indexPath.row]
        if className == "MCTextAttributeExampleController"
        {
            let modelVc :MCTextAttributeExampleController = MCTextAttributeExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextTagExampleController"
        {
            let modelVc :MCTextTagExampleController = MCTextTagExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextAttachmentExampleController"
        {
            let modelVc :MCTextAttachmentExampleController = MCTextAttachmentExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextEditExampleController"
        {
            let modelVc :MCTextEditExampleController = MCTextEditExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextMarkdownExampleController"
        {
            let modelVc :MCTextMarkdownExampleController = MCTextMarkdownExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextEmoticonExampleController"
        {
            let modelVc :MCTextEmoticonExampleController = MCTextEmoticonExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextBindingExampleController"
        {
            let modelVc :MCTextBindingExampleController = MCTextBindingExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextCopyPasteExampleController"
        {
            let modelVc :MCTextCopyPasteExampleController = MCTextCopyPasteExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextUndoRedoExampleController"
        {
            let modelVc :MCTextUndoRedoExampleController = MCTextUndoRedoExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextRubyExampleController"
        {
            let modelVc :MCTextRubyExampleController = MCTextRubyExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextAsyncExampleController"
        {
            let modelVc :MCTextAsyncExampleController = MCTextAsyncExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
    }

}
