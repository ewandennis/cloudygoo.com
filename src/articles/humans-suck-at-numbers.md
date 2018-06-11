---
title: Humans Suck At Numbers
layout: article.njk
tags: coding
created: 2017-03-25T12:00:00
navImage: theprisonerquote-3.png
---

#### Requirements For Human-Centric Record Locators

Commercial institutions of all shapes and sizes use numbers to identify their records but humans generally have trouble memorising, recognising and even just reading numbers back correctly. Using a hand-written account number to transfer cash is dicy at best and speaking your "customer reference" over a mobile phone can be downright comical, especially if you have a good strong accent. I spent some time recently looking for a better way and these are my findings.

##### Background

> **Record Locator** _(noun)_ : a  value used to uniquely identify a person, account, object or concept in some filing system. Usually numeric.

Record locators are everywhere. You'll typically see them on your bank and utility accounts, use them to place and receive phone calls, for tracking shipping, shopping, shacking up, shuttling packages around and generally anywhere people interact with products and services.

Record locators exist as a handle on that terse and indigestible but prolific form of information: the venerable customer record.

##### Motivation: Put The Customer First
Consider for a moment the total number of people involved in the creation and use of your phone company's invoicing system. Let's say **100 engineers** designed, built and deployed PhoneBill2000&trade; and a conservative **10,000 phone company employees** now interact with it. Now consider the **2,000,000 customers** with records stored in that system. **The customers in this ecosystem outnumber operators by 100s to 1** so why aren't those services more tailored for the many, the common case, the customer?

[Some](https://www.amazon.com/) services have managed to hide their record locators or at least made them less prevalent and it's quite possible these days to phone some utility companies and do business with them with only your identity in hand. [Plenty](http://home.bt.com/) [of](http://www.britishgas.co.uk/) [situations](http://www.royalmail.com/) still require opaque record locators though so finding alternatives is still a worthwhile endeavour, in my opinion.

##### What Humans Need

> "I will not be pushed, filed, stamped, indexed, briefed, debriefed, or numbered! My life is my own!"

> \- Number Six, The Prisoner (1967)

A more human-centric record locator might use features that humans are comfortable with, presumably making more natural use of human language than a list of digits. I'll codify those needs here:

**Human-centric record locator requirements:**

1. memorable
1. difficult to mis-type or mis-recite
1. difficult to accidentally clash with another locator
1. abundant: enough identifiers to go around
1. more fun than a bunch of numbers

##### What Commerce Needs

In defence of the commercial world, it is _supremely_ easy just to number things when you have to manage lots of them. It's easy for Customer Service reps to look you up by number, for their tools to index you by number and for the authors of those tools to store and retrieve their records by number.

So to have any chance of being used in new services or retro-fitted to existing ones, any alternative locator scheme needs to fit the established body of machine-centric record keeping systems.

**Commercial record locator requirements:**

1. unique
1. indexable
1. easy to map to/from existing numeric locators

##### Prior Art

Attempts have been made at encoding machine centric information in a people safe manner. The privacy tool PGP used a word list for communicating raw data in a human-comfortable manner. For example, this PHP public key fingerprint:

```
E582 94F2 E9A2 2748 6E8B
061B 31CC 528F D7FA 3F19
```

translates to:

```
topmost Istanbul Pluto vagabond
treadmill Pacific brackish dictator
goldfish Medusa afflict bravado
chatter revolver Dupont midsummer
stopwatch whimsical cowbell bottomless
```

[The designers](https://en.wikipedia.org/wiki/PGP_word_list) rather ingeniously spent time selecting words that were phonetically different so they wouldn't be mistaken for each other when spoken.

PaaS provider Heroku did something similar by assigning *mostly* human readable names to customer applications in the form `adjective-noun-number`. For example:

`https://tranquil-taiga-3844.herokuapp.com/`

These are both interesting developments but they don't fully obsolete the record locator. PGP's goal was to simplify the recital of long encryption key fingerprints and arguably it succeeded. The use of well chosen words in place of numbers offers a useful pattern.

Heroku's intent was to make their service fun while upholding the unique naming laws of the Internet; also a success but for that unfortunate numeral appendage, added presumably to swell the available space of identifiers.

So far we have a set of requirements for a more human-centric unique identifier. Next I'll follow up by exploring a solution that meets those requirements. I hope you enjoyed this little flight of fancy. You can follow my [occasional 140-char outpourings at @ewanovitch](https://twitter.com/ewanovitch) and my [personal code ramblings on GitHub](https://github.com/ewandennis). 
