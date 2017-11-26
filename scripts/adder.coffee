# Description:
#   Add group to channel.
#
# Board Commands:
#   hubot add <board, interns> - Helps add <board> or <interns> to channel.
#
# Author:
#   Hung Pham

board = [
    "@tylertran", 
    "@isaac_ngo98", 
    "@ericatran22", 
    "@kalsgomoo", 
    "@hpham", 
    "@ulneelia", 
    "@apham", 
    "@dpoon12", 
    "@cynosaur", 
    "@baotranle98", 
    "@phidang", 
    "@nicholasvo", 
    "@christinatran" 
]

module.exports = (robot) ->
    robot.respond /interns\s*?$/i, (res) ->
        res.send 'There are no interns at the moment.'

    robot.respond /board\s*?$/i, (res) ->
        retval = 'Copy and paste the list of board members into your chat and send the message. Then, accept all dialogues (Click "Yes, show chanel history").\n'
        retval += board.join(' ')
        # res.send '@tylertran @isaac_ngo98 @ericatran22 @kalsgomoo @hpham @ulneelia @apham @dpoon12 @cynosaur @baotranle98 @phidang @nicholasvo @christinatran'
        res.send retval