import SwiftUI

let BasicsCourse : [Page] = [welcome, compression, huffmanCoding, quiz, arPlayground]

enum PlaygroundViews {
    case welcomePlaygroundView
    case huffmanCoding
    case compression
    case quiz
}

enum CustomView {
    case eightBitsExample
    case unitsRight
    case huffman
}

let welcome = Page(
    id: "welcome",
    title: "Introduction",
    contentSubTitle: "Welcome",
    contentTitle: "Why and How do Computers Compress Text",
    titleImageName: "graduationcap.fill",
    playgroundView: .welcomePlaygroundView,
    elements: [
        PageText("This app introduces you to the working behind compression algorithms. Computers use 8 bits to store text (or, at least, English text), but why? Are there are more efficient methods available? Also, how can we optimize text storage to fit more text into less space?"),
        PageText("To make things easier, this course will only deal with English text.", topSpacing: false),
        PageTask("To apply what you have learned, each lesson challenges you to accomplish a task. Interact with the controls in the Playground view on the right to solve the tasks. For now, simply click the blue button.", topSpacing: true),
        PageHeadline("How is data stored?", topSpacing: true),
        PageText("When you put English text into your computer, it saves every character as 8 bits in the form of 1s and 0s. You can think of these 0s and 1s as on/off switches (or electrons going over a wire). An ipad like the one you're using stores trillions of such bits, and every time your device says that it is running out of storage, you are running against the same question Compute scientists have been trying to deal with for years \"Can we make it smaller?\"?"),
        PageDivider(topSpacing: true),
        PageHeadline("Why compression?", topSpacing: true),
        PageText("As mentioned earlier, computers normally use 8 bits to represent text. But as we know, data in the modern world is growing at exponential rate as we store every single thing on cloud. Wouldn't it be cool if you could somehow _reduce_ the amount of bits a character takes? That is where compression comes into play."),
    ]
)

let compression = Page(
    id: "compression",
    title: "Compression",
    contentSubTitle: "Fitting more into less",
    contentTitle: "Compression",
    titleImageName: "bolt.fill",
    playgroundView: .compression,
    elements: [
        PageText("On modern computers, each English character takes up exactly eight 1s and 0s on disk - 8 bits or one byte. Each of the 8 bits can be either 0 or 1, and so 1 byte can represent 2\u{2078} = 256 combinations or 256 possible characters."),
//        PageDivider(topSpacing: true),
        PageHeadline("Why eight bits?", topSpacing: true),
        PageText("Each byte is of 8 bits because it can represent all English characters, numbers, punctuations etc. but no bigger, so the text doesn't take up any more space than it absolutely has to."),
        PageCustomView(.eightBitsExample),
        PageText("It is also helpful to have a fixed number of bits per character, because it makes searching through text really fast. If we want to go to the 200th character in a text, we can just move to 200 × 8 units right, without having to count every single character before it.", topSpacing: true),
        PageCustomView(.unitsRight),
        PageText("If we want to find out how many characters are present, we just count the number of bits and divide by eight"),
        PageTask("But then how do we make a character smaller than eight bits?", isChallenge: false),
        PageText("This is where Huffan Coding comes into play. Huffman coding uses a Tree-like structure as you can see in the right. Continue to next lesson to learn more about them!")
    ]
)

let huffmanCoding = Page(
    id: "huffman_coding",
    title: "Huffman Coding",
    contentSubTitle: "Heart of Text Compression",
    contentTitle: "Huffman Coding and Huffman Trees",
    titleImageName: "scale.3d",
    playgroundView: .huffmanCoding,
    elements: [
        PageText("In 1952, a mathematician at MIT called David Huffman invented Huffman Coding. Today there are alot of better, more complicated and optimized algorithms for compressing text, but Huffman coding is the basic foundation of all these algorithms."),
        PageTask("Let's say we want to compress a placeholder that you are probably familiar – Hello world"),
        PageText("Uncompressed this is 11 characters, taking up 88 bits"),
        PageHeadline("How does it work?", topSpacing: true),
        PageText("First up, you count how many times each character is used and put that in a list in order"),
//        PageCustomView(.freqTable),
//        PageText("Then take the bottom 2 nodes. These are going to be the bottom branches on you \"Huffman tree\". Connect them together – one level up with the sum of their frequencies", topSpacing: true),
//        PageCustomView(.bottomBranches, topSpacing: true, bottomSpacing: true),
//        PageText("Now consider this to be a new node, and connect the branches from bottom up"),
//        PageCustomView(.moreBranches, topSpacing: true, bottomSpacing: true)
        PageCustomView(.huffman),
        PageTask("Try constructing your own tree by entering text in the playground!")
    ]
)

let quiz = Page(id: "quiz", title: "Final Quiz", contentSubTitle: "Final Quiz", contentTitle: "Test your knowledge", titleImageName: "brain.head.profile", playgroundView: .quiz, elements: [
    PageText("Congrats for making this far! You now understand how huffman coding works and is used as the base of most text based compression algorithms. There's one last challenge for you that will put to test what you have learned."),
    PageTask("Try out the quiz on the right and test your knowledge"),
    PageText("Thank you for taking your time out to try this app!")
])

let arPlayground = Page(id: "arplayground", title: "", contentSubTitle: "", contentTitle: "", titleImageName: "", playgroundView: .compression, elements: [])
