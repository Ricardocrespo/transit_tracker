// Mocks generated by Mockito 5.4.6 from annotations
// in transit_tracker/test/services/cached_tile_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:convert' as _i10;
import 'dart:io' as _i5;
import 'dart:typed_data' as _i9;

import 'package:file/file.dart' as _i2;
import 'package:flutter_cache_manager/src/cache_managers/base_cache_manager.dart'
    as _i6;
import 'package:flutter_cache_manager/src/result/file_info.dart' as _i3;
import 'package:flutter_cache_manager/src/result/file_response.dart' as _i8;
import 'package:http/http.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i11;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFile_0 extends _i1.SmartFake implements _i2.File {
  _FakeFile_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeFileInfo_1 extends _i1.SmartFake implements _i3.FileInfo {
  _FakeFileInfo_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeResponse_2 extends _i1.SmartFake implements _i4.Response {
  _FakeResponse_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeStreamedResponse_3 extends _i1.SmartFake
    implements _i4.StreamedResponse {
  _FakeStreamedResponse_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeFileSystem_4 extends _i1.SmartFake implements _i2.FileSystem {
  _FakeFileSystem_4(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeDirectory_5 extends _i1.SmartFake implements _i2.Directory {
  _FakeDirectory_5(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeUri_6 extends _i1.SmartFake implements Uri {
  _FakeUri_6(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeFileSystemEntity_7 extends _i1.SmartFake
    implements _i2.FileSystemEntity {
  _FakeFileSystemEntity_7(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeFileStat_8 extends _i1.SmartFake implements _i5.FileStat {
  _FakeFileStat_8(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeDateTime_9 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_9(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeRandomAccessFile_10 extends _i1.SmartFake
    implements _i5.RandomAccessFile {
  _FakeRandomAccessFile_10(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeIOSink_11 extends _i1.SmartFake implements _i5.IOSink {
  _FakeIOSink_11(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [BaseCacheManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockBaseCacheManager extends _i1.Mock implements _i6.BaseCacheManager {
  MockBaseCacheManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i2.File> getSingleFile(
    String? url, {
    String? key,
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #getSingleFile,
              [url],
              {#key: key, #headers: headers},
            ),
            returnValue: _i7.Future<_i2.File>.value(
              _FakeFile_0(
                this,
                Invocation.method(
                  #getSingleFile,
                  [url],
                  {#key: key, #headers: headers},
                ),
              ),
            ),
          )
          as _i7.Future<_i2.File>);

  @override
  _i7.Stream<_i3.FileInfo> getFile(
    String? url, {
    String? key,
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#getFile, [url], {#key: key, #headers: headers}),
            returnValue: _i7.Stream<_i3.FileInfo>.empty(),
          )
          as _i7.Stream<_i3.FileInfo>);

  @override
  _i7.Stream<_i8.FileResponse> getFileStream(
    String? url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #getFileStream,
              [url],
              {#key: key, #headers: headers, #withProgress: withProgress},
            ),
            returnValue: _i7.Stream<_i8.FileResponse>.empty(),
          )
          as _i7.Stream<_i8.FileResponse>);

  @override
  _i7.Future<_i3.FileInfo> downloadFile(
    String? url, {
    String? key,
    Map<String, String>? authHeaders,
    bool? force = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #downloadFile,
              [url],
              {#key: key, #authHeaders: authHeaders, #force: force},
            ),
            returnValue: _i7.Future<_i3.FileInfo>.value(
              _FakeFileInfo_1(
                this,
                Invocation.method(
                  #downloadFile,
                  [url],
                  {#key: key, #authHeaders: authHeaders, #force: force},
                ),
              ),
            ),
          )
          as _i7.Future<_i3.FileInfo>);

  @override
  _i7.Future<_i3.FileInfo?> getFileFromCache(
    String? key, {
    bool? ignoreMemCache = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #getFileFromCache,
              [key],
              {#ignoreMemCache: ignoreMemCache},
            ),
            returnValue: _i7.Future<_i3.FileInfo?>.value(),
          )
          as _i7.Future<_i3.FileInfo?>);

  @override
  _i7.Future<_i3.FileInfo?> getFileFromMemory(String? key) =>
      (super.noSuchMethod(
            Invocation.method(#getFileFromMemory, [key]),
            returnValue: _i7.Future<_i3.FileInfo?>.value(),
          )
          as _i7.Future<_i3.FileInfo?>);

  @override
  _i7.Future<_i2.File> putFile(
    String? url,
    _i9.Uint8List? fileBytes, {
    String? key,
    String? eTag,
    Duration? maxAge = const Duration(days: 30),
    String? fileExtension = 'file',
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #putFile,
              [url, fileBytes],
              {
                #key: key,
                #eTag: eTag,
                #maxAge: maxAge,
                #fileExtension: fileExtension,
              },
            ),
            returnValue: _i7.Future<_i2.File>.value(
              _FakeFile_0(
                this,
                Invocation.method(
                  #putFile,
                  [url, fileBytes],
                  {
                    #key: key,
                    #eTag: eTag,
                    #maxAge: maxAge,
                    #fileExtension: fileExtension,
                  },
                ),
              ),
            ),
          )
          as _i7.Future<_i2.File>);

  @override
  _i7.Future<_i2.File> putFileStream(
    String? url,
    _i7.Stream<List<int>>? source, {
    String? key,
    String? eTag,
    Duration? maxAge = const Duration(days: 30),
    String? fileExtension = 'file',
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #putFileStream,
              [url, source],
              {
                #key: key,
                #eTag: eTag,
                #maxAge: maxAge,
                #fileExtension: fileExtension,
              },
            ),
            returnValue: _i7.Future<_i2.File>.value(
              _FakeFile_0(
                this,
                Invocation.method(
                  #putFileStream,
                  [url, source],
                  {
                    #key: key,
                    #eTag: eTag,
                    #maxAge: maxAge,
                    #fileExtension: fileExtension,
                  },
                ),
              ),
            ),
          )
          as _i7.Future<_i2.File>);

  @override
  _i7.Future<void> removeFile(String? key) =>
      (super.noSuchMethod(
            Invocation.method(#removeFile, [key]),
            returnValue: _i7.Future<void>.value(),
            returnValueForMissingStub: _i7.Future<void>.value(),
          )
          as _i7.Future<void>);

  @override
  _i7.Future<void> emptyCache() =>
      (super.noSuchMethod(
            Invocation.method(#emptyCache, []),
            returnValue: _i7.Future<void>.value(),
            returnValueForMissingStub: _i7.Future<void>.value(),
          )
          as _i7.Future<void>);

  @override
  _i7.Future<void> dispose() =>
      (super.noSuchMethod(
            Invocation.method(#dispose, []),
            returnValue: _i7.Future<void>.value(),
            returnValueForMissingStub: _i7.Future<void>.value(),
          )
          as _i7.Future<void>);
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockClient extends _i1.Mock implements _i4.Client {
  MockClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i4.Response> head(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
            Invocation.method(#head, [url], {#headers: headers}),
            returnValue: _i7.Future<_i4.Response>.value(
              _FakeResponse_2(
                this,
                Invocation.method(#head, [url], {#headers: headers}),
              ),
            ),
          )
          as _i7.Future<_i4.Response>);

  @override
  _i7.Future<_i4.Response> get(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
            Invocation.method(#get, [url], {#headers: headers}),
            returnValue: _i7.Future<_i4.Response>.value(
              _FakeResponse_2(
                this,
                Invocation.method(#get, [url], {#headers: headers}),
              ),
            ),
          )
          as _i7.Future<_i4.Response>);

  @override
  _i7.Future<_i4.Response> post(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i10.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #post,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i4.Response>.value(
              _FakeResponse_2(
                this,
                Invocation.method(
                  #post,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i4.Response>);

  @override
  _i7.Future<_i4.Response> put(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i10.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #put,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i4.Response>.value(
              _FakeResponse_2(
                this,
                Invocation.method(
                  #put,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i4.Response>);

  @override
  _i7.Future<_i4.Response> patch(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i10.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #patch,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i4.Response>.value(
              _FakeResponse_2(
                this,
                Invocation.method(
                  #patch,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i4.Response>);

  @override
  _i7.Future<_i4.Response> delete(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i10.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #delete,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i4.Response>.value(
              _FakeResponse_2(
                this,
                Invocation.method(
                  #delete,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i4.Response>);

  @override
  _i7.Future<String> read(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
            Invocation.method(#read, [url], {#headers: headers}),
            returnValue: _i7.Future<String>.value(
              _i11.dummyValue<String>(
                this,
                Invocation.method(#read, [url], {#headers: headers}),
              ),
            ),
          )
          as _i7.Future<String>);

  @override
  _i7.Future<_i9.Uint8List> readBytes(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#readBytes, [url], {#headers: headers}),
            returnValue: _i7.Future<_i9.Uint8List>.value(_i9.Uint8List(0)),
          )
          as _i7.Future<_i9.Uint8List>);

  @override
  _i7.Future<_i4.StreamedResponse> send(_i4.BaseRequest? request) =>
      (super.noSuchMethod(
            Invocation.method(#send, [request]),
            returnValue: _i7.Future<_i4.StreamedResponse>.value(
              _FakeStreamedResponse_3(
                this,
                Invocation.method(#send, [request]),
              ),
            ),
          )
          as _i7.Future<_i4.StreamedResponse>);

  @override
  void close() => super.noSuchMethod(
    Invocation.method(#close, []),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [File].
///
/// See the documentation for Mockito's code generation for more information.
class MockFile extends _i1.Mock implements _i2.File {
  MockFile(_i9.Uint8List uint8list) { // Uint8List parameter needed for testing – not generated by Mockito.
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.File get absolute =>
      (super.noSuchMethod(
            Invocation.getter(#absolute),
            returnValue: _FakeFile_0(this, Invocation.getter(#absolute)),
          )
          as _i2.File);

  @override
  _i2.FileSystem get fileSystem =>
      (super.noSuchMethod(
            Invocation.getter(#fileSystem),
            returnValue: _FakeFileSystem_4(
              this,
              Invocation.getter(#fileSystem),
            ),
          )
          as _i2.FileSystem);

  @override
  String get basename =>
      (super.noSuchMethod(
            Invocation.getter(#basename),
            returnValue: _i11.dummyValue<String>(
              this,
              Invocation.getter(#basename),
            ),
          )
          as String);

  @override
  String get dirname =>
      (super.noSuchMethod(
            Invocation.getter(#dirname),
            returnValue: _i11.dummyValue<String>(
              this,
              Invocation.getter(#dirname),
            ),
          )
          as String);

  @override
  _i2.Directory get parent =>
      (super.noSuchMethod(
            Invocation.getter(#parent),
            returnValue: _FakeDirectory_5(this, Invocation.getter(#parent)),
          )
          as _i2.Directory);

  @override
  String get path =>
      (super.noSuchMethod(
            Invocation.getter(#path),
            returnValue: _i11.dummyValue<String>(
              this,
              Invocation.getter(#path),
            ),
          )
          as String);

  @override
  Uri get uri =>
      (super.noSuchMethod(
            Invocation.getter(#uri),
            returnValue: _FakeUri_6(this, Invocation.getter(#uri)),
          )
          as Uri);

  @override
  bool get isAbsolute =>
      (super.noSuchMethod(Invocation.getter(#isAbsolute), returnValue: false)
          as bool);

  @override
  _i7.Future<_i2.File> create({
    bool? recursive = false,
    bool? exclusive = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#create, [], {
              #recursive: recursive,
              #exclusive: exclusive,
            }),
            returnValue: _i7.Future<_i2.File>.value(
              _FakeFile_0(
                this,
                Invocation.method(#create, [], {
                  #recursive: recursive,
                  #exclusive: exclusive,
                }),
              ),
            ),
          )
          as _i7.Future<_i2.File>);

  @override
  _i7.Future<_i2.File> rename(String? newPath) =>
      (super.noSuchMethod(
            Invocation.method(#rename, [newPath]),
            returnValue: _i7.Future<_i2.File>.value(
              _FakeFile_0(this, Invocation.method(#rename, [newPath])),
            ),
          )
          as _i7.Future<_i2.File>);

  @override
  _i2.File renameSync(String? newPath) =>
      (super.noSuchMethod(
            Invocation.method(#renameSync, [newPath]),
            returnValue: _FakeFile_0(
              this,
              Invocation.method(#renameSync, [newPath]),
            ),
          )
          as _i2.File);

  @override
  _i7.Future<_i2.File> copy(String? newPath) =>
      (super.noSuchMethod(
            Invocation.method(#copy, [newPath]),
            returnValue: _i7.Future<_i2.File>.value(
              _FakeFile_0(this, Invocation.method(#copy, [newPath])),
            ),
          )
          as _i7.Future<_i2.File>);

  @override
  _i2.File copySync(String? newPath) =>
      (super.noSuchMethod(
            Invocation.method(#copySync, [newPath]),
            returnValue: _FakeFile_0(
              this,
              Invocation.method(#copySync, [newPath]),
            ),
          )
          as _i2.File);

  @override
  _i7.Future<_i2.File> writeAsBytes(
    List<int>? bytes, {
    _i5.FileMode? mode = _i5.FileMode.write,
    bool? flush = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #writeAsBytes,
              [bytes],
              {#mode: mode, #flush: flush},
            ),
            returnValue: _i7.Future<_i2.File>.value(
              _FakeFile_0(
                this,
                Invocation.method(
                  #writeAsBytes,
                  [bytes],
                  {#mode: mode, #flush: flush},
                ),
              ),
            ),
          )
          as _i7.Future<_i2.File>);

  @override
  _i7.Future<_i2.File> writeAsString(
    String? contents, {
    _i5.FileMode? mode = _i5.FileMode.write,
    _i10.Encoding? encoding = const _i10.Utf8Codec(),
    bool? flush = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #writeAsString,
              [contents],
              {#mode: mode, #encoding: encoding, #flush: flush},
            ),
            returnValue: _i7.Future<_i2.File>.value(
              _FakeFile_0(
                this,
                Invocation.method(
                  #writeAsString,
                  [contents],
                  {#mode: mode, #encoding: encoding, #flush: flush},
                ),
              ),
            ),
          )
          as _i7.Future<_i2.File>);

  @override
  _i7.Future<_i2.FileSystemEntity> delete({bool? recursive = false}) =>
      (super.noSuchMethod(
            Invocation.method(#delete, [], {#recursive: recursive}),
            returnValue: _i7.Future<_i2.FileSystemEntity>.value(
              _FakeFileSystemEntity_7(
                this,
                Invocation.method(#delete, [], {#recursive: recursive}),
              ),
            ),
          )
          as _i7.Future<_i2.FileSystemEntity>);

  @override
  _i7.Future<bool> exists() =>
      (super.noSuchMethod(
            Invocation.method(#exists, []),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  bool existsSync() =>
      (super.noSuchMethod(
            Invocation.method(#existsSync, []),
            returnValue: false,
          )
          as bool);

  @override
  _i7.Future<String> resolveSymbolicLinks() =>
      (super.noSuchMethod(
            Invocation.method(#resolveSymbolicLinks, []),
            returnValue: _i7.Future<String>.value(
              _i11.dummyValue<String>(
                this,
                Invocation.method(#resolveSymbolicLinks, []),
              ),
            ),
          )
          as _i7.Future<String>);

  @override
  String resolveSymbolicLinksSync() =>
      (super.noSuchMethod(
            Invocation.method(#resolveSymbolicLinksSync, []),
            returnValue: _i11.dummyValue<String>(
              this,
              Invocation.method(#resolveSymbolicLinksSync, []),
            ),
          )
          as String);

  @override
  _i7.Future<_i5.FileStat> stat() =>
      (super.noSuchMethod(
            Invocation.method(#stat, []),
            returnValue: _i7.Future<_i5.FileStat>.value(
              _FakeFileStat_8(this, Invocation.method(#stat, [])),
            ),
          )
          as _i7.Future<_i5.FileStat>);

  @override
  _i5.FileStat statSync() =>
      (super.noSuchMethod(
            Invocation.method(#statSync, []),
            returnValue: _FakeFileStat_8(
              this,
              Invocation.method(#statSync, []),
            ),
          )
          as _i5.FileStat);

  @override
  void deleteSync({bool? recursive = false}) => super.noSuchMethod(
    Invocation.method(#deleteSync, [], {#recursive: recursive}),
    returnValueForMissingStub: null,
  );

  @override
  _i7.Stream<_i5.FileSystemEvent> watch({
    int? events = 15,
    bool? recursive = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#watch, [], {
              #events: events,
              #recursive: recursive,
            }),
            returnValue: _i7.Stream<_i5.FileSystemEvent>.empty(),
          )
          as _i7.Stream<_i5.FileSystemEvent>);

  @override
  void createSync({bool? recursive = false, bool? exclusive = false}) =>
      super.noSuchMethod(
        Invocation.method(#createSync, [], {
          #recursive: recursive,
          #exclusive: exclusive,
        }),
        returnValueForMissingStub: null,
      );

  @override
  _i7.Future<int> length() =>
      (super.noSuchMethod(
            Invocation.method(#length, []),
            returnValue: _i7.Future<int>.value(0),
          )
          as _i7.Future<int>);

  @override
  int lengthSync() =>
      (super.noSuchMethod(Invocation.method(#lengthSync, []), returnValue: 0)
          as int);

  @override
  _i7.Future<DateTime> lastAccessed() =>
      (super.noSuchMethod(
            Invocation.method(#lastAccessed, []),
            returnValue: _i7.Future<DateTime>.value(
              _FakeDateTime_9(this, Invocation.method(#lastAccessed, [])),
            ),
          )
          as _i7.Future<DateTime>);

  @override
  DateTime lastAccessedSync() =>
      (super.noSuchMethod(
            Invocation.method(#lastAccessedSync, []),
            returnValue: _FakeDateTime_9(
              this,
              Invocation.method(#lastAccessedSync, []),
            ),
          )
          as DateTime);

  @override
  _i7.Future<dynamic> setLastAccessed(DateTime? time) =>
      (super.noSuchMethod(
            Invocation.method(#setLastAccessed, [time]),
            returnValue: _i7.Future<dynamic>.value(),
          )
          as _i7.Future<dynamic>);

  @override
  void setLastAccessedSync(DateTime? time) => super.noSuchMethod(
    Invocation.method(#setLastAccessedSync, [time]),
    returnValueForMissingStub: null,
  );

  @override
  _i7.Future<DateTime> lastModified() =>
      (super.noSuchMethod(
            Invocation.method(#lastModified, []),
            returnValue: _i7.Future<DateTime>.value(
              _FakeDateTime_9(this, Invocation.method(#lastModified, [])),
            ),
          )
          as _i7.Future<DateTime>);

  @override
  DateTime lastModifiedSync() =>
      (super.noSuchMethod(
            Invocation.method(#lastModifiedSync, []),
            returnValue: _FakeDateTime_9(
              this,
              Invocation.method(#lastModifiedSync, []),
            ),
          )
          as DateTime);

  @override
  _i7.Future<dynamic> setLastModified(DateTime? time) =>
      (super.noSuchMethod(
            Invocation.method(#setLastModified, [time]),
            returnValue: _i7.Future<dynamic>.value(),
          )
          as _i7.Future<dynamic>);

  @override
  void setLastModifiedSync(DateTime? time) => super.noSuchMethod(
    Invocation.method(#setLastModifiedSync, [time]),
    returnValueForMissingStub: null,
  );

  @override
  _i7.Future<_i5.RandomAccessFile> open({
    _i5.FileMode? mode = _i5.FileMode.read,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#open, [], {#mode: mode}),
            returnValue: _i7.Future<_i5.RandomAccessFile>.value(
              _FakeRandomAccessFile_10(
                this,
                Invocation.method(#open, [], {#mode: mode}),
              ),
            ),
          )
          as _i7.Future<_i5.RandomAccessFile>);

  @override
  _i5.RandomAccessFile openSync({_i5.FileMode? mode = _i5.FileMode.read}) =>
      (super.noSuchMethod(
            Invocation.method(#openSync, [], {#mode: mode}),
            returnValue: _FakeRandomAccessFile_10(
              this,
              Invocation.method(#openSync, [], {#mode: mode}),
            ),
          )
          as _i5.RandomAccessFile);

  @override
  _i7.Stream<List<int>> openRead([int? start, int? end]) =>
      (super.noSuchMethod(
            Invocation.method(#openRead, [start, end]),
            returnValue: _i7.Stream<List<int>>.empty(),
          )
          as _i7.Stream<List<int>>);

  @override
  _i5.IOSink openWrite({
    _i5.FileMode? mode = _i5.FileMode.write,
    _i10.Encoding? encoding = const _i10.Utf8Codec(),
  }) =>
      (super.noSuchMethod(
            Invocation.method(#openWrite, [], {
              #mode: mode,
              #encoding: encoding,
            }),
            returnValue: _FakeIOSink_11(
              this,
              Invocation.method(#openWrite, [], {
                #mode: mode,
                #encoding: encoding,
              }),
            ),
          )
          as _i5.IOSink);

  @override
  _i7.Future<_i9.Uint8List> readAsBytes() =>
      (super.noSuchMethod(
            Invocation.method(#readAsBytes, []),
            returnValue: _i7.Future<_i9.Uint8List>.value(_i9.Uint8List(0)),
          )
          as _i7.Future<_i9.Uint8List>);

  @override
  _i9.Uint8List readAsBytesSync() =>
      (super.noSuchMethod(
            Invocation.method(#readAsBytesSync, []),
            returnValue: _i9.Uint8List(0),
          )
          as _i9.Uint8List);

  @override
  _i7.Future<String> readAsString({
    _i10.Encoding? encoding = const _i10.Utf8Codec(),
  }) =>
      (super.noSuchMethod(
            Invocation.method(#readAsString, [], {#encoding: encoding}),
            returnValue: _i7.Future<String>.value(
              _i11.dummyValue<String>(
                this,
                Invocation.method(#readAsString, [], {#encoding: encoding}),
              ),
            ),
          )
          as _i7.Future<String>);

  @override
  String readAsStringSync({_i10.Encoding? encoding = const _i10.Utf8Codec()}) =>
      (super.noSuchMethod(
            Invocation.method(#readAsStringSync, [], {#encoding: encoding}),
            returnValue: _i11.dummyValue<String>(
              this,
              Invocation.method(#readAsStringSync, [], {#encoding: encoding}),
            ),
          )
          as String);

  @override
  _i7.Future<List<String>> readAsLines({
    _i10.Encoding? encoding = const _i10.Utf8Codec(),
  }) =>
      (super.noSuchMethod(
            Invocation.method(#readAsLines, [], {#encoding: encoding}),
            returnValue: _i7.Future<List<String>>.value(<String>[]),
          )
          as _i7.Future<List<String>>);

  @override
  List<String> readAsLinesSync({
    _i10.Encoding? encoding = const _i10.Utf8Codec(),
  }) =>
      (super.noSuchMethod(
            Invocation.method(#readAsLinesSync, [], {#encoding: encoding}),
            returnValue: <String>[],
          )
          as List<String>);

  @override
  void writeAsBytesSync(
    List<int>? bytes, {
    _i5.FileMode? mode = _i5.FileMode.write,
    bool? flush = false,
  }) => super.noSuchMethod(
    Invocation.method(#writeAsBytesSync, [bytes], {#mode: mode, #flush: flush}),
    returnValueForMissingStub: null,
  );

  @override
  void writeAsStringSync(
    String? contents, {
    _i5.FileMode? mode = _i5.FileMode.write,
    _i10.Encoding? encoding = const _i10.Utf8Codec(),
    bool? flush = false,
  }) => super.noSuchMethod(
    Invocation.method(
      #writeAsStringSync,
      [contents],
      {#mode: mode, #encoding: encoding, #flush: flush},
    ),
    returnValueForMissingStub: null,
  );
}
