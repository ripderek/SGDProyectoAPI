const { Router } = require('express');
const router = Router();


const { crear_nivel } = require("../controllers/Proyects/flujo-controller");
router.post("/CrearNivel", crear_nivel);

module.exports = router;