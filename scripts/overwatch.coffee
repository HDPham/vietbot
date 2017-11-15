# Description:
#   Sends an image of Overwatch Heroes
#
# Dependencies:
#   "imgurwrap": "0.0.4"
#
# Configuration:
#   IMGUR_CLIENT_ID
#
# Commands:
#   hubot overwatch <hero>  - Sends an image of Overwatch Tracer
# 
# Notes:
#   Uses Imgur API
# 
# Author:
#   Hung Pham

imgurwrap = require('../node_modules/imgurwrap/src/imgurwrap.js')
fs = require('fs')
# imgurwrap.setUserAgent('imgurwrap default useragent v1.1'); # Replace with your CleintID
imgurwrap.setClientID(process.env.IMGUR_CLIENT_ID)

ana = [
    '/overwatch_images/ana_1.jpg',
    '/overwatch_images/ana_2.jpg',
]

bastion = [
    '/overwatch_images/bastion_1.jpg',
]

doomfist = [
    '/overwatch_images/doomfist_1.png',
]

dva = [
    '/overwatch_images/dva_1.jpg',
    '/overwatch_images/dva_2.jpg',
    '/overwatch_images/dva_3.jpg',
]

genji = [
    '/overwatch_images/genji_1.jpg',
    '/overwatch_images/genji_2.jpg',
]

hanzo = [
    '/overwatch_images/hanzo_1.png',
]

junkrat = [
    '/overwatch_images/junkrat_1.jpg',
    '/overwatch_images/junkrat_2.jpg',
]

lucio = [
    '/overwatch_images/lucio_1.jpg',
    '/overwatch_images/lucio_2.jpg',
]

mccree = [
    '/overwatch_images/mccree_1.jpg',
]

mei = [
    '/overwatch_images/mei_1.jpg',
    '/overwatch_images/mei_2.jpg',
]

mercy = [
    '/overwatch_images/mercy_1.jpg',
    '/overwatch_images/mercy_2.jpg',
]

moira = [
    '/overwatch_images/moira_1.jpg',
]

orisa = [
    '/overwatch_images/orisa_1.jpg',
]

pharah = [
    '/overwatch_images/pharah_1.jpg',
]

reaper = [
    '/overwatch_images/reaper_1.jpg',
    '/overwatch_images/reaper_2.jpg',
]

reinhardt = [
    '/overwatch_images/reinhardt_1.jpg',
]

roadhog = [
    '/overwatch_images/roadhog_1.jpg',
    '/overwatch_images/roadhog_2.jpg',
]

soldier76 = [
    '/overwatch_images/soldier76_1.jpg',
    '/overwatch_images/soldier76_2.jpg',
]

sombra = [
    '/overwatch_images/sombra_1.jpg',
]

symmetra = [
    '/overwatch_images/symmetra_1.jpg',
]

torbjorn = [
    '/overwatch_images/torbjorn_1.jpg',
]

tracer = [
    '/overwatch_images/tracer_1.jpg',
    '/overwatch_images/tracer_2.jpg',
]

widowmaker = [
    '/overwatch_images/widowmaker_1.jpg',
    '/overwatch_images/widowmaker_2.jpg',
]

winston = [
    '/overwatch_images/winston_1.png',
    '/overwatch_images/winston_2.jpg',
]

zarya = [
    '/overwatch_images/zarya_1.jpg',
]

zenyatta = [
    '/overwatch_images/zenyatta_1.jpg',
]

module.exports = (robot) ->
    robot.respond /overwatch ana/i, (msg) ->
        imagePath = __dirname + (msg.random ana)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Never stop fighting for what you believe in.'
        description: 'Everyone must find their cause.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch bastion/i, (msg) ->
        imagePath = __dirname + (msg.random bastion)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Boo doo boo doo!'
        description: 'Dah-dah weeeee!'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch doomfist/i, (msg) ->
        imagePath = __dirname + (msg.random doomfist)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Only through conflict do we evolve.'
        description: 'One punch is all I need.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch dva/i, (msg) ->
        imagePath = __dirname + (msg.random dva)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'I play to win!'
        description: 'Love, D.Va.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch genji/i, (msg) ->
        imagePath = __dirname + (msg.random genji)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Mi o sutete mo, myōri wa sutezu.'
        description: 'A steady blade balances the soul.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch hanzo/i, (msg) ->
        imagePath = __dirname + (msg.random hanzo)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'With every death, comes honor. With honor, redemption.'
        description: 'From one thing, know ten thousand things.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch junkrat/i, (msg) ->
        imagePath = __dirname + (msg.random junkrat)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'It\'s a perfect day for some mayhem.'
        description: 'If at first you don\'t succeed... Blow it up again!'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch lucio/i, (msg) ->
        imagePath = __dirname + (msg.random lucio)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Come on, let\'s bring it together!'
        description: 'Give yourself to the rhythm.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch mccree/i, (msg) ->
        imagePath = __dirname + (msg.random mccree)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Justice ain\'t gonna dispense itself.'
        description: 'You seem familiar. Ain\'t I killed you before?'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch mei/i, (msg) ->
        imagePath = __dirname + (msg.random mei)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Our world is worth fighting for.'
        description: 'Hang in there. Zhège shìjiè zhídé wǒmen fènzhàn!'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch mercy/i, (msg) ->
        imagePath = __dirname + (msg.random mercy)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'I\'ll be watching over you.'
        description: 'I\'ll send you my consultation fee.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch moira/i, (msg) ->
        imagePath = __dirname + (msg.random moira)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Science will reveal the truth.'
        description: 'What an interesting hypothesis.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return

    robot.respond /overwatch tracer/i, (msg) ->
        imagePath = __dirname + (msg.random tracer)
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Cheers, love! The cavalry\'s here!'
        description: 'You know, the world could always use more heroes.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return