function echoSend(params) {
    window.webkit.messageHandlers.echoSend.postMessage(params)
}
