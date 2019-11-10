const app = require('express')()

app.get('/', (req, res) => {
  res.json({foo: 'bar'})
})

app.listen(8080, () => {
  console.log(`Server up and running at port 8080`)
})
