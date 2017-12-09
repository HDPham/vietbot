// Description:
//  Generates an image of Overwatch Play of the Game with a user's name.

// Dependencies:
//  "imgurwrap": "0.0.4"
//  "jimp": "^0.2.28"

// Configuration:
//  IMGUR_CLIENT_ID

// Commands:
//  hubot potg <user> - Award <user> the POTG

// Notes:
//  Uses Imgur API

// Author:
//  Hung Pham


imgurwrap = require('../node_modules/imgurwrap/src/imgurwrap.js');
Jimp = require("jimp");
fs    = require("fs"),

imgurwrap.setClientID(process.env.IMGUR_CLIENT_ID);

module.exports = function(robot) {
    robot.respond(/potg (.*)/i, function(msg){
        var name = msg.match[1];
        var nameCorrected = (name[0] == '@') ? name.substring(1,name.length) : name;

        var imagePath;
        var character;
        var choice = Math.round(Math.random() * 100)%5 + 1;

        switch (choice) {
        case 1:
            imagePath = __dirname + '/resources/edgelord.jpg';
            character = "AS REAPER";
            break;
        case 2:
            imagePath = __dirname + '/resources/dva.jpg';
            character = "AS DVA";
            break;
        case 3:
            imagePath = __dirname + '/resources/genji.jpg';
            character = "AS GENJI";
            break;
        case 4:
            imagePath = __dirname + '/resources/mei.jpg';
            character = "AS MEI";
            break;
        case 5:
            imagePath = __dirname + '/resources/phara.jpg';
            character = "AS PHARA";
            break;
        default:
            imagePath = __dirname + '/resources/edgelord.jpg';
            character = "AS REAPER";
            break;
        }

        var nameFontPath = __dirname + '/resources/name.fnt';
        var text1FontPath = __dirname + '/resources/text1.fnt';
        var text2FontPath = __dirname + '/resources/text2.fnt';
        var tempPath = __dirname + '/temp.jpg'

        Jimp.read(imagePath, function(err, image){
            if (err) throw err;
            Jimp.loadFont( nameFontPath, function(err, nameFont){
                if (err) throw err;
                Jimp.loadFont(text1FontPath, function(err, text1Font){
                    if (err) throw err;
                    Jimp.loadFont(text2FontPath, function(err, text2Font){
                        if (err) throw err;
                        image.print(text1Font, 140, 426, "PLAY OF THE GAME");
                        image.print(nameFont, 190, 500, nameCorrected);
                        image.print(text2Font, 200, 597, character);
                        image.write( tempPath, function(err, res){
                            var imageData = fs.readFileSync(tempPath);
                            var url;
                            imgurwrap.uploadImageFile({
                                image: imageData,
                                title: 'PLAY OF THE GAME',
                                description: 'Generated POTG'
                            }, function(err, res){
                                url = 'http://www.imgur.com/' + res.data.id;
                                // console.log(this);
                                msg.send(url);
                            });
                        });
                    });
                });
            });
        });

        msg.send("Generating POTG... Be patient, this will take a few seconds!");
    });
}
