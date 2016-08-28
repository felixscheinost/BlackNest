//
//  BlackNestTests.swift
//  BlackNestTests
//
//  Created by Elmar Kretzer on 22.08.16.
//  Copyright © 2016 Elmar Kretzer. All rights reserved.
//

import XCTest
@testable import BlackNest


class BlackNestTests: XCTestCase {

  // --------------------------------------------------------------------------------
  // MARK: - Specs
  // --------------------------------------------------------------------------------

  func doubleTuple(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
    // Act:
    let subject = (input, input * 2)

    // Assert:
    try subject.0 == expect.0
      => "first entry should be the same"
    try subject.0 != expect.1
      => "first entry should not be euqal to second"
    try subject.1 == expect.1
      => "second entry should be duplicate"

    return subject
  }

  func tupleSum(input: (Int, Int), expect: (Int)) throws -> Int {
    // Act:
    let subject = input.0 + input.1

    // Assert:
    try subject == expect
      => "sum calculation"

    return subject
  }

  // --------------------------------------------------------------------------------
  // MARK: - Tests
  // --------------------------------------------------------------------------------

  func testPlain() {

    expect(004, in:doubleTuple, is:(04, 08))
    expect(008, in:doubleTuple, is:(08, 16))
    expect(012, in:doubleTuple, is:(12, 24))
    expect(100, in:doubleTuple, is:(100, 200))

    expect(004, in: doubleTuple => (04, 08))
    expect(008, in: doubleTuple => (08, 16))
    expect(012, in: doubleTuple => (12, 24))
    expect(100, in: doubleTuple => (100, 200))

    expect(004 | doubleTuple => (04, 08))
    expect(008 | doubleTuple => (08, 16))
    expect(012 | doubleTuple => (12, 24))
    expect(100 | doubleTuple => (100, 200))

    XCTAssertThrowsError(try (12 | doubleTuple => (13, 24)).breed()) { e in
        guard let _ = e as? BLNShellCrackError else {
          return XCTFail("BLNShellCrackError not coming")
        }
    }
  }

  func testChain() {

    expect(4, in:doubleTuple, is:(04, 08))
      .then(tupleSum, is:12)
    expect(8, in:doubleTuple, is:(08, 16))
      .then(tupleSum, is:24)
    expect(12, in:doubleTuple, is:(12, 24))
      .then(tupleSum, is:36)

    expect(004 | doubleTuple => (04, 08))
              .then(tupleSum => 12)
    expect(008 | doubleTuple => (08, 16))
              .then(tupleSum => 24)
    expect(012 | doubleTuple => (12, 24))
              .then(tupleSum => 36)
    expect(100 | doubleTuple => (100, 200))
              .then(tupleSum => 300)

    expect(4,
           in: doubleTuple ◦ tupleSum,
           is: (04, 08)    • 12
    )

    expect(4,
              in: doubleTuple ◦ tupleSum ◦ doubleTuple ◦ tupleSum ◦ doubleTuple,
              is: (04, 08)    • 12       • (12, 24)    • 36       • (36, 72)
    )

    expect(
      4 |  doubleTuple => (04, 08)
        |> tupleSum    => (12)
    )

    expect(
      4 |  doubleTuple => (04, 08)
        |> tupleSum    => (12)
        |> doubleTuple => (12, 24)
        |> tupleSum    => (36)
    )

    XCTAssertThrowsError(try (12 | doubleTuple => (13, 24)).breed()) { e in
      guard let _ = e as? BLNShellCrackError else {
        return XCTFail("BLNShellCrackError not coming")
      }
    }
  }

  // --------------------------------------------------------------------------------
  // MARK: - BirdWatcher
  // --------------------------------------------------------------------------------

  struct BirdWatcher {
    var name: String
    var experience: Int?
    var birdsSeen: Int?

    init(_ name: String) {
      self.name = name
    }

    var display: String {
      switch (experience, birdsSeen) {
      case let (y?, s?) where y > 10 && s > 100:
        return name + " - The Great Master."
      case let (y?, s?) where y > 5 && s > 50:
        return name + " - The Master."
      case let (y?, s?) where y < 1 && s < 1:
        return name + " - The Bloody Rookie."
      case let (y?, s?) where y < 5 && s < 5:
        return name + " - The Rookie."
      case let (y?, s?) where y < 1 && s > 10:
        return name + " - The Talent."
      default: return name
      }
    }
  }

  func testExample() {

    /// typealias for closure
    typealias ChangeBirdWatcher = @escaping (inout BirdWatcher) -> ()
    /// typealias for Expected Data Tuple
    typealias Data = (name: String, experience: Int?, birdsSeen: Int?, display: String)
    /// the function that returns our breeding function.
    func set(_ handler: ChangeBirdWatcher) -> (BirdWatcher, Data) throws -> BirdWatcher {
      return { input, expect in
        // Act:
        var subject = input
        handler(&subject)
        // Assert:
        try subject.name == expect.name
          => "name is correct"
        try subject.birdsSeen == expect.birdsSeen
          => "birdsSeen is correct"
        try subject.experience == expect.experience
          => "experience is correct"
        try subject.display == expect.display
          => "display is built correctly"

        return subject
      }
    }


    expect(
      BirdWatcher("Burt") |  set { $0.birdsSeen = 100 } => ("Burt", nil, 100, "Burt")
                          |> set { $0.experience = 20 } => ("Burt", 20, 100, "Burt - The Master.")
                          |> set { $0.experience = 0 }  => ("Burt", 0, 100, "Burt - The Talent.")
                          |> set { $0.birdsSeen = 0 }   => ("Burt", 0, 0, "Burt - The Bloody Rookie.")
    )

  }

}
