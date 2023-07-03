const { Router } = require('express');
const router = Router();

//middleware para guardar las fotos de perfil 
//requerio el middle de multer 
const { upload } = require('../middleware/multer_perfil');

const { crear_usuario, datos_Usuarios, all_data_users, imagen_user } = require('../controllers/Users/users-controller');

router.post('/crear_usuario', upload.single('file'), crear_usuario);
router.get('/User/:id', datos_Usuarios);
router.get('/Userdata', all_data_users);
router.get('/foto/:id', imagen_user)

module.exports = router;