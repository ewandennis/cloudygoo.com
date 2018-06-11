---
title: What Colour Is That Smartie?
layout: article.njk
tags: coding
created: 2016-12-30T12:00:00
---

When I was a child, Smarties were brightly coloured, candy coated, chocolate ovoids and they still are. Back then, they came in cylindrical tubes with a letter of the alphabet on the inside of the lid. I remember pink, purple, green, yellow, orange, red, light brown and dark brown Smarties. Later on, the manufacturer (Nestl&eacute;) replaced light brown with blue - a milestone in my childhood.

Oddly enough, only the orange ones were orange flavoured, the rest were just chocolatey. On a quest to single out all the orange Smarties, I spent my festive downtime a few years ago designing and building a Smartie colour sorting machine. Here it is:

![Smarticulator Mk I](/media/SmarticulatorProjections.png)

Building the Smarticulator was a great way to explore CAD, microcontrollers, motor control, sensor calibration and various other fields with occasional dips into food science and chocolate overdose along the way. The most unexpectedly interesting part was learning how to use a colour sensor to recognise the various Smartie colours and so that is the topic of this little post.

### The Sensor

The device I used in the Smarticulator was a little RGB colour sensor ([TCS34725](http://www.adafruit.com/datasheets/TCS34725.pdf)) which would conveniently provide red, green, blue and clear samples of whatever one put in front of it.

Once I had built my machine and put the colour sensor in place, I wanted to start putting Smarties through for a first look at some sensor data.  I wasn't sure if the colour of the machine (white) or lighting (highly variable) would affect my ability to tell Smartie colours apart.

First though, I had to buy a boatload of Smarties...

### Side Note: The Southampton Six

Some time in the 2000's, consumers had begun to learn a little about food additives. Artificial food colouring and in particular the ["Southampton Six"](https://www.food.gov.uk/science/research/chemical-safety-research/additives-research/t07040) had been linked to attention deficit and hyperactivity in children. In response, Nestl&eacute; started using natural dyes in Smarties.

I didn't know about that when I bought my test Smarties and so I was a tiny bit scandalised when they didn't perfectly match my childhood memories.

![Smarties, old and new](/media/Smarties_old_new-sml-1.png)

That image is by John Penton and Paul Hughes - their own work, [CC BY-SA 2.5](https://commons.wikimedia.org/w/index.php?curid=1791232). It came from the [Smarties Wikipedia page](https://en.wikipedia.org/wiki/Smarties), which is recommended reading.

An unfortunate side-effect of Nestl&eacute;'s move to natural colouring was lower contrast and less differentiation between colours. Look at the orange, red and brown ones on the bottom row. I just knew those were going to be difficult to sort. 

### What *@^%ing Colour Is That Smartie?

![How not to classify Smarties](/media/BrownOrPink.jpg)

Having read about the Southampton Six, I knew I needed a rigorous way to sort my Smarties by colour. I wanted to feed test Smarties through my colour sensor into some Clever Box that could group similarly coloured ones together. Then I would use those groups to sort all future Smarties. I also wanted to avoid labelling every test Smartie by colour beforehand because I had _a lot_ of Smarties and I'm basically lazy.

In the end, I settled on the [k-means clustering](https://en.wikipedia.org/wiki/K-means_clustering) algorithm which estimates a representative or _mean_ value for each of _k_ types of thing, given a load of examples.

I had 8 types of Smartie to account for: one for each colour. My colour sensor produced some rather muddy-looking red-green-blue (RGB) triplets (below left) from about 150 test Smarties but with k-means clustering I was able to produce a representative sensor reading for each Smartie (below right).

![](/media/SamplesAndClusters.png)

Given those representative or _colour group_ readings for each colour, the Smarticulator could "read" a Smartie, check which colour group it belonged to and put it with all the others of the same colour.

If you read this far, you might notice that I couldn't know which colour group matched with which colour name. The k-means algorithm produced 8 groups from all my test Smarties but I didn't know which was red, yellow, brown and so on. I suppose I could have tested 1 Smartie of each colour against my representative values but I didn't bother because I'm still lazy. I just built the machine knowing it could tell each colour apart.

After all that, the Smarticulator worked nicely for the most part. It predictably mis-filed the occasional orange for a brown, which makes sense given how close their colour groups are on the pic above. I imagine tighter control over the sensor's lighting and some more careful Smartie sampling might have helped there. I may also have eaten too many orange Smarties during testing so my results were skewed.

Anyway, I hope my colourful little holiday journey was diverting. It was an entertaining topic with lots of geeky avenues to get lost in. To finish up, here's the Smarticulator in action:

![The Smarticulator is smarticulating](/media/SmarticulatorInAction.jpg)
