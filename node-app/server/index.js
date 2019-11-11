const app = require('express')()

const emojis = ["🔥", "😂", "⚡️", "🎉", "😏", "🎃", "🥖", "🍉"]

const randomServerId = () => emojis[Math.floor(Math.random() * emojis.length)]

const serverID = `Server ID: ${randomServerId()}${randomServerId()}`
app.get('/', (req, res) => {
  res.send(serverID)
})

app.listen(8080, () => {
  console.log(`Server up and running at port 8080`)
})
