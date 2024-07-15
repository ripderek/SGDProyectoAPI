const { Router } = require("express");
const router = Router();

//importar el modulo empresa controller
const {
  datos_Empresa,
  imagen_empresa,
} = require("../controllers/Empresa/empresa-controller");
const {
  proyectos_publicados,
} = require("../controllers/Proyects/proyects-controller");
const {
  recuperar_cuenta,
  recuperar_cuenta_contrasena,
} = require("../controllers/Users/users-controller");
const { ver_word } = require("../controllers/Proyects/proyects-controller");

router.get("/Datos_Empresa", datos_Empresa);
router.get("/Imagen_Empresa", imagen_empresa);
router.get("/Proyectos", proyectos_publicados);
router.post("/Recuperar_cuenta", recuperar_cuenta);
router.post("/Recuperar_cuenta_contrasena", recuperar_cuenta_contrasena);
router.get("/word/:id", ver_word);

module.exports = router;
