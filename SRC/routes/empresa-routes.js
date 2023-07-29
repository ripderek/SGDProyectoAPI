const { Router } = require('express');
const router = Router();

//para almacenar la imagen
const { upload } = require('../middleware/multer_perfil');

//importar el modulo empresa controller 
const { modificar_empresa, cambiar_foto } = require('../controllers/Empresa/empresa-controller');


router.post('/Editar/:id', modificar_empresa);
router.post('/Cambiar_Foto', upload.single('file'), cambiar_foto);

module.exports = router;