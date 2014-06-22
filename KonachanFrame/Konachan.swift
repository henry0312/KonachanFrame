/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Tsukasa ŌMOTO <henry0312@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/* This file is available under an MIT license. */

import Foundation

class Konachan {

    let url: NSURL
    let req: NSURLRequest
    var fileUrl: String?
    var fileSize: Int?
    var jpegUrl: String?
    var jpegHeight: Int?
    var jpegWidth: Int?
    var md5: String?

    init() {
        url = NSURL.URLWithString("http://konachan.net/post.json?limit=1&tags=order%3Arandom")
        req = NSURLRequest(URL: url)
    }

    init(URLString: String) {
        self.url = NSURL.URLWithString(URLString)
        self.req = NSURLRequest(URL: self.url)
    }

    func fetch() {
        var error: NSError?
        if let data = NSURLConnection.sendSynchronousRequest(req, returningResponse: nil, error: &error) {
            let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSArray
            if error {
                // TODO: error handling
                println(error)
            }
            if let item = json[0] as? NSDictionary {
                self.fileUrl    = item.objectForKey("file_url") as? String
                self.fileSize   = item.objectForKey("file_size") as? Int
                self.jpegUrl    = item.objectForKey("jpeg_url") as? String
                self.jpegHeight = item.objectForKey("jpeg_height") as? Int
                self.jpegWidth  = item.objectForKey("jpeg_width") as? Int
                self.md5        = item.objectForKey("md5") as? String
            }
        } else {
            // TODO: error handling
            println(error)
        }
    }
}
