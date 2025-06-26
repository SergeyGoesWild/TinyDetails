//
//  DataProvider.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 07/04/2025.
//

import Foundation

struct PaintingObject {
    let idPainting: UUID
    let paintingOffset: CGFloat
    let paintingFile: String
    let paintingTitle: String
    let painter: String
    let creationDate: String
    let endSubtitle: String
    let endDescription: String
    let areas: [ClickableArea]
}

struct ClickableArea {
    let idArea: UUID
    let hintText: String
    let pictureName: String
}

struct ResultObject {
    let id: UUID
    let title: String
    var wasClicked: Bool
}

final class DataProvider {
    
    static let shared = DataProvider()
    private init() { }
    
    let paintingList =
    [PaintingObject(idPainting: UUID(),
                    paintingOffset: 0,
                    paintingFile: "BlackSquare_origin",
                    paintingTitle: "Black Square",
                    painter: "Kazimir Malevich",
                    creationDate: "1915",
                    endSubtitle: "Level Complete!",
                    endDescription: "“Black Square” by Kazimir Malevich is a groundbreaking work of abstract art, created in 1915. Considered a cornerstone of the Suprematist movement, the painting features a stark black square on a white background, symbolizing a break from traditional representation and the beginning of pure artistic feeling. It challenges viewers to rethink the meaning of form, space, and the role of art itself.",
                    areas: [ClickableArea(idArea: UUID(),
                                          hintText: "the square",
                                          pictureName: "BlackSquare_square"),
                    ]),
     PaintingObject(idPainting: UUID(),
                    paintingOffset: 0,
                    paintingFile: "LadyWithAnErmine_origin",
                    paintingTitle: "Lady with an Ermine",
                    painter: "Leonardo da Vinci",
                    creationDate: "1489-1490",
                    endSubtitle: "Level Complete!",
                    endDescription: "“Lady with an Ermine” is a portrait by Leonardo da Vinci, painted around 1489–1490. It depicts Cecilia Gallerani, a young woman from the Milanese court, holding a white ermine. The painting is admired for its lifelike detail, elegance, and the subtle interaction between the lady and the animal, symbolizing purity and high status.",
                    areas: [ClickableArea(idArea: UUID(),
                                          hintText: "the lady",
                                          pictureName: "LadyWithAnErmine_lady"),
                            ClickableArea(idArea: UUID(),
                                          hintText: "the ermine",
                                          pictureName: "LadyWithAnErmine_ermine"),
                    ]),
     PaintingObject(idPainting: UUID(),
                    paintingOffset: 40,
                    paintingFile: "GaliziaStillLife_origin",
                    paintingTitle: "A Glass Compote with Peaches, Jasmine Flowers, Quinces and a Grasshopper",
                    painter: "Fede Galizia",
                    creationDate: "1607",
                    endSubtitle: "Level Complete!",
                    endDescription: "“A Glass Compote with Peaches, Jasmine Flowers, Quinces and a Grasshopper” is a beautifully rendered still life that stands among the first of its kind in Italian art. Galizia’s work is known for its sharp realism and meticulous detail, treating ordinary fruit with the same reverent attention as portrait subjects.",
                    areas: [ClickableArea(idArea: UUID(),
                                          hintText: "peaches",
                                          pictureName: "GaliziaStillLife_peaches"),
                            ClickableArea(idArea: UUID(),
                                          hintText: "pears",
                                          pictureName: "GaliziaStillLife_pears"),
                            ClickableArea(idArea: UUID(),
                                          hintText: "the grasshoper",
                                          pictureName: "GaliziaStillLife_hoper"),
                    ]),
     PaintingObject(idPainting: UUID(),
                    paintingOffset: -230,
                    paintingFile: "CreationOfAdam_origin",
                    paintingTitle: "The Creation of Adam",
                    painter: "Michelangelo",
                    creationDate: "circa 1511",
                    endSubtitle: "Level Complete!",
                    endDescription: "“The Creation of Adam” is a famous fresco by Michelangelo, painted around 1511 on the ceiling of the Sistine Chapel in Vatican City. It depicts the Biblical moment when God gives life to Adam, the first man, by reaching out to touch his hand. The nearly-touching fingers have become an iconic symbol of humanity and divine connection. The composition is celebrated for its powerful anatomy, dynamic forms, and deep spiritual meaning.",
                    areas: [ClickableArea(idArea: UUID(),
                                          hintText: "Adam",
                                          pictureName: "CreationOfAdam_adam"),
                            ClickableArea(idArea: UUID(),
                                          hintText: "God",
                                          pictureName: "CreationOfAdam_god"),
                            ClickableArea(idArea: UUID(),
                                          hintText: "Coalesence",
                                          pictureName: "CreationOfAdam_touch"),
                    ]),
//     PaintingObject(idPainting: UUID(),
//                    paintingOffset: -220,
//                    paintingFile: "StarryNight_origin",
//                    paintingTitle: "Звездная ночь",
//                    painter: "Vincent van Gogh",
//                    creationDate: "1889",
//                    endSubtitle: "Level Complete!",
//                    endDescription: "“The Starry Night” (1889) by Vincent van Gogh is one of the most iconic paintings in Western art. Created during his stay at a mental asylum in Saint-Rémy-de-Provence, the artwork depicts a swirling night sky above a quiet village, with exaggerated stars, a glowing moon, and a dramatic cypress tree reaching toward the heavens. The painting captures van Gogh’s emotional intensity through bold brushstrokes and vivid blues and yellows, conveying both turbulence and tranquility in a dreamlike landscape.",
//                    areas: [ClickableArea(idArea: UUID(),
//                                          hintText: "starry sky",
//                                          pictureName: "StarryNight_sky"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "the Moon",
//                                          pictureName: "StarryNight_moon"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "cypress tree",
//                                          pictureName: "StarryNight_tree"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "Saint-Rémy-de-Provence village",
//                                          pictureName: "StarryNight_village"),
//                    ]),
//     PaintingObject(idPainting: UUID(),
//                    paintingOffset: 170,
//                    paintingFile: "EchoAndNarcissus_origin",
//                    paintingTitle: "Echo and Narcissus",
//                    painter: "John William Waterhouse",
//                    creationDate: "1903",
//                    endSubtitle: "Level Complete!",
//                    endDescription: "“Echo and Narcissus” (1903) by John William Waterhouse depicts the tragic moment from Greek mythology where the nymph Echo, heartbroken and fading, watches the beautiful Narcissus, who is entranced by his own reflection in a pool of water. Set in a lush, melancholic landscape, the painting captures the contrast between Echo’s silent longing and Narcissus’s self-obsession, emphasizing themes of unrequited love, vanity, and fate.",
//                    areas: [ClickableArea(idArea: UUID(),
//                                          hintText: "Narcissus",
//                                          pictureName: "EchoAndNarcissus_narcissus"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "second Narcissus",
//                                          pictureName: "EchoAndNarcissus_narcissusReflection"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "Echo",
//                                          pictureName: "EchoAndNarcissus_echo"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "narcissi",
//                                          pictureName: "EchoAndNarcissus_narcissi"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "Narcissus' arrows",
//                                          pictureName: "EchoAndNarcissus_arrows"),
//                    ]),
//     PaintingObject(idPainting: UUID(),
//                    paintingOffset: -230,
//                    paintingFile: "Harvesters_origin",
//                    paintingTitle: "The Harvesters",
//                    painter: "Pieter Bruegel the Elder",
//                    creationDate: "1565",
//                    endSubtitle: "Level Complete!",
//                    endDescription: "“The Harvesters” by Pieter Bruegel the Elder is a vibrant and detailed portrayal of rural life during harvest season. Set in the golden fields of late summer, the painting shows peasants cutting wheat, resting under trees, and eating together. With its focus on everyday labor and human activity, the work is both a celebration of agricultural life and a rich social commentary of 16th-century Flanders.",
//                    areas: [ClickableArea(idArea: UUID(),
//                                          hintText: "the farmers",
//                                          pictureName: "Harvesters_group"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "the sleeper",
//                                          pictureName: "Harvesters_sleeper"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "the thirsty",
//                                          pictureName: "Harvesters_thirsty"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "hidden jug",
//                                          pictureName: "Harvesters_jug"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "cubic cart",
//                                          pictureName: "Harvesters_cart"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "church",
//                                          pictureName: "Harvesters_church"),
//                    ]),
//     PaintingObject(idPainting: UUID(),
//                    paintingOffset: -40,
//                    paintingFile: "MyWifeLovers_origin",
//                    paintingTitle: "My Wife’s Lovers",
//                    painter: "Carl Kahler",
//                    creationDate: "1891",
//                    endSubtitle: "Level Complete!",
//                    endDescription: "“My Wife’s Lovers” by Austrian artist Carl Kahler is a lavish and humorous painting depicting over 40 of a wealthy woman’s beloved Persian and Angora cats. Commissioned by San Francisco socialite Kate Birdsall Johnson, the work showcases the cats in regal poses and luxurious surroundings, blending realism with playful charm. Often dubbed “the world’s greatest painting of cats,” it celebrates opulence, eccentricity, and deep affection for pets.",
//                    areas: [ClickableArea(idArea: UUID(),
//                                          hintText: "the central cat",
//                                          pictureName: "MyWifeLovers_centralCat"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "the shadow cat",
//                                          pictureName: "MyWifeLovers_blackCat"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "the red proud cat",
//                                          pictureName: "MyWifeLovers_redCat"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "a moth",
//                                          pictureName: "MyWifeLovers_moth"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "the brat cat",
//                                          pictureName: "MyWifeLovers_bratCat"),
//                            ClickableArea(idArea: UUID(),
//                                          hintText: "the stuck cat",
//                                          pictureName: "MyWifeLovers_stuckCat"),
//                    ]),
    ]
}
