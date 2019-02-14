//
//  Audio+CoreDataProperties.swift
//  final challenge
//
//  Created by Adi Sukarno Rachman on 11/02/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//
//

import Foundation
import CoreData


extension Audio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Audio> {
        return NSFetchRequest<Audio>(entityName: "Audio")
    }

    @NSManaged public var audio: NSData?
    @NSManaged public var date: NSDate?
    @NSManaged public var durasi: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var konten: String?
    @NSManaged public var titleRecording: String?
    @NSManaged public var wpm: Float
    @NSManaged public var urlAudio: URL
//    @NSManaged public var urlAudio: URL

}
