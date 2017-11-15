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


module.exports = (robot) ->
    robot.respond /overwatch tracer/i, (msg) ->
        imagePath = __dirname + '/tracer_1.jpg'
        imageData = fs.readFileSync(imagePath)

        imgurwrap.uploadImageFile {
        image: imageData
        title: 'Cheers, love! The cavalry\s here!'
        description: 'You know, the world could always use more heroes.'
        }, (err, res) ->
            url = 'http://www.imgur.com/' + res.data.id
            # console.log(this);
            console.log url
            msg.send url
            return            
        return
    return