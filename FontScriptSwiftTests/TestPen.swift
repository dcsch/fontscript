//
//  TestPen.swift
//  FontScriptSwiftTests
//
//  Created by David Schweinsberg on 7/11/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation
import FontScript

/// Generates an array of strings for each pen command
class TestPen: NSObject, Pen {
  var records = Array<String>()

  func move(to point: CGPoint) {
    records.append("moveTo (\(point.x), \(point.y))")
  }

  func line(to point: CGPoint) {
    records.append("lineTo (\(point.x), \(point.y))")
  }

  func curve(toPoints points: [NSValue]) {
    var str = "curveTo"
    for point in points {
      str += " (\(point.pointValue.x), \(point.pointValue.y))"
    }
    records.append(str)
  }

  func qCurve(toPoints points: [NSValue]) {
    var str = "qCurveTo"
    for point in points {
      str += " (\(point.pointValue.x), \(point.pointValue.y))"
    }
    records.append(str)
  }

  func closePath() {
    records.append("closePath")
  }

  func endPath() {
    records.append("endPath")
  }

  func addComponent(withName glyphName: String, transformation: CGAffineTransform, error: NSErrorPointer) {
    records.append("addComponent \(glyphName)")
  }

}
