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
    let tutorialData: TutorialData?
    
    init(idPainting: UUID,
         paintingOffset: CGFloat,
         paintingFile: String,
         paintingTitle: String,
         painter: String,
         creationDate: String,
         endSubtitle: String,
         endDescription: String,
         areas: [ClickableArea],
         tutorialData: TutorialData? = nil) {
        self.idPainting = idPainting
        self.paintingOffset = paintingOffset
        self.paintingFile = paintingFile
        self.paintingTitle = paintingTitle
        self.painter = painter
        self.creationDate = creationDate
        self.endSubtitle = endSubtitle
        self.endDescription = endDescription
        self.areas = areas
        self.tutorialData = tutorialData
    }
}

struct ClickableArea {
    let idArea: UUID
    let hintText: String
    let pictureName: String
    let avatarName: String
}

struct TutorialData {
    let title: String
    let explainerText: String
    let iconName: String
}

final class DataProvider {
    
    static let shared = DataProvider()
    private init() { }
    
    let paintingList =
    [
        //        PaintingObject(idPainting: UUID(),
        //                    paintingOffset: 0,
        //                    paintingFile: "BlackSquare_origin",
        //                    paintingTitle: "Black Square",
        //                    painter: "Kazimir Malevich",
        //                    creationDate: "1915",
        //                    endSubtitle: "Victory, fair and square! 🔳",
        //                    endDescription: "“Black Square” (1915) by Kazimir Malevich is a groundbreaking work of abstract art.\n\nConsidered a cornerstone of the Suprematist movement, the painting features a black square on a white background, symbolizing a break from traditional representation and the beginning of pure artistic feeling.\n\nMore than a painting, it stands as a visual manifesto of radical artistic change.",
        //                    areas: [ClickableArea(idArea: UUID(),
        //                                          hintText: "the square",
        //                                          pictureName: "BlackSquare_square",
        //                                          avatarName: "BlackSquare_square_av"),
        //                    ]),
        PaintingObject(idPainting: UUID(),
                       paintingOffset: -0.01,
                       paintingFile: "LadyWithAnErmine_origin",
                       paintingTitle: "Lady with an Ermine",
                       painter: "Leonardo da Vinci",
                       creationDate: "1489-1490",
                       endSubtitle: "Courtly Triumph! 👑",
                       endDescription: "“Lady with an Ermine” (1489) is a portrait by Leonardo da Vinci.\n\nThe lady is Cecilia Gallerani, a young woman from the court of Milan, known for her wit and education. The white ermine she is holding is a symbol of purity, grace, and noble status.\n\nThe painting is admired for its realistic detail and the quiet connection between the lady and the animal.",
                       areas: [ClickableArea(idArea: UUID(),
                                             hintText: "the lady",
                                             pictureName: "LadyWithAnErmine_lady",
                                             avatarName: "LadyWithAnErmine_lady_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "the ermine",
                                             pictureName: "LadyWithAnErmine_ermine",
                                             avatarName: "LadyWithAnErmine_ermine_av"),
                       ]),
        PaintingObject(idPainting: UUID(),
                       paintingOffset: -0.2,
                       paintingFile: "CompositionRedBlueYellow_origin",
                       paintingTitle: "Composition with Red, Blue and Yellow",
                       painter: "Piet Mondrian",
                       creationDate: "1930",
                       endSubtitle: "Victory, fair and square! 🟥",
                       endDescription: "“Composition with Red, Blue and Yellow” (1930) by Piet Mondrian is a striking example of De Stijl abstraction.\n\nA bold red rectangle dominates the upper right quadrant, anchoring the composition. Below, a deep blue square sits calmly in the lower left, offering contrast. A bright yellow block occupies the bottom right corner, injecting vibrancy and light. Black lines of varying thickness delineate the shapes, creating a rhythmic grid that suggests harmony through asymmetry.",
                       areas: [ClickableArea(idArea: UUID(),
                                             hintText: "red block",
                                             pictureName: "CompositionRedBlueYellow_red",
                                             avatarName: "CompositionRedBlueYellow_red_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "blue block",
                                             pictureName: "CompositionRedBlueYellow_blue",
                                             avatarName: "CompositionRedBlueYellow_blue_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "yellow block",
                                             pictureName: "CompositionRedBlueYellow_yellow",
                                             avatarName: "CompositionRedBlueYellow_yellow_av"),
                       ],
                      tutorialData: TutorialData(title: "Hint:", explainerText: "Drag left or right to scroll", iconName: "hand.draw")),
        PaintingObject(idPainting: UUID(),
                       paintingOffset: 0.03,
                       paintingFile: "GaliziaStillLife_origin",
                       paintingTitle: "A Glass Compote with Peaches, Jasmine Flowers, Quinces and a Grasshopper",
                       painter: "Fede Galizia",
                       creationDate: "1607",
                       endSubtitle: "Sweet Success! 🍊",
                       endDescription: "“A Glass Compote with Peaches, Jasmine Flowers, Quinces and a Grasshopper” (1607) is a still life by Fede Galizia, considered one of the earliest examples of the genre in Italian painting.\n\nThe painting features peaches with soft textures, fragrant jasmine flowers, and golden quinces arranged with care. A small grasshopper sits quietly nearby, adding a touch of life and surprise.\n\nKnown for her precision and realism, Galizia treats each object with great attention, turning everyday items into something elegant and timeless.",
                       areas: [ClickableArea(idArea: UUID(),
                                             hintText: "peaches",
                                             pictureName: "GaliziaStillLife_peaches",
                                             avatarName: "GaliziaStillLife_peaches_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "pears",
                                             pictureName: "GaliziaStillLife_pears",
                                             avatarName: "GaliziaStillLife_pears_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "the grasshopper",
                                             pictureName: "GaliziaStillLife_hoper",
                                             avatarName: "GaliziaStillLife_hoper_av"),
                       ],
                       tutorialData: TutorialData(title: "Hint:", explainerText: "You can pinch to zoom", iconName: "hand.pinch")),
        PaintingObject(idPainting: UUID(),
                       paintingOffset: -0.12,
                       paintingFile: "CreationOfAdam_origin",
                       paintingTitle: "The Creation of Adam",
                       painter: "Michelangelo",
                       creationDate: "circa 1511",
                       endSubtitle: "Divine Victory! ✨",
                       endDescription: "“The Creation of Adam” (1511) is a fresco by Michelangelo, painted on the ceiling of the Sistine Chapel in Vatican City.\n\nIt shows the moment from the Bible when God reaches out to give life to Adam, the first man. Adam is shown relaxed but expectant, while God, surrounded by angels, stretches forward with energy and intent. At the center, their hands nearly touch — a powerful space symbolizing the connection between humanity and the divine.",
                       areas: [ClickableArea(idArea: UUID(),
                                             hintText: "Adam",
                                             pictureName: "CreationOfAdam_adam",
                                             avatarName: "CreationOfAdam_adam_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "God",
                                             pictureName: "CreationOfAdam_god",
                                             avatarName: "CreationOfAdam_god_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "the life spark",
                                             pictureName: "CreationOfAdam_touch",
                                             avatarName: "CreationOfAdam_touch_av"),
                       ]),
        PaintingObject(idPainting: UUID(),
                       paintingOffset: -0.2,
                       paintingFile: "StarryNight_origin",
                       paintingTitle: "Звездная ночь",
                       painter: "Vincent van Gogh",
                       creationDate: "1889",
                       endSubtitle: "You are a star! 🌠",
                       endDescription: "“The Starry Night” (1889) is a painting by Vincent van Gogh, during his time in Saint-Paul-de-Mausole asylum.\n\nIt shows a vivid night sky filled with swirling stars and a bright crescent moon, painted with bold, expressive strokes. A large cypress tree that rises in the foreground is typical of southern France. Below, a quiet village rests. In fact, the church steeple in the painting resembles architecture more common in the Netherlands (where van Gogh was from), not Provence. So the village is more symbolic than accurate — it represents a peaceful town beneath a turbulent sky, rather than a real place he saw.",
                       areas: [
                        ClickableArea(idArea: UUID(),
                                      hintText: "starry sky",
                                      pictureName: "StarryNight_sky",
                                      avatarName: "StarryNight_sky_av"),
                        ClickableArea(idArea: UUID(),
                                      hintText: "the Moon",
                                      pictureName: "StarryNight_moon",
                                      avatarName: "StarryNight_moon_av"),
                        ClickableArea(idArea: UUID(),
                                      hintText: "cypress tree",
                                      pictureName: "StarryNight_tree",
                                      avatarName: "StarryNight_tree_av"),
                        ClickableArea(idArea: UUID(),
                                      hintText: "Saint-Rémy-de-Provence",
                                      pictureName: "StarryNight_village",
                                      avatarName: "StarryNight_village_av"),
                       ]),
        PaintingObject(idPainting: UUID(),
                       paintingOffset: 0.14,
                       paintingFile: "EchoAndNarcissus_origin",
                       paintingTitle: "Echo and Narcissus",
                       painter: "John William Waterhouse",
                       creationDate: "1903",
                       endSubtitle: "Victory at First Reflection! 🌼",
                       endDescription: "“Echo and Narcissus” (1903) is a painting by John William Waterhouse.\n\nIt illustrates a moment from Greek mythology, where the nymph Echo sits quietly in the background, watching Narcissus mesmerized by his own reflection in the still water. Echo, pale and fading, symbolizes unrequited love and sorrow. Around them grow delicate white narcissi flowers, a reference to the myth and to Narcissus’s eventual transformation. On the left side of the scene, a set of arrows lies abandoned on the ground, hinting at past action and now-forgotten pursuits.\n\nThe arrows are a subtle visual metaphor: symbols of movement and life, now idle and useless, much like Echo herself, who has also been reduced to a shadow of what she once was.",
                       areas: [ClickableArea(idArea: UUID(),
                                             hintText: "Narcissus",
                                             pictureName: "EchoAndNarcissus_narcissus",
                                             avatarName: "EchoAndNarcissus_narcissus_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "second Narcissus",
                                             pictureName: "EchoAndNarcissus_narcissusReflection",
                                             avatarName: "EchoAndNarcissus_narcissusReflection_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "Echo",
                                             pictureName: "EchoAndNarcissus_echo",
                                             avatarName: "EchoAndNarcissus_echo_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "narcissi",
                                             pictureName: "EchoAndNarcissus_narcissi",
                                             avatarName: "EchoAndNarcissus_narcissi_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "Narcissus' arrows",
                                             pictureName: "EchoAndNarcissus_arrows",
                                             avatarName: "EchoAndNarcissus_arrows_av"),
                       ]),
        PaintingObject(idPainting: UUID(),
                       paintingOffset: -0.2,
                       paintingFile: "Harvesters_origin",
                       paintingTitle: "The Harvesters",
                       painter: "Pieter Bruegel the Elder",
                       creationDate: "1565",
                       endSubtitle: "Victory harvested! 🌾",
                       endDescription: "“The Harvesters” (1565) is a painting by Pieter Bruegel the Elder.\n\nIt captures a busy harvest scene in the countryside. In the foreground, a group of farmers sit down for a meal. Nearby, one peasant naps under a tree, while another lifts a jug to drink — a reminder of the need for rest and refreshment during a long workday. A large cart filled with hay stands off to the side, ready to carry the gathered crop. A small jug is partly hidden in the grass, a quiet detail that adds to the painting’s realism. In the far background, a church rises gently above the trees, anchoring the scene in a broader social and spiritual landscape.",
                       areas: [ClickableArea(idArea: UUID(),
                                             hintText: "the group",
                                             pictureName: "Harvesters_group",
                                             avatarName: "Harvesters_group_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "the sleeper",
                                             pictureName: "Harvesters_sleeper",
                                             avatarName: "Harvesters_sleeper_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "the thirsty",
                                             pictureName: "Harvesters_thirsty",
                                             avatarName: "Harvesters_thirsty_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "hidden jug",
                                             pictureName: "Harvesters_jug",
                                             avatarName: "Harvesters_jug_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "cubic cart",
                                             pictureName: "Harvesters_cart",
                                             avatarName: "Harvesters_cart_av"),
                               ClickableArea(idArea: UUID(),
                                             hintText: "church",
                                             pictureName: "Harvesters_church",
                                             avatarName: "Harvesters_church_av"),
                       ]),
        PaintingObject(idPainting: UUID(),
                       paintingOffset: -0.04,
                       paintingFile: "MyWifeLovers_origin",
                       paintingTitle: "My Wife’s Lovers",
                       painter: "Carl Kahler",
                       creationDate: "1891",
                       endSubtitle: "Purrfect victory! 🐈",
                       endDescription: "“My Wife’s Lovers” (1891) is a painting by Carl Kahler. It features over forty cats — mostly Persians and Angoras.\n\nAt the center sits a majestic white cat with a full mane, looking directly at the viewer like a ruler holding court. To one side, a sleek black cat watches from the shadows, adding elegance and contrast, while a bold red tabby stands alert in the foreground. The moth is a small, but clever detail that adds life to the scene. While the painting is full of majestic, well-groomed cats, the moth introduces a moment of playfulness and realism — a reminder that no matter how elegant the setting, cats are still curious hunters at heart.\n\nThis painting is often called “the world’s greatest painting of cats”, as it celebrates the affection and eccentric charm of feline companions.",
                       areas: [
                        ClickableArea(idArea: UUID(),
                                      hintText: "the central cat",
                                      pictureName: "MyWifeLovers_centralCat",
                                      avatarName: "MyWifeLovers_centralCat_av"),
                        ClickableArea(idArea: UUID(),
                                      hintText: "the shadow cat",
                                      pictureName: "MyWifeLovers_blackCat",
                                      avatarName: "MyWifeLovers_blackCat_av"),
                        ClickableArea(idArea: UUID(),
                                      hintText: "the red proud cat",
                                      pictureName: "MyWifeLovers_redCat",
                                      avatarName: "MyWifeLovers_redCat_av"),
                        ClickableArea(idArea: UUID(),
                                      hintText: "a moth",
                                      pictureName: "MyWifeLovers_moth",
                                      avatarName: "MyWifeLovers_moth_av"),
                        ClickableArea(idArea: UUID(),
                                      hintText: "the brat cat",
                                      pictureName: "MyWifeLovers_bratCat",
                                      avatarName: "MyWifeLovers_bratCat_av"),
                        ClickableArea(idArea: UUID(),
                                      hintText: "the stuck cat",
                                      pictureName: "MyWifeLovers_stuckCat",
                                      avatarName: "MyWifeLovers_stuckCat_av"),
                       ]),
    ]
}
