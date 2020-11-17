# WebAssembly for Proxies (C++ SDK)

[![Build Status][build-badge]][build-link]
[![Apache 2.0 License][license-badge]][license-link]

The SDK uses [bazel](https://bazel.build/) for its build. 

## Docker

A Dockerfile for the C++ SDK is provided in Dockerfile-sdk.

It can built in this directory by:

```
docker build -t wasmsdk -f Dockerfile-sdk .
```

The docker image can be used for compiling wasm files.

### Creating a project for use with the Docker build image

Create a directory with your WORKSPACE file, source files, and BUILD files:

WORKSPACE file (WORKSPACE):

```
workspace(name = "my_extension")

local_repository(
    name = "proxy_wasm_cpp_sdk",
    path = "/home/bianpengyuan_google_com/workspace/proxy-wasm-cpp-sdk",
)

load("@proxy_wasm_cpp_sdk//bazel/dep:deps.bzl", "wasm_dependencies")

wasm_dependencies()

load("@proxy_wasm_cpp_sdk//bazel/dep:deps_extra.bzl", "wasm_dependencies_extra")

wasm_dependencies_extra()
```

Source file (myproject.cc):

```
#include <string>
#include <unordered_map>

#include "proxy_wasm_intrinsics.h"

class ExampleContext : public Context {
public:
  explicit ExampleContext(uint32_t id, RootContext* root) : Context(id, root) {}

  FilterHeadersStatus onRequestHeaders(uint32_t headers, bool end_of_stream) override;
  void onDone() override;
};
static RegisterContextFactory register_ExampleContext(CONTEXT_FACTORY(ExampleContext));

FilterHeadersStatus ExampleContext::onRequestHeaders(uint32_t headers, bool end_of_stream) {
  logInfo(std::string("onRequestHeaders ") + std::to_string(id()));
  auto path = getRequestHeader(":path");
  logInfo(std::string("header path ") + std::string(path->view()));
  return FilterHeadersStatus::Continue;
}

void ExampleContext::onDone() { logInfo("onDone " + std::to_string(id())); }
```

BUILD file (BUILD):

```
load("@proxy_wasm_cpp_sdk//bazel/wasm:wasm.bzl", "wasm_cc_binary")

wasm_cc_binary(
    name = "my_extension.wasm",
    srcs = [
        "source.cc",
    ],
    deps = [
        "@proxy_wasm_cpp_sdk//:proxy_wasm_intrinsics",
    ],
)
```

### Compiling with the Docker build image

Run docker:

```bash
docker run -v $PWD:/work -w /work wasmsdk bazel build //...
```

[build-badge]: https://github.com/proxy-wasm/proxy-wasm-cpp-sdk/workflows/C++/badge.svg?branch=master
[build-link]: https://github.com/proxy-wasm/proxy-wasm-cpp-sdk/actions?query=workflow%3AC%2B%2B+branch%3Amaster
[license-badge]: https://img.shields.io/github/license/proxy-wasm/proxy-wasm-cpp-sdk
[license-link]: https://github.com/proxy-wasm/proxy-wasm-cpp-sdk/blob/master/LICENSE
