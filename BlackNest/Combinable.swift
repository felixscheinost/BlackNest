//
//  Combinable.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 31.08.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// --------------------------------------------------------------------------------
// MARK: - Combinable
// --------------------------------------------------------------------------------

public protocol IsPair {
  associatedtype L
  associatedtype R

  var left: L { get }
  var right: R { get }
}

// --------------------------------------------------------------------------------
// MARK: - A couple of anything
// --------------------------------------------------------------------------------

public struct Pair<A, B>: IsPair {
  public let left: A
  public let right: B
}

// --------------------------------------------------------------------------------
// MARK: - Combinators - multi line
// --------------------------------------------------------------------------------

public func |~ <I, E, O, L, R>(lhs: Spec<I, E, O>, rhs: Pair<L, R>)
  -> Pair<Spec<I, E, O>, Pair<L, R>> {
    return Pair(left: lhs, right: rhs)
}

public func |~ <I, E, O, F, P>(lhs: Spec<I, E, O>, rhs: RunWithExpected<O, F, P>)
  -> Pair<Spec<I, E, O>, RunWithExpected<O, F, P>> {
    return Pair(left: lhs, right: rhs)
}

public func |~ <I, E, O, L, R>(lhs: RunWithExpected<I, E, O>, rhs: Pair<L, R>)
  -> Pair<RunWithExpected<I, E, O>, Pair<L, R>> {
    return Pair(left: lhs, right: rhs)
}

public func |~ <I, E, O, F, P>(lhs: RunWithExpected<I, E, O>, rhs: RunWithExpected<O, F, P>)
  -> Pair<RunWithExpected<I, E, O>, RunWithExpected<O, F, P>> {
    return Pair(left: lhs, right: rhs)
}

// --------------------------------------------------------------------------------
// MARK: - Combinators - inline
// --------------------------------------------------------------------------------

public func ◦ <I, E, O, F, P>(lhs: @escaping RunFunction<I, E, O>, rhs: @escaping RunFunction<O, F, P>)
  -> Pair<Run<I, E, O>, Run<O, F, P>> {
    return Pair(left: Run(run: lhs), right: Run(run: rhs))
}

public func ◦ <I, E, O, L, R>(lhs: @escaping RunFunction<I, E, O>, rhs: Pair<L, R>)
  -> Pair<Run<I, E, O>, Pair<L, R>> {
    return Pair(left: Run(run: lhs), right: rhs)
}

public func • <L, R>(lhs: L, rhs: R) -> Pair<L, R> {
  return Pair(left: lhs, right: rhs)
}
