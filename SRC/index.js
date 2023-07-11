const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const cookieParser = require('cookie-parser');

//Este middleware se ejecuta antes de entrar a una ruta protegida, es decir, se necesita un token valido para acceder
const { authenticateToken } = require('./middleware/authorization.js');


//variable donde se importa las rutas
const authRoutes = require('./routes/auth-routes.js');
const userRoutes = require('./routes/users-routes.js');
const areaRoutes = require('./routes/area-routes.js');
const proyectsRoutes = require('./routes/proyects-routes.js');

//config entorno
dotenv.config();

//Consfigurar el puerto donde se va abrir la API
const app = express();
const PORT = 4000;
const corsOptions = { credentials: true, origin: "http://localhost:3000" };

app.use(cors(corsOptions));
app.use(express.json());
app.use(cookieParser());

//Las rutas estan separadas por archivos 
//esta ruta no estara protegida por un middleware ya que serivira para verificar el
//inicio de sesion
app.use('/api/auth', authRoutes);

//rutas protegidas con middleare, es decir, se necesita un token valido para acceder
app.use('/api/user', authenticateToken, userRoutes);
app.use('/api/area', authenticateToken, areaRoutes);
app.use('/api/proyects', authenticateToken, proyectsRoutes);


//Iniciar la API
app.listen(PORT, () => console.log('SERVER ON PORT' + PORT));