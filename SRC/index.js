const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const cookieParser = require("cookie-parser");
const http = require("http");
const { Server } = require("socket.io");

const Connection = require("./db_m.js");
const {
  saveDocument,
  getDocumentContent,
} = require("./controllers/Document/document-controller.js");
const Delta = require("quill-delta");

//Este middleware se ejecuta antes de entrar a una ruta protegida, es decir, se necesita un token valido para acceder
const { authenticateToken } = require("./middleware/authorization.js");

//variable donde se importa las rutas
const authRoutes = require("./routes/auth-routes.js");
const userRoutes = require("./routes/users-routes.js");
const areaRoutes = require("./routes/area-routes.js");
const proyectsRoutes = require("./routes/proyects-routes.js");
const empresaRoutes = require("./routes/empresa-routes.js");
const publicRoutes = require("./routes/public-routes.js");
const googleRoutes = require("./routes/google-routes.js");
const flujoRoutes = require("./routes/flujo-routes.js");
const firmaRoutes = require("./routes/firmas-routes.js");
const chats = require("./routes/chats-routes.js")
const { Socket } = require("dgram");

//config entorno
dotenv.config();

//Consfigurar el puerto donde se va abrir la API
const app = express();

const PORT = 4000;
//http://192.168.56.1:3000
//const corsOptions = { credentials: true, origin: "http://localhost:3000" };
//https://z8zbh18v-3000.use2.devtunnels.ms/
//const corsOptions = { credentials: true, origin: "https://z8zbh18v-3000.use2.devtunnels.ms" };
//const corsOptions = { credentials: true, origin: "http://localhost:3000" };
const corsOptions = {
  origin: (origin, callback) => {
    callback(null, true);
  },
  credentials: true, // Permitir credenciales
};
app.use(cors(corsOptions));
app.use(express.json());
app.use(cookieParser());

//Las rutas estan separadas por archivos
//esta ruta no estara protegida por un middleware ya que serivira para verificar el
//inicio de sesion
app.use("/api/auth", authRoutes);
//acceso publico
app.use("/api/public", publicRoutes);
//inicio con google
app.use("/api/authgoogle", googleRoutes);

//Prueba con las firmas
app.use("/api/firma", firmaRoutes);

//rutas protegidas con middleare, es decir, se necesita un token valido para acceder
app.use("/api/user", authenticateToken, userRoutes);
app.use("/api/area", authenticateToken, areaRoutes);
app.use("/api/proyects", authenticateToken, proyectsRoutes);
app.use("/api/empresa", authenticateToken, empresaRoutes);
app.use("/api/flujo", authenticateToken, flujoRoutes);
app.use("/api/chats",authenticateToken,chats);

//Iniciar la API
app.listen(PORT, () => console.log("SERVER ON PORT" + PORT));

//Api editor
const PORT2 = 9000;
Connection();
const server = http.createServer();
const io = new Server(server, {
  cors: {
    origin: "http://localhost:3000",
    methods: ["GET", "POST"],
  },
});

const connectedUsers = {};

io.on("connection", (socket) => {
  let id_proyecto; // Variable para almacenar el ID del proyecto

  socket.on("join-room", async (_id_proyecto) => {
    id_proyecto = _id_proyecto; // Almacena el ID del proyecto en la variable
    socket.join(id_proyecto);
    // Obtener el contenido del documento desde MongoDB
    const content = await getDocumentContent(id_proyecto);
    socket.emit("document-content", content);
    console.log(content);
    if (!connectedUsers[id_proyecto]) {
      connectedUsers[id_proyecto] = [];
    }

    connectedUsers[id_proyecto].push(socket.id);

    io.to(id_proyecto).emit("user-count", connectedUsers[id_proyecto].length);
  });
  socket.on("send-changes", async (data) => {
    const { id_proyecto, content, delta } = data; // Cambio aquí: recibir el contenido completo
    socket.to(id_proyecto).emit("receive-changes", delta); // Cambio aquí: enviar el contenido completo
    try {
      await saveDocument(id_proyecto, content); // Cambio aquí: guardar el contenido completo
    } catch (error) {
      console.error("Error saving document:", error);
    }
  });

  socket.on("typing", ({ id_proyecto, nombre }) => {
    socket.to(id_proyecto).emit("typing", { id_proyecto, nombre });
  });
  socket.on("send-note", (data) => {
    const { id_proyecto, nombre, note } = data;
    socket.to(id_proyecto).emit("receive-note", { nombre, note });
  });

  socket.on("disconnect", () => {
    if (id_proyecto) {
      const index = connectedUsers[id_proyecto].indexOf(socket.id);
      if (index !== -1) {
        connectedUsers[id_proyecto].splice(index, 1);
        io.to(id_proyecto).emit(
          "user-count",
          connectedUsers[id_proyecto].length
        );
      }
    }
  });
});

server.listen(PORT2, () => {
  console.log(`Server is running on port ${PORT2}`);
});
