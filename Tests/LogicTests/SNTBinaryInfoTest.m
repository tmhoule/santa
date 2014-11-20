/// Copyright 2014 Google Inc. All rights reserved.
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///    http://www.apache.org/licenses/LICENSE-2.0
///
///    Unless required by applicable law or agreed to in writing, software
///    distributed under the License is distributed on an "AS IS" BASIS,
///    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///    See the License for the specific language governing permissions and
///    limitations under the License.

#import <XCTest/XCTest.h>

#import "SNTBinaryInfo.h"

@interface SNTBinaryInfoTest : XCTestCase
@end

@implementation SNTBinaryInfoTest

- (void)testSHA1 {
  SNTBinaryInfo *sut = [[SNTBinaryInfo alloc] initWithPath:@"/sbin/launchd"];

  XCTAssertNotNil(sut.SHA1);
  XCTAssertEqual(sut.SHA1.length, 40);
}

- (void)testExecutable {
  SNTBinaryInfo *sut = [[SNTBinaryInfo alloc] initWithPath:@"/sbin/launchd"];

  XCTAssertTrue(sut.isMachO);
  XCTAssertTrue(sut.isExecutable);

  XCTAssertFalse(sut.isDylib);
  XCTAssertFalse(sut.isFat);
  XCTAssertFalse(sut.isKext);
  XCTAssertFalse(sut.isScript);
}

- (void)testKext {
  SNTBinaryInfo *sut =
      [[SNTBinaryInfo alloc] initWithPath:
          @"/System/Library/Extensions/AppleAPIC.kext/Contents/MacOS/AppleAPIC"];

  XCTAssertTrue(sut.isMachO);
  XCTAssertTrue(sut.isKext);

  XCTAssertFalse(sut.isDylib);
  XCTAssertFalse(sut.isExecutable);
  XCTAssertFalse(sut.isFat);
  XCTAssertFalse(sut.isScript);
}

- (void)testDylibs {
  SNTBinaryInfo *sut = [[SNTBinaryInfo alloc] initWithPath:@"/usr/lib/libsqlite3.dylib"];

  XCTAssertTrue(sut.isMachO);
  XCTAssertTrue(sut.isDylib);
  XCTAssertTrue(sut.isFat);

  XCTAssertFalse(sut.isKext);
  XCTAssertFalse(sut.isExecutable);
  XCTAssertFalse(sut.isScript);
}

- (void)testScript {
  SNTBinaryInfo *sut = [[SNTBinaryInfo alloc] initWithPath:@"/usr/bin/h2ph"];

  XCTAssertTrue(sut.isScript);

  XCTAssertFalse(sut.isDylib);
  XCTAssertFalse(sut.isExecutable);
  XCTAssertFalse(sut.isFat);
  XCTAssertFalse(sut.isKext);
  XCTAssertFalse(sut.isMachO);
}

- (void)testBundle {
  SNTBinaryInfo *sut =
      [[SNTBinaryInfo alloc] initWithPath:@"/Applications/Safari.app/Contents/MacOS/Safari"];

  XCTAssertNotNil([sut bundle]);

  XCTAssertEqualObjects([sut bundleIdentifier], @"com.apple.Safari");
  XCTAssertEqualObjects([sut bundleName], @"Safari");
  XCTAssertNotNil([sut bundleVersion]);
  XCTAssertNotNil([sut bundleShortVersionString]);
  XCTAssertEqualObjects([sut bundlePath], @"/Applications/Safari.app");
}

- (void)testEmbeddedInfoPlist {
  // csreq is installed on all machines with Xcode installed. If you're running these tests,
  // it should be available..
  SNTBinaryInfo *sut = [[SNTBinaryInfo alloc] initWithPath:@"/usr/bin/csreq"];

  XCTAssertNotNil([sut infoPlist]);
}

@end