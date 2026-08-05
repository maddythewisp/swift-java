//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2026 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

/// The insertion-ordered set operations required by the Swift/Java generators.
///
/// Keeping this narrow collection in the generator support target avoids a
/// network-resolved package dependency in build-tool plugin execution.
package struct OrderedSet<Element: Hashable>: RandomAccessCollection,
  ExpressibleByArrayLiteral
{
  package typealias Index = Int

  private var elements: [Element]
  private var membership: Set<Element>

  package init() {
    elements = []
    membership = []
  }

  package init<S: Sequence>(_ elements: S) where S.Element == Element {
    self.init()
    formUnion(elements)
  }

  package init(arrayLiteral elements: Element...) {
    self.init(elements)
  }

  package var startIndex: Int { elements.startIndex }
  package var endIndex: Int { elements.endIndex }

  package subscript(position: Int) -> Element { elements[position] }

  package mutating func reserveCapacity(_ minimumCapacity: Int) {
    elements.reserveCapacity(minimumCapacity)
    membership.reserveCapacity(minimumCapacity)
  }

  @discardableResult
  package mutating func append(_ element: Element) -> Bool {
    let inserted = membership.insert(element).inserted
    if inserted {
      elements.append(element)
    }
    return inserted
  }

  package mutating func formUnion<S: Sequence>(_ newElements: S)
  where S.Element == Element {
    for element in newElements {
      append(element)
    }
  }
}
