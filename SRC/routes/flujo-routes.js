const { Router } = require('express');
const router = Router();


const { crear_nivel, ver_niveles } = require("../controllers/Proyects/flujo-controller");
router.post("/CrearNivel", crear_nivel);
router.get("/Ver_niveles", ver_niveles);

module.exports = router;