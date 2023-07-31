const { Router } = require('express');
const router = Router();


//importar el modulo empresa controller 
const { datos_Empresa, imagen_empresa } = require('../controllers/Empresa/empresa-controller');


router.get('/Datos_Empresa', datos_Empresa);
router.get('/Imagen_Empresa', imagen_empresa);

module.exports = router;