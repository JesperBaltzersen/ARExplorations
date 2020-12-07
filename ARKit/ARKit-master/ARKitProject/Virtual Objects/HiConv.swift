//
//  HiConv.swift
//  ARKitProject
//
//  Created by jbaltzersen on 04/12/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class HiConv: VirtualObject {

    override init() {
        super.init(modelName: "hiconv", fileExtension: "scn", thumbImageFilename: "vase", title: "hiconv")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
