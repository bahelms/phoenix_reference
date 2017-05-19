import Player from './player'

let Video = {
  init(socket, element) {
    if (!element) { return }

    let playerID = element.getAttribute('data-player-id')
    let videoID = element.getAttribute('data-id')
    socket.connect()
    Player.init(element.id, playerID, () => {
      this.onReady(videoID, socket)
    })
  },

  onReady(videoID, socket) {
    let msgContainer = document.getElementById('msg-container')
    let msgInput = document.getElementById('msg-input')
    let postButton = document.getElementById('msg-submit')
    let vidChannel = socket.channel(`videos:${videoID}`)
    // TODO join vidChannel
  }
}

export default Video
