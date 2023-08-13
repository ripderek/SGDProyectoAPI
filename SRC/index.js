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
const empresaRoutes = require('./routes/empresa-routes.js');
const publicRoutes = require('./routes/public-routes.js');
//----------------NUEVO-----------------------
const googleRoutes = require("./routes/google-routes.js");
const flujoRoutes = require('./routes/flujo-routes.js');

//config entorno
dotenv.config();

//Consfigurar el puerto donde se va abrir la API
const app = express();
const PORT = 4000;
//http://192.168.56.1:3000
const corsOptions = { credentials: true, origin: "http://localhost:3000" };

app.use(cors(corsOptions));
app.use(express.json());
app.use(cookieParser());

//Las rutas estan separadas por archivos 
//esta ruta no estara protegida por un middleware ya que serivira para verificar el
//inicio de sesion
app.use('/api/auth', authRoutes);
//acceso publico 
app.use('/api/public', publicRoutes);
//----------NUEVO-----------------------------------------
app.use('/api/authgoogle', googleRoutes);
//----------NUEVO-----------------------------------------


//rutas protegidas con middleare, es decir, se necesita un token valido para acceder
app.use('/api/user', authenticateToken, userRoutes);
app.use('/api/area', authenticateToken, areaRoutes);
app.use('/api/proyects', authenticateToken, proyectsRoutes);
app.use('/api/empresa', authenticateToken, empresaRoutes);
app.use('/api/flujo', authenticateToken, flujoRoutes);

//Iniciar la API
app.listen(PORT, () => console.log('SERVER ON PORT' + PORT));