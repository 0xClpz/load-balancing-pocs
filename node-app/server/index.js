const app = require('express')()

const emojis = ["🔥", "😂", "⚡️", "🎉", "😏", "🎃", "🥖", "🍉"]

const randomServerId = emojis[Math.floor(Math.random() * emojis.length)]

app.get('/', (req, res) => {
  res.json({foo: randomServerId})
})

app.listen(8080, () => {
  console.log(`Server up and running at port 8080`)
})
