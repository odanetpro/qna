document.addEventListener('animationstart', function(event) {
  if (event.animationName == 'gist_link_inserted') {
    const Gh3 = require("vendor/gh3")
    const gistId = event.target.dataset.gistId
    const oneGist = new Gh3.Gist({id: gistId})

    oneGist.fetchContents(function (err, res) {
      if(err) {
        throw "outch ..."
      }

      let gistContent = ""
      oneGist.eachFile(function (file) {
        gistContent += "<div class='gist-content'>" + file.content + "</div>"
      })

      $(event.target).replaceWith(gistContent)
    })
  }
})
