const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

app.use('/auth', require('./routes/auth'));
//Se comentA hasta que tengamos las credenciales de MP
//app.use('/payments', require('./routes/payments'));
app.use('/videos', require('./routes/videos'));

app.listen(process.env.PORT, () => {
  console.log(`Servidor corriendo en puerto ${process.env.PORT}`);
});
