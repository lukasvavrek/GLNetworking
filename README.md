# GLNetworking

> GLNetworking is implementation of a concept of a high-level networking library wrapper for HTTP communication.

It's goal is to simplify application-level code for communication with a server and automate some general tasks.

## Installing / Getting started

In order to run an example application from XCode, you need to install it's dependencies with `pod install` command.

### Initial Configuration

All required settings for example application are already set up.
If you want to test example application with your own URLs, you can change them in URLConstants.swift file.

## Features

GLNetworking is written as a wrapper around URLSession API.

It's goal is to provide a simple way for client application
to implement communication with an application server through
the HTTP protocol.

It provides following features:

* Real-time network connectivity and server accessibility tracking
* Silent handling of the authentication requests
* Automation of response handling based on HTTP status codes

## Contributing

**Contributions are welcome!**

Some examples could be:

* adding new features
* invoking best practices for Swift / iOS
* code refactoring

But feel free to come up with anything that will cross your mind :)

## Licensing

The code in this project is licensed under MIT license.

---

Copyright (c) 2018 Lukas Vavrek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
