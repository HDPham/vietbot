# Description:
#   Generates an image of Overwatch Play of the Game with a user's name.
#
# Dependencies:
#   "imgurwrap": "0.0.4"
#   "jimp": "^0.2.28"
#
# Configuration:
#   IMGUR_CLIENT_ID
#
# Commands:
#   hubot potg <user> - Award <user> the POTG
# 
# Notes:
#   Uses Imgur API
# 
# Author:
#   Hung Pham

imgurwrap = require('../node_modules/imgurwrap/src/imgurwrap.js')
Jimp = require('jimp')
fs = require('fs')
imgurwrap.setClientID(process.env.IMGUR_CLIENT_ID)

module.exports = (robot) ->
    robot.respond /potg (.*)/i, (msg) ->
        name = msg.match[1]
        nameCorrected = if name[0] is '@' then name.substring(1, name.length) else name
        choice = Math.round(Math.random() * 100) % 5 + 1

        switch choice
            when 1
                imagePath = __dirname + '/resources/edgelord.jpg'
                character = 'AS REAPER'
                break
            when 2
                imagePath = __dirname + '/resources/dva.jpg'
                character = 'AS DVA'
                break
            when 3
                imagePath = __dirname + '/resources/genji.jpg'
                character = 'AS GENJI'
                break
            when 4
                imagePath = __dirname + '/resources/mei.jpg'
                character = 'AS MEI'
                break
            when 5
                imagePath = __dirname + '/resources/phara.jpg'
                character = 'AS PHARA'
                break
            else
                imagePath = __dirname + '/resources/edgelord.jpg'
                character = 'AS REAPER'
                break
        
        nameFontPath = __dirname + '/resources/name.fnt'
        text1FontPath = __dirname + '/resources/text1.fnt'
        text2FontPath = __dirname + '/resources/text2.fnt'
        tempPath = __dirname + '/temp.jpg'
        Jimp.read imagePath, (err, image) ->
            if err
                throw err
            Jimp.loadFont nameFontPath, (err, nameFont) ->
                if err
                    throw err
                Jimp.loadFont text1FontPath, (err, text1Font) ->
                    if err
                        throw err
                    Jimp.loadFont text2FontPath, (err, text2Font) ->
                        if err
                            throw err
                        image.print text1Font, 140, 426, 'PLAY OF THE GAME'
                        image.print nameFont, 190, 500, nameCorrected
                        image.print text2Font, 200, 597, character
                        image.write tempPath, (err, res) ->
                            imageData = fs.readFileSync(tempPath)
                            imgurwrap.uploadImageFile {
                                image: imageData
                                title: 'PLAY OF THE GAME'
                                description: 'Generated POTG'
                            }, (err, res) ->
                                url = 'http://www.imgur.com/' + res.data.id
                                # console.log(this);
                                msg.send url
            msg.send 'Generating POTG... Be patient, this will take a few seconds!'