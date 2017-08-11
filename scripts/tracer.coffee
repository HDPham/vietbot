# Description:
#   Sends an image of Tracer from Overwatch
#
# Dependencies:
#   "imgurwrap": "0.0.4"
#
# Configuration:
#   IMGUR_CLIENT_ID
#
# Commands:
#   hubot tracer  - Sends an image of Overwatch Tracer
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


module.exports = (robot) ->
    robot.respond /tracer/i, (msg) ->
        imagePath = __dirname + '/tracer.jpg'
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Ever get that feeling of deja vu?'
        description: 'Dont worry luv, cavalrys here!'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return