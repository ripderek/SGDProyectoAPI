const { Router } = require('express');
const router = Router();


const { crear_nivel, ver_niveles, ver_niveles_activos, crear_jerarquias_nivel, ver_tipos_jerarquias, ver_detalles__flujos, ver_tipos_jerarquias_activas, ver_detalles_niveles, crear_flujo_proyecto, crear_flujo_proyecto_categoria } = require("../controllers/Proyects/flujo-controller");
router.post("/CrearNivel", crear_nivel);
router.get("/Ver_niveles", ver_niveles);
router.get("/Ver_niveles_activos", ver_niveles_activos);
router.post("/Crear_Jerarquias_Niveles/:id", crear_jerarquias_nivel);
router.get("/Ver_tipos_jerarquias", ver_tipos_jerarquias);
router.get("/Ver_flujo/:id", ver_detalles__flujos);
router.get("/Ver_jerarquias_activas", ver_tipos_jerarquias_activas);
router.get("/Ver_niveles_detalles/:id", ver_detalles_niveles);
router.post("/Crear_FLujo/:id/:id2", crear_flujo_proyecto);
router.post("/Crear_FLujo_CAT/:id/:id2", crear_flujo_proyecto_categoria);

module.exports = router;