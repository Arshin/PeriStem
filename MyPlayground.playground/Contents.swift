//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var dic = [Dictionary<String, String>()]
dic.remove(at: 0)
print(dic.count)
dic.append(["name":"Song1","Guitar Stem":"Song 1 Guitar", "Drum Stem":"Song 1 Drum"])
dic.append(["name":"Song2","Guitar Stem":"Song 2 Guitar", "Drum Stem":"Song 2 Drum"])
print(dic[0])
for stem in dic[0]{
    print(stem.key)
}