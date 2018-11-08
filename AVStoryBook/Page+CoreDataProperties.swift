//
//  Page+CoreDataProperties.swift
//  AVStoryBook
//
//  Created by minami on 2018-11-08.
//  Copyright © 2018 宗像三奈美. All rights reserved.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var audio: NSData?
    @NSManaged public var image: NSData?

}
