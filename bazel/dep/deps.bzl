#  Copyright 2020 Google LLC
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def wasm_dependencies():
    _http_archive(
        name = "emscripten_toolchain",
        build_file = "@proxy_wasm_cpp_sdk//:emscripten-toolchain.BUILD",
        patch_cmds = [
            "./emsdk install 1.39.19-upstream",
            "./emsdk activate --embedded 1.39.19-upstream",
        ],
        strip_prefix = "emsdk-dec8a63594753fe5f4ad3b47850bf64d66c14a4e",
        url = "https://github.com/emscripten-core/emsdk/archive/dec8a63594753fe5f4ad3b47850bf64d66c14a4e.tar.gz",
    )

    # required by com_google_protobuf
    _http_archive(
        name = "bazel_skylib",
        sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        ],
    )

    _http_archive(
        name = "rules_proto",
        sha256 = "602e7161d9195e50246177e7c55b2f39950a9cf7366f74ed5f22fd45750cd208",
        strip_prefix = "rules_proto-97d8af4dc474595af3900dd85cb3a29ad28cc313",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
            "https://github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
        ],
    )

    _http_archive(
        name = "com_google_protobuf",
        sha256 = "59621f4011a95df270748dcc0ec1cc51946473f0e140d4848a2f20c8719e43aa",
        strip_prefix = "protobuf-655310ca192a6e3a050e0ca0b7084a2968072260",
        url = "https://github.com/protocolbuffers/protobuf/archive/655310ca192a6e3a050e0ca0b7084a2968072260.tar.gz",
    )

def _http_archive(name, **kwargs):
    existing_rule_keys = native.existing_rules().keys()
    if name in existing_rule_keys:
        # This repository has already been defined.
        return

    http_archive(
        name = name,
        **kwargs
    )
