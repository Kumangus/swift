//===--- IntervalTraps.swift ----------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
// RUN: rm -rf %t
// RUN: mkdir -p %t
// RUN: %target-build-swift %s -o %t/a.out_Debug
// RUN: %target-build-swift %s -o %t/a.out_Release -O
//
// RUN: %target-run %t/a.out_Debug
// RUN: %target-run %t/a.out_Release
// REQUIRES: executable_test

import StdlibUnittest

let testSuiteSuffix = _isDebugAssertConfiguration() ? "_debug" : "_release"

var IntervalTraps = TestSuite("IntervalTraps" + testSuiteSuffix)

IntervalTraps.test("HalfOpen")
  .skip(.custom(
    { _isFastAssertConfiguration() },
    reason: "this trap is not guaranteed to happen in -Ounchecked"))
  .code {
  var interval = 1.0..<1.0
  // FIXME: the plan is for floating point numbers to no longer be
  // strideable; then this will drop the "OfStrideable"
  expectType(Range<Double>.self, &interval)
  expectCrashLater()
  _ = 1.0..<0.0
}

IntervalTraps.test("Closed")
  .skip(.custom(
    { _isFastAssertConfiguration() },
    reason: "this trap is not guaranteed to happen in -Ounchecked"))
  .code {
  var interval = 1.0...1.0
  // FIXME: the plan is for floating point numbers to no longer be
  // strideable; then this will drop the "OfStrideable"
  expectType(ClosedRange<Double>.self, &interval)

  expectCrashLater()
  _ = 1.0...0.0
}

runAllTests()

