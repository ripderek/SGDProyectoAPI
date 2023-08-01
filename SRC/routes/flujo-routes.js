const { Router } = require('express');
const router = Router();


const { crear_nivel, ver_niveles, ver_niveles_activos, crear_jerarquias_nivel } = require("../controllers/Proyects/flujo-controller");
router.post("/CrearNivel", crear_nivel);
router.get("/Ver_niveles", ver_niveles);
router.get("/Ver_niveles_activos", ver_niveles_activos);
router.post("/Crear_Jerarquias_Niveles/:id", crear_jerarquias_nivel);

module.exports = router;