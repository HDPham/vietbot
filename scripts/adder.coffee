# Description:
#   Add group to channel.
#
# Commands:
#   hubot add <board, interns> - Helps add <board> or <interns> to channel.
#
# Author:
#   Hung Pham


module.exports = (robot) ->
    robot.respond /interns/i, (res) ->
        res.send 'There are no interns at the moment.'

    robot.respond /board/i, (res) ->
        res.send 'Copy and paste the list of board members into your chat and send the message. Then, accept all dialogues. (Click "Yes, show chanel history")'

        res.send '@tylertran @isaac_ngo98 @ericatran22 @kalsgomoo @hpham @ulneelia @apham @dpoon12 @cynosaur @baotranle98 @phidang @nicholasvo @christinatran'