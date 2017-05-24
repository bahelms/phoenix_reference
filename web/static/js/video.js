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

    postButton.addEventListener('click', e => {
      let payload = {body: msgInput.value, at: Player.getCurrentTime()}
      vidChannel.push('new_annotation', payload).receive('error', e => console.log(e))
      msgInput.value = ''
    })

    vidChannel.on('new_annotation', (resp) => {
      this.renderAnnotation(msgContainer, resp)
    })

    vidChannel.join()
      .receive('ok', resp => console.log('Joined the video channel', resp))
      .receive('error', resp => console.log('Join failed', resp))
  },

	esc(str){
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },

  renderAnnotation(msgContainer, {user, body, at}) {
		let template = document.createElement("div")

    template.innerHTML = `
    <a href="#" data-seek="${this.esc(at)}">
      <b>${this.esc(user.username)}</b>: ${this.esc(body)}
    </a>
    `
    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  }
}

export default Video
